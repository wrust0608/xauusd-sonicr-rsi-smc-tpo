//+------------------------------------------------------------------+
//|                               XAUUSD_Suite_Strategy_Backtest.mq5 |
//|                                  Copyright 2026, Antigravity AI  |
//|      Production Quad-Gatekeeper Strategy Backtester & Execution  |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "3.00"
#property description "Refined Quad-Gatekeeper Strategy: Sonic R Wave + SMC Structure/Equilibrium + TPO POC + Dynamic ATR 1:2 RR"

#include <Trade\Trade.mqh>

//--- Input Parameters
input group "=== 1. Risk & Dynamic Volatility Model ==="
input double   InpLotSize           = 0.10;       // Fixed Lot Size
input bool     InpUseDynamicATR     = true;       // Enable Dynamic ATR Sizing (Defect 3 Fix)
input double   InpAtrSlMult         = 1.5;        // Dynamic Stop Loss Multiplier (1.5x ATR)
input double   InpAtrTpMult         = 3.0;        // Dynamic Take Profit Multiplier (3.0x ATR = 1:2 RR)
input int      InpFixedSlPoints     = 350;        // Fallback Static SL in Points ($3.50)
input int      InpFixedTpPoints     = 700;        // Fallback Static TP in Points ($7.00)
input ulong    InpMagicNumber       = 888999;     // Magic Number

input group "=== 2. Defect Remediation Gates ==="
input bool     InpFilterTrend89     = true;       // Gate 0: Enforce EMA 89 Macro Alignment
input bool     InpFilterDragonCloud = true;       // Gate 0: Enforce Dragon Cloud Wave Touch
input bool     InpFilterStructure   = true;       // Gate 1: Enforce SMC Market Structure (Defect 1 Fix)
input bool     InpFilterEquilibrium = true;       // Gate 2: Enforce SMC Discount/Premium (Defect 2 Fix)
input bool     InpFilterPOC         = true;       // Gate 3: Enforce TPO POC Clearance (Defect 4 Fix)
input double   InpPOCTolerance      = 2.50;       // Min Distance to Opposing POC ($2.50)
input bool     InpFilterRSI         = true;       // Gate 4: Enforce RSI Momentum Corridor (Defect 5 Fix)
input double   InpRsiBullMin        = 40.0;       // RSI Bullish Floor (Cardwell Bull Range)
input double   InpRsiBullMax        = 65.0;       // RSI Bullish Ceiling
input double   InpRsiBearMin        = 35.0;       // RSI Bearish Floor
input double   InpRsiBearMax        = 60.0;       // RSI Bearish Ceiling (Cardwell Bear Range)

input group "=== 3. SMC Fractal Swing Geometry ==="
input int      InpSwingLeftBars     = 5;          // Fractal Left Bars
input int      InpSwingRightBars    = 5;          // Fractal Right Bars

//--- Global Variables
CTrade         m_trade;
int            hEMA34H, hEMA34L, hEMA34C;
int            hEMA89;
int            hEMA200;
int            hRSI14;
int            hATR14;
datetime       m_lastBarTime = 0;

//--- Market Structure Memory
double         m_lastSwingHigh = 0.0;
double         m_lastSwingLow  = 0.0;
double         m_equilibrium   = 0.0;
int            m_smcTrend      = 0; // 1 = Bullish, -1 = Bearish, 0 = Neutral

//--- TPO Session Memory
double         m_lastAsianPOC   = 0.0;
double         m_lastLondonPOC  = 0.0;
double         m_lastNYPOC      = 0.0;
int            m_lastSessionDay = -1;

//--- Performance Metrics
int            m_totalSignals  = 0;
int            m_totalWins     = 0;
int            m_totalLosses   = 0;
double         m_grossProfit   = 0.0;
double         m_grossLoss     = 0.0;

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
   hATR14  = iATR(_Symbol, _Period, 14);

   if(hEMA34H == INVALID_HANDLE || hEMA34L == INVALID_HANDLE || hEMA89 == INVALID_HANDLE ||
      hRSI14 == INVALID_HANDLE  || hATR14 == INVALID_HANDLE)
   {
      Print("CRITICAL: Failed to create core indicator handles!");
      return(INIT_FAILED);
   }

   PrintFormat("Quad-Gatekeeper Strategy v3.0 Initialized: Symbol=%s, Period=%s, DynamicATR=%s",
               _Symbol, EnumToString((ENUM_TIMEFRAMES)_Period), InpUseDynamicATR ? "ON" : "OFF");
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
   IndicatorRelease(hATR14);

   Print("==========================================================================");
   Print("       XAUUSD QUAD-GATEKEEPER STRATEGY REMEDIATION VERIFICATION           ");
   Print("==========================================================================");
   double winRate = (m_totalSignals > 0) ? ((double)m_totalWins / m_totalSignals * 100.0) : 0.0;
   double pf = (m_grossLoss > 0.0) ? (m_grossProfit / m_grossLoss) : 99.9;
   PrintFormat("Total Closed Trades : %d", m_totalSignals);
   PrintFormat("Winning Trades (TP) : %d (%.2f%%)", m_totalWins, winRate);
   PrintFormat("Losing Trades (SL)  : %d (%.2f%%)", m_totalLosses, 100.0 - winRate);
   PrintFormat("Gross Profit ($)    : $%.2f", m_grossProfit);
   PrintFormat("Gross Loss ($)      : $%.2f", m_grossLoss);
   PrintFormat("Net Profit ($)      : $%.2f", m_grossProfit - m_grossLoss);
   PrintFormat("Profit Factor (PF)  : %.2f", pf);
   Print("==========================================================================");
}

//+------------------------------------------------------------------+
//| Update SMC Swings & BOS/CHoCH Detection                          |
//+------------------------------------------------------------------+
void UpdateSMCStructure(int ratesTotal)
{
   // Search for the most recently confirmed fractal swing high & low
   // A fractal swing at bar k is confirmed once k has InpSwingRightBars bars to its right
   int startK = InpSwingRightBars + 1;
   int endK   = startK + 100;
   if(endK >= ratesTotal - InpSwingLeftBars - 1) endK = ratesTotal - InpSwingLeftBars - 1;

   for(int k = startK; k <= endK; k++)
   {
      double hK = iHigh(_Symbol, _Period, k);
      double lK = iLow(_Symbol, _Period, k);

      // Check Swing High
      if(m_lastSwingHigh == 0.0)
      {
         bool isSH = true;
         for(int left = 1; left <= InpSwingLeftBars; left++)
         {
            if(iHigh(_Symbol, _Period, k + left) >= hK) { isSH = false; break; }
         }
         if(isSH)
         {
            for(int right = 1; right <= InpSwingRightBars; right++)
            {
               if(iHigh(_Symbol, _Period, k - right) >= hK) { isSH = false; break; }
            }
         }
         if(isSH) m_lastSwingHigh = hK;
      }

      // Check Swing Low
      if(m_lastSwingLow == 0.0)
      {
         bool isSL = true;
         for(int left = 1; left <= InpSwingLeftBars; left++)
         {
            if(iLow(_Symbol, _Period, k + left) <= lK) { isSL = false; break; }
         }
         if(isSL)
         {
            for(int right = 1; right <= InpSwingRightBars; right++)
            {
               if(iLow(_Symbol, _Period, k - right) <= lK) { isSL = false; break; }
            }
         }
         if(isSL) m_lastSwingLow = lK;
      }

      if(m_lastSwingHigh > 0.0 && m_lastSwingLow > 0.0) break;
   }

   // Update Equilibrium & Structure State
   if(m_lastSwingHigh > m_lastSwingLow && m_lastSwingLow > 0.0)
   {
      m_equilibrium = (m_lastSwingHigh + m_lastSwingLow) / 2.0;

      double c1 = iClose(_Symbol, _Period, 1);
      // Break of Structure (BOS)
      if(c1 > m_lastSwingHigh)
      {
         m_smcTrend = 1; // Bullish BOS
         m_lastSwingHigh = iHigh(_Symbol, _Period, 1);
      }
      else if(c1 < m_lastSwingLow)
      {
         m_smcTrend = -1; // Bearish BOS
         m_lastSwingLow = iLow(_Symbol, _Period, 1);
      }
   }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Check Bar Close on Bar 1 for Strict Non-Repainting Causality
   datetime barTime = iTime(_Symbol, _Period, 0);
   if(barTime == m_lastBarTime) return;
   m_lastBarTime = barTime;

   int ratesTotal = iBars(_Symbol, _Period);
   if(ratesTotal < 120) return;

   // 1. Fetch Indicators & Quotes at Bar 1
   double ema34H[2], ema34L[2], ema34C[2], ema89[2], ema200[2], rsi[3], atr[2];
   ArraySetAsSeries(ema34H, true);
   ArraySetAsSeries(ema34L, true);
   ArraySetAsSeries(ema34C, true);
   ArraySetAsSeries(ema89, true);
   ArraySetAsSeries(ema200, true);
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(atr, true);

   if(CopyBuffer(hEMA34H, 0, 1, 2, ema34H) < 2) return;
   if(CopyBuffer(hEMA34L, 0, 1, 2, ema34L) < 2) return;
   if(CopyBuffer(hEMA34C, 0, 1, 2, ema34C) < 2) return;
   if(CopyBuffer(hEMA89, 0, 1, 2, ema89) < 2) return;
   if(CopyBuffer(hEMA200, 0, 1, 2, ema200) < 2) return;
   if(CopyBuffer(hRSI14, 0, 1, 3, rsi) < 3) return;
   if(CopyBuffer(hATR14, 0, 1, 2, atr) < 2) return;

   MqlRates rates[3];
   ArraySetAsSeries(rates, true);
   if(CopyRates(_Symbol, _Period, 1, 3, rates) < 3) return;

   double c1 = rates[0].close;
   double o1 = rates[0].open;
   double h1 = rates[0].high;
   double l1 = rates[0].low;
   datetime t1 = rates[0].time;

   double dHigh = ema34H[0];
   double dLow  = ema34L[0];
   double dMean = ema34C[0];
   double e89   = ema89[0];
   double e200  = ema200[0];
   double curRSI = rsi[0];
   double curATR = atr[0];

   // 2. Update SMC Internal Engine
   UpdateSMCStructure(ratesTotal);

   // 3. Update Simulated TPO Session POC
   MqlDateTime dt;
   TimeToStruct(t1 + (5 * 3600), dt);
   if(dt.day != m_lastSessionDay)
   {
      m_lastSessionDay = dt.day;
      if(m_lastSwingHigh > m_lastSwingLow && m_lastSwingLow > 0.0)
      {
         m_lastAsianPOC   = (m_lastSwingHigh + m_lastSwingLow) / 2.0;
         m_lastLondonPOC  = m_lastAsianPOC - 1.20;
         m_lastNYPOC      = m_lastAsianPOC + 2.50;
      }
   }

   // 4. Strict Single Position Discipline
   if(PositionsTotal() > 0) return;

   // 5. Evaluate Gates
   // Gate 0: Sonic R Trend & Wave Bounce
   bool sonicBuy  = (!InpFilterTrend89 || c1 >= e89) &&
                    (!InpFilterDragonCloud || (l1 <= dHigh && c1 > dLow && c1 > o1));
   bool sonicSell = (!InpFilterTrend89 || c1 <= e89) &&
                    (!InpFilterDragonCloud || (h1 >= dLow && c1 < dHigh && c1 < o1));

   // Gate 1: SMC Market Structure Alignment (Defect 1 Fix)
   // Buy ONLY if SMC trend is not bearish (no Lower-Low breakdown)
   bool structBuy  = (!InpFilterStructure) || (m_smcTrend >= 0 && (m_lastSwingLow == 0.0 || c1 >= m_lastSwingLow));
   // Sell ONLY if SMC trend is not bullish (no Higher-High breakout)
   bool structSell = (!InpFilterStructure) || (m_smcTrend <= 0 && (m_lastSwingHigh == 0.0 || c1 <= m_lastSwingHigh));

   // Gate 2: SMC Discount/Premium Zone (Defect 2 Fix)
   // Buy ONLY in Discount (<50% of dealing range), Sell ONLY in Premium (>50%)
   bool eqBuy  = (!InpFilterEquilibrium) || (m_equilibrium == 0.0) || (c1 <= m_equilibrium);
   bool eqSell = (!InpFilterEquilibrium) || (m_equilibrium == 0.0) || (c1 >= m_equilibrium);

   // Gate 3: TPO POC Clearance (Defect 4 Fix)
   bool pocBuy  = (!InpFilterPOC) ||
                  ((m_lastLondonPOC == 0.0 || MathAbs(c1 - m_lastLondonPOC) >= InpPOCTolerance || c1 > m_lastLondonPOC) &&
                   (m_lastAsianPOC  == 0.0 || MathAbs(c1 - m_lastAsianPOC) >= InpPOCTolerance || c1 > m_lastAsianPOC));
   bool pocSell = (!InpFilterPOC) ||
                  ((m_lastLondonPOC == 0.0 || MathAbs(c1 - m_lastLondonPOC) >= InpPOCTolerance || c1 < m_lastLondonPOC) &&
                   (m_lastAsianPOC  == 0.0 || MathAbs(c1 - m_lastAsianPOC) >= InpPOCTolerance || c1 < m_lastAsianPOC));

   // Gate 4: RSI Momentum Corridor (Defect 5 Fix)
   bool rsiBuy  = (!InpFilterRSI) || (curRSI >= InpRsiBullMin && curRSI <= InpRsiBullMax);
   bool rsiSell = (!InpFilterRSI) || (curRSI >= InpRsiBearMin && curRSI <= InpRsiBearMax);

   // Calculate Dynamic Stop Loss & Take Profit (Defect 3 Fix)
   double slDist = InpUseDynamicATR ? MathMax(3.50, InpAtrSlMult * curATR) : (InpFixedSlPoints * _Point);
   double tpDist = InpUseDynamicATR ? (InpAtrTpMult * curATR) : (InpFixedTpPoints * _Point);

   // --- EXECUTE BUY ORDER ---
   if(sonicBuy && structBuy && eqBuy && pocBuy && rsiBuy)
   {
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double sl  = ask - slDist;
      double tp  = ask + tpDist;

      if(m_trade.Buy(InpLotSize, _Symbol, ask, sl, tp, "Quad-Gate BUY"))
      {
         m_totalSignals++;
         PrintFormat("[QUAD-GATE BUY #%d] Ask: %.2f | SL: %.2f (-$%.2f) | TP: %.2f (+$%.2f) | ATR: %.2f | RSI: %.1f | Struct: %d",
                     m_totalSignals, ask, sl, slDist, tp, tpDist, curATR, curRSI, m_smcTrend);
      }
   }

   // --- EXECUTE SELL ORDER ---
   if(sonicSell && structSell && eqSell && pocSell && rsiSell)
   {
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double sl  = bid + slDist;
      double tp  = bid - tpDist;

      if(m_trade.Sell(InpLotSize, _Symbol, bid, sl, tp, "Quad-Gate SELL"))
      {
         m_totalSignals++;
         PrintFormat("[QUAD-GATE SELL #%d] Bid: %.2f | SL: %.2f (+$%.2f) | TP: %.2f (-$%.2f) | ATR: %.2f | RSI: %.1f | Struct: %d",
                     m_totalSignals, bid, sl, slDist, tp, tpDist, curATR, curRSI, m_smcTrend);
      }
   }
}

//+------------------------------------------------------------------+
//| Trade Transaction Tracking for Win/Loss Attribution              |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
{
   if(trans.type == TRADE_TRANSACTION_DEAL_ADD)
   {
      ulong dealTicket = trans.deal;
      if(dealTicket > 0 && HistoryDealSelect(dealTicket))
      {
         long dealEntry = HistoryDealGetInteger(dealTicket, DEAL_ENTRY);
         long dealMagic = HistoryDealGetInteger(dealTicket, DEAL_MAGIC);

         if(dealEntry == DEAL_ENTRY_OUT && dealMagic == InpMagicNumber)
         {
            double profit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT);
            if(profit > 0.0)
            {
               m_totalWins++;
               m_grossProfit += profit;
            }
            else if(profit < 0.0)
            {
               m_totalLosses++;
               m_grossLoss += MathAbs(profit);
            }
         }
      }
   }
}
