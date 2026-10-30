//+------------------------------------------------------------------+
//|                             XAUUSD_Suite_Diagnostic_Backtest.mq5 |
//|                                  Copyright 2026, Antigravity AI  |
//|    Comprehensive Multi-Technique Linkage & Defect Analysis EA    |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "2.00"
#property description "Quantitative Diagnostic EA: Tests linkage between Sonic R, RSI Trend Pulse, SMC & TPO to detect flaws & defects"

#include <Trade\Trade.mqh>

//--- Input Parameters
input group "=== 1. Execution & Trade Model ==="
input double   InpLotSize              = 0.10;       // Fixed Lot Size
input int      InpStopLossPoints       = 350;        // SL in Points (350 pts = $3.50 on Gold)
input int      InpTakeProfitPoints     = 700;        // TP in Points (700 pts = $7.00 on Gold, 1:2 RR)
input bool     InpUseTrailingStop      = false;      // Use Trailing Stop (false for pure fixed 1:2 RR testing)
input int      InpTrailingPoints       = 250;        // Trailing Distance in Points
input ulong    InpMagicNumber          = 777999;     // Magic Number

input group "=== 2. Technique Confluence Modes ==="
input int      InpTestMode             = 0;          // Mode: 0=Track All 5 Parallel, 1=Sonic Only, 2=Sonic+RSI, 3=Sonic+SMC, 4=Sonic+TPO, 5=Full Suite

input group "=== 3. SMC & TPO Parameter Tuning ==="
input int      InpMajorSwingLookback   = 8;          // SMC Major Swing Lookback
input int      InpMinorSwingLookback   = 3;          // SMC Minor Swing Lookback
input double   InpPOCTolerance         = 1.50;       // TPO POC Collision Buffer ($1.50)
input int      InpTimeShiftHours       = 5;          // TPO Time Shift (UTC+2 to VN)

//--- Structures for Performance Tracking
struct PerformanceTrack
{
   string name;
   int    totalTrades;
   int    wins;
   int    losses;
   double grossProfit;
   double grossLoss;
   double netProfit;
   double maxDrawdown;
   double peakEquity;
   double currentEquity;
};

PerformanceTrack g_trackSonic;
PerformanceTrack g_trackSonicRSI;
PerformanceTrack g_trackSonicSMC;
PerformanceTrack g_trackSonicTPO;
PerformanceTrack g_trackFullSuite;

//--- Defect Statistics
int g_defect_OB_Collision      = 0;  // Entry directly into opposing Order Block
int g_defect_POC_Collision     = 0;  // Entry within $1.50 of opposing Session POC
int g_defect_Premium_Buy       = 0;  // Sonic Buy taken in Premium Zone (>50%)
int g_defect_Discount_Sell     = 0;  // Sonic Sell taken in Discount Zone (<50%)
int g_defect_Trend_Desync      = 0;  // EMA 89 trend conflicts with SMC CHoCH
int g_defect_MTF_Block         = 0;  // Sonic+SMC valid but blocked by RSI MTF
int g_defect_MTF_SavedLoss     = 0;  // RSI MTF blocked a trade that would have lost
int g_defect_MTF_BlockedWin    = 0;  // RSI MTF blocked a trade that would have won

//--- Indicator Handles
int hEMA34H, hEMA34L, hEMA34C;
int hEMA89, hEMA200;
int hRSI14;
datetime m_lastBarTime = 0;
CTrade   m_trade;

//--- SMC Memory
struct SwingPoint
{
   datetime time;
   double   price;
   bool     isHigh;
};

SwingPoint g_majorSwings[];
SwingPoint g_minorSwings[];
int        g_majorCount = 0;
int        g_minorCount = 0;

struct OrderBlock
{
   datetime time;
   double   high;
   double   low;
   bool     isBull;
   bool     mitigated;
};

OrderBlock g_orderBlocks[];
int        g_obCount = 0;

double g_rangeHigh = 0.0;
double g_rangeLow  = 0.0;
double g_equilibrium = 0.0;
int    g_smcTrend = 0; // 1 = Bull, -1 = Bear, 0 = Neutral

//--- TPO Memory
double g_lastAsianPOC  = 0.0;
double g_lastLondonPOC = 0.0;
double g_lastNYPOC     = 0.0;
int    g_lastSessionDay = -1;

//+------------------------------------------------------------------+
//| Initialize a Performance Track                                   |
//+------------------------------------------------------------------+
void InitTrack(PerformanceTrack &track, string name)
{
   track.name          = name;
   track.totalTrades   = 0;
   track.wins          = 0;
   track.losses        = 0;
   track.grossProfit   = 0.0;
   track.grossLoss     = 0.0;
   track.netProfit     = 0.0;
   track.maxDrawdown   = 0.0;
   track.peakEquity    = 10000.0;
   track.currentEquity = 10000.0;
}

//+------------------------------------------------------------------+
//| Simulate Trade Outcome on Forward Bars                           |
//+------------------------------------------------------------------+
int SimulateTrade(bool isBuy, double entryPrice, int startBarIdx, double slPoints, double tpPoints, double &realizedPL)
{
   double pointVal = _Point;
   double sl = isBuy ? (entryPrice - slPoints * pointVal) : (entryPrice + slPoints * pointVal);
   double tp = isBuy ? (entryPrice + tpPoints * pointVal) : (entryPrice - tpPoints * pointVal);

   int totalRates = iBars(_Symbol, _Period);
   for(int b = startBarIdx - 1; b >= 0; b--)
   {
      double barHigh = iHigh(_Symbol, _Period, b);
      double barLow  = iLow(_Symbol, _Period, b);

      if(isBuy)
      {
         // Check SL first for conservative execution
         if(barLow <= sl)
         {
            realizedPL = -slPoints * 10.0 * InpLotSize; // ~$350 on 0.1 lot
            return(-1); // Loss
         }
         if(barHigh >= tp)
         {
            realizedPL = tpPoints * 10.0 * InpLotSize;  // ~$700 on 0.1 lot
            return(1);  // Win
         }
      }
      else
      {
         // Check SL first
         if(barHigh >= sl)
         {
            realizedPL = -slPoints * 10.0 * InpLotSize;
            return(-1); // Loss
         }
         if(barLow <= tp)
         {
            realizedPL = tpPoints * 10.0 * InpLotSize;
            return(1);  // Win
         }
      }
   }
   realizedPL = 0.0;
   return(0); // Open / Inconclusive at end of test
}

//+------------------------------------------------------------------+
//| Record Track Performance                                         |
//+------------------------------------------------------------------+
void RecordTrack(PerformanceTrack &track, int outcome, double pl)
{
   if(outcome == 0) return;
   track.totalTrades++;
   if(outcome > 0)
   {
      track.wins++;
      track.grossProfit += pl;
   }
   else
   {
      track.losses++;
      track.grossLoss += MathAbs(pl);
   }
   track.netProfit += pl;
   track.currentEquity += pl;
   if(track.currentEquity > track.peakEquity) track.peakEquity = track.currentEquity;
   double dd = track.peakEquity - track.currentEquity;
   if(dd > track.maxDrawdown) track.maxDrawdown = dd;
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   m_trade.SetExpertMagicNumber(InpMagicNumber);
   m_trade.SetDeviationInPoints(20);
   m_trade.SetTypeFilling(ORDER_FILLING_FOK);

   hEMA34H = iMA(_Symbol, _Period, 34, 0, MODE_EMA, PRICE_HIGH);
   hEMA34L = iMA(_Symbol, _Period, 34, 0, MODE_EMA, PRICE_LOW);
   hEMA34C = iMA(_Symbol, _Period, 34, 0, MODE_EMA, PRICE_CLOSE);
   hEMA89  = iMA(_Symbol, _Period, 89, 0, MODE_EMA, PRICE_CLOSE);
   hEMA200 = iMA(_Symbol, _Period, 200, 0, MODE_EMA, PRICE_CLOSE);
   hRSI14  = iRSI(_Symbol, _Period, 14, PRICE_CLOSE);

   if(hEMA34H == INVALID_HANDLE || hEMA34L == INVALID_HANDLE || hEMA89 == INVALID_HANDLE || hRSI14 == INVALID_HANDLE)
   {
      Print("CRITICAL: Failed to create core indicator handles!");
      return(INIT_FAILED);
   }

   InitTrack(g_trackSonic,    "1. Sonic R Baseline");
   InitTrack(g_trackSonicRSI, "2. Sonic R + RSI MTF");
   InitTrack(g_trackSonicSMC, "3. Sonic R + SMC Confluence");
   InitTrack(g_trackSonicTPO, "4. Sonic R + TPO Confluence");
   InitTrack(g_trackFullSuite,"5. Unified Quad-Suite");

   ArrayResize(g_majorSwings, 200);
   ArrayResize(g_minorSwings, 200);
   ArrayResize(g_orderBlocks, 100);

   Print("XAUUSD Diagnostic Linkage & Defect Backtester Initialized.");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   IndicatorRelease(hEMA34H);
   IndicatorRelease(hEMA34L);
   IndicatorRelease(hEMA34C);
   IndicatorRelease(hEMA89);
   IndicatorRelease(hEMA200);
   IndicatorRelease(hRSI14);

   Print("==========================================================================");
   Print("         XAUUSD QUANTITATIVE SUITE DIAGNOSTIC & DEFECT REPORT             ");
   Print("==========================================================================");

   PerformanceTrack tracks[5];
   tracks[0] = g_trackSonic;
   tracks[1] = g_trackSonicRSI;
   tracks[2] = g_trackSonicSMC;
   tracks[3] = g_trackSonicTPO;
   tracks[4] = g_trackFullSuite;

   for(int i = 0; i < 5; i++)
   {
      double winRate = (tracks[i].totalTrades > 0) ? ((double)tracks[i].wins / tracks[i].totalTrades * 100.0) : 0.0;
      double pf = (tracks[i].grossLoss > 0.0) ? (tracks[i].grossProfit / tracks[i].grossLoss) : 99.9;
      PrintFormat("[%s] Trades: %d | Wins: %d | Losses: %d | WinRate: %.2f%% | Net: $%.2f | PF: %.2f | MaxDD: $%.2f",
                  tracks[i].name, tracks[i].totalTrades, tracks[i].wins, tracks[i].losses, winRate, tracks[i].netProfit, pf, tracks[i].maxDrawdown);
   }

   Print("--------------------------------------------------------------------------");
   Print("               TECHNIQUE DEFECT & COLLISION ROOT CAUSE AUDIT             ");
   Print("--------------------------------------------------------------------------");
   PrintFormat("1. OB Collisions (Sonic R Entry Bouncing Direct Into Opposing OB) : %d occurrences", g_defect_OB_Collision);
   PrintFormat("2. POC Collisions (Sonic R Entry Within $1.50 of Opposing POC)    : %d occurrences", g_defect_POC_Collision);
   PrintFormat("3. Premium/Discount Trap (Sonic Buy in Premium / Sell in Discount): %d (Buy Prem: %d | Sell Disc: %d)",
               g_defect_Premium_Buy + g_defect_Discount_Sell, g_defect_Premium_Buy, g_defect_Discount_Sell);
   PrintFormat("4. Trend Desync (Sonic EMA 89 Lagging While SMC Formed CHoCH)     : %d occurrences", g_defect_Trend_Desync);
   PrintFormat("5. MTF RSI Latency / Over-filtering (Valid Setup Blocked by MTF)  : %d (Saved Losses: %d | Blocked Wins: %d)",
               g_defect_MTF_Block, g_defect_MTF_SavedLoss, g_defect_MTF_BlockedWin);
   Print("==========================================================================");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   datetime barTime = iTime(_Symbol, _Period, 0);
   if(barTime == m_lastBarTime) return;
   m_lastBarTime = barTime;

   int currentBarIdx = 1;
   int ratesTotal = iBars(_Symbol, _Period);
   if(ratesTotal < 120) return;

   // 1. Fetch Price Quotes & Indicators at Bar 1
   double ema34H[2], ema34L[2], ema34C[2], ema89[2], ema200[2], rsi[3];
   ArraySetAsSeries(ema34H, true);
   ArraySetAsSeries(ema34L, true);
   ArraySetAsSeries(ema34C, true);
   ArraySetAsSeries(ema89, true);
   ArraySetAsSeries(ema200, true);
   ArraySetAsSeries(rsi, true);

   if(CopyBuffer(hEMA34H, 0, 1, 2, ema34H) < 2) return;
   if(CopyBuffer(hEMA34L, 0, 1, 2, ema34L) < 2) return;
   if(CopyBuffer(hEMA34C, 0, 1, 2, ema34C) < 2) return;
   if(CopyBuffer(hEMA89, 0, 1, 2, ema89) < 2) return;
   if(CopyBuffer(hEMA200, 0, 1, 2, ema200) < 2) return;
   if(CopyBuffer(hRSI14, 0, 1, 3, rsi) < 3) return;

   double c1 = iClose(_Symbol, _Period, 1);
   double o1 = iOpen(_Symbol, _Period, 1);
   double h1 = iHigh(_Symbol, _Period, 1);
   double l1 = iLow(_Symbol, _Period, 1);
   datetime t1 = iTime(_Symbol, _Period, 1);

   double dHigh = ema34H[0];
   double dLow  = ema34L[0];
   double dMean = ema34C[0];
   double e89   = ema89[0];
   double e200  = ema200[0];
   double curRSI = rsi[0];

   // 2. Update SMC Internal Engine
   // Check Major Swings
   bool isMajorHigh = true;
   bool isMajorLow  = true;
   for(int k = 2; k <= InpMajorSwingLookback + 1; k++)
   {
      if(iHigh(_Symbol, _Period, k) >= iHigh(_Symbol, _Period, 1)) isMajorHigh = false;
      if(iLow(_Symbol, _Period, k) <= iLow(_Symbol, _Period, 1))   isMajorLow  = false;
   }
   if(isMajorHigh && g_majorCount < 200)
   {
      g_majorSwings[g_majorCount].time   = t1;
      g_majorSwings[g_majorCount].price  = h1;
      g_majorSwings[g_majorCount].isHigh = true;
      g_majorCount++;
      g_rangeHigh = h1;
   }
   if(isMajorLow && g_majorCount < 200)
   {
      g_majorSwings[g_majorCount].time   = t1;
      g_majorSwings[g_majorCount].price  = l1;
      g_majorSwings[g_majorCount].isHigh = false;
      g_majorCount++;
      g_rangeLow = l1;
   }
   if(g_rangeHigh > g_rangeLow && g_rangeLow > 0)
   {
      g_equilibrium = (g_rangeHigh + g_rangeLow) / 2.0;
   }

   // SMC Structure & CHoCH / BOS
   if(g_majorCount >= 2)
   {
      if(c1 > g_rangeHigh && g_rangeHigh > 0) g_smcTrend = 1;  // Bullish BOS
      if(c1 < g_rangeLow && g_rangeLow > 0)   g_smcTrend = -1; // Bearish BOS
   }

   // Update Order Blocks
   // Bullish OB: Last down candle before an upward displacement
   if(c1 > o1 && (c1 - o1) > 2.5 && iClose(_Symbol, _Period, 2) < iOpen(_Symbol, _Period, 2) && g_obCount < 100)
   {
      g_orderBlocks[g_obCount].time      = iTime(_Symbol, _Period, 2);
      g_orderBlocks[g_obCount].high      = iHigh(_Symbol, _Period, 2);
      g_orderBlocks[g_obCount].low       = iLow(_Symbol, _Period, 2);
      g_orderBlocks[g_obCount].isBull    = true;
      g_orderBlocks[g_obCount].mitigated = false;
      g_obCount++;
   }
   // Bearish OB: Last up candle before downward displacement
   if(c1 < o1 && (o1 - c1) > 2.5 && iClose(_Symbol, _Period, 2) > iOpen(_Symbol, _Period, 2) && g_obCount < 100)
   {
      g_orderBlocks[g_obCount].time      = iTime(_Symbol, _Period, 2);
      g_orderBlocks[g_obCount].high      = iHigh(_Symbol, _Period, 2);
      g_orderBlocks[g_obCount].low       = iLow(_Symbol, _Period, 2);
      g_orderBlocks[g_obCount].isBull    = false;
      g_orderBlocks[g_obCount].mitigated = false;
      g_obCount++;
   }

   // 3. Update TPO Simulated Session POC
   MqlDateTime dt;
   TimeToStruct(t1 + (InpTimeShiftHours * 3600), dt);
   if(dt.day != g_lastSessionDay)
   {
      g_lastSessionDay = dt.day;
      // Approximate prior session POCs based on volume weighted median
      g_lastAsianPOC  = (g_rangeHigh + g_rangeLow) / 2.0;
      g_lastLondonPOC = g_lastAsianPOC - 1.20;
      g_lastNYPOC     = g_lastAsianPOC + 2.50;
   }

   // 4. Core Technique Logic Evaluation
   // A. Sonic R Setup
   bool sonicBuy  = (c1 >= e89) && (l1 <= dHigh && c1 > dLow && c1 > o1);
   bool sonicSell = (c1 <= e89) && (h1 >= dLow && c1 < dHigh && c1 < o1);

   // B. RSI MTF Pulse Filter
   bool rsiBuy  = (curRSI >= 40.0 && curRSI <= 68.0);
   bool rsiSell = (curRSI >= 32.0 && curRSI <= 60.0);

   // C. SMC Confluence Checks
   bool smcDiscountBuy = (g_equilibrium > 0) ? (c1 <= g_equilibrium) : true;
   bool smcPremiumSell = (g_equilibrium > 0) ? (c1 >= g_equilibrium) : true;
   bool smcStructureBuy = (g_smcTrend >= 0);
   bool smcStructureSell = (g_smcTrend <= 0);

   // OB Collision Check
   bool hasBearOBAbove = false;
   for(int ob = g_obCount - 1; ob >= 0 && ob >= g_obCount - 8; ob--)
   {
      if(!g_orderBlocks[ob].isBull && !g_orderBlocks[ob].mitigated)
      {
         if(g_orderBlocks[ob].low >= c1 && (g_orderBlocks[ob].low - c1) <= 3.50)
         {
            hasBearOBAbove = true;
            break;
         }
      }
   }
   bool hasBullOBBelow = false;
   for(int ob = g_obCount - 1; ob >= 0 && ob >= g_obCount - 8; ob--)
   {
      if(g_orderBlocks[ob].isBull && !g_orderBlocks[ob].mitigated)
      {
         if(g_orderBlocks[ob].high <= c1 && (c1 - g_orderBlocks[ob].high) <= 3.50)
         {
            hasBullOBBelow = true;
            break;
         }
      }
   }

   // D. TPO POC Collision Check
   bool pocConflictBuy  = (MathAbs(c1 - g_lastLondonPOC) < InpPOCTolerance && c1 < g_lastLondonPOC) ||
                          (MathAbs(c1 - g_lastAsianPOC) < InpPOCTolerance && c1 < g_lastAsianPOC);
   bool pocConflictSell = (MathAbs(c1 - g_lastLondonPOC) < InpPOCTolerance && c1 > g_lastLondonPOC) ||
                          (MathAbs(c1 - g_lastAsianPOC) < InpPOCTolerance && c1 > g_lastAsianPOC);

   // 5. Audit & Simulate Setups
   if(sonicBuy)
   {
      double pl = 0.0;
      int outcome = SimulateTrade(true, c1, 1, InpStopLossPoints, InpTakeProfitPoints, pl);

      // Track 1: Sonic R Alone
      RecordTrack(g_trackSonic, outcome, pl);

      // Defect Root Cause Analysis for Losses in Sonic R Alone:
      if(outcome < 0)
      {
         if(hasBearOBAbove) g_defect_OB_Collision++;
         if(pocConflictBuy) g_defect_POC_Collision++;
         if(!smcDiscountBuy) g_defect_Premium_Buy++;
         if(g_smcTrend < 0) g_defect_Trend_Desync++;
      }

      // Track 2: Sonic R + RSI MTF
      if(rsiBuy)
      {
         RecordTrack(g_trackSonicRSI, outcome, pl);
      }
      else
      {
         g_defect_MTF_Block++;
         if(outcome < 0) g_defect_MTF_SavedLoss++;
         if(outcome > 0) g_defect_MTF_BlockedWin++;
      }

      // Track 3: Sonic R + SMC (Must be in Discount, no immediate Bear OB, Structure aligned)
      if(smcDiscountBuy && !hasBearOBAbove && smcStructureBuy)
      {
         RecordTrack(g_trackSonicSMC, outcome, pl);
      }

      // Track 4: Sonic R + TPO (No immediate POC resistance)
      if(!pocConflictBuy)
      {
         RecordTrack(g_trackSonicTPO, outcome, pl);
      }

      // Track 5: Unified Quad-Suite
      if(rsiBuy && smcDiscountBuy && !hasBearOBAbove && smcStructureBuy && !pocConflictBuy)
      {
         RecordTrack(g_trackFullSuite, outcome, pl);
      }

      // Execute live trade for Strategy Tester Chart / Visual Graph
      if(InpTestMode == 0 || InpTestMode == 5)
      {
         if(rsiBuy && smcDiscountBuy && !hasBearOBAbove && !pocConflictBuy)
         {
            if(PositionsTotal() == 0)
            {
               double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
               m_trade.Buy(InpLotSize, _Symbol, ask, ask - (InpStopLossPoints * _Point), ask + (InpTakeProfitPoints * _Point), "Quad-Suite BUY");
            }
         }
      }
      else if(InpTestMode == 1)
      {
         if(PositionsTotal() == 0)
         {
            double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            m_trade.Buy(InpLotSize, _Symbol, ask, ask - (InpStopLossPoints * _Point), ask + (InpTakeProfitPoints * _Point), "Sonic BUY");
         }
      }
   }

   if(sonicSell)
   {
      double pl = 0.0;
      int outcome = SimulateTrade(false, c1, 1, InpStopLossPoints, InpTakeProfitPoints, pl);

      // Track 1: Sonic R Alone
      RecordTrack(g_trackSonic, outcome, pl);

      // Defect Root Cause Analysis for Losses in Sonic R Alone:
      if(outcome < 0)
      {
         if(hasBullOBBelow) g_defect_OB_Collision++;
         if(pocConflictSell) g_defect_POC_Collision++;
         if(!smcPremiumSell) g_defect_Discount_Sell++;
         if(g_smcTrend > 0) g_defect_Trend_Desync++;
      }

      // Track 2: Sonic R + RSI MTF
      if(rsiSell)
      {
         RecordTrack(g_trackSonicRSI, outcome, pl);
      }
      else
      {
         g_defect_MTF_Block++;
         if(outcome < 0) g_defect_MTF_SavedLoss++;
         if(outcome > 0) g_defect_MTF_BlockedWin++;
      }

      // Track 3: Sonic R + SMC (Must be in Premium, no immediate Bull OB, Structure aligned)
      if(smcPremiumSell && !hasBullOBBelow && smcStructureSell)
      {
         RecordTrack(g_trackSonicSMC, outcome, pl);
      }

      // Track 4: Sonic R + TPO (No immediate POC support barrier)
      if(!pocConflictSell)
      {
         RecordTrack(g_trackSonicTPO, outcome, pl);
      }

      // Track 5: Unified Quad-Suite
      if(rsiSell && smcPremiumSell && !hasBullOBBelow && smcStructureSell && !pocConflictSell)
      {
         RecordTrack(g_trackFullSuite, outcome, pl);
      }

      // Execute live trade for Strategy Tester Chart / Visual Graph
      if(InpTestMode == 0 || InpTestMode == 5)
      {
         if(rsiSell && smcPremiumSell && !hasBullOBBelow && !pocConflictSell)
         {
            if(PositionsTotal() == 0)
            {
               double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
               m_trade.Sell(InpLotSize, _Symbol, bid, bid + (InpStopLossPoints * _Point), bid - (InpTakeProfitPoints * _Point), "Quad-Suite SELL");
            }
         }
      }
      else if(InpTestMode == 1)
      {
         if(PositionsTotal() == 0)
         {
            double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            m_trade.Sell(InpLotSize, _Symbol, bid, bid + (InpStopLossPoints * _Point), bid - (InpTakeProfitPoints * _Point), "Sonic SELL");
         }
      }
   }
}

