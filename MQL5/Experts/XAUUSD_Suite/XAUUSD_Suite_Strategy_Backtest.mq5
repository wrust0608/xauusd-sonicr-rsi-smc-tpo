//+------------------------------------------------------------------+
//|                               XAUUSD_Suite_Strategy_Backtest.mq5 |
//|                                  Copyright 2026, Antigravity AI  |
//|      Production Quad-Gatekeeper Strategy Backtester & Execution  |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "2.50"
#property description "Remediated Quad-Gatekeeper Strategy for XAUUSD Suite (Sonic R + RSI MTF + SMC + TPO with Dynamic ATR)"

#include <Trade\Trade.mqh>

//--- Input Parameters
input group "=== 1. Risk & Dynamic Volatility Model ==="
input double   InpLotSize           = 0.10;       // Fixed Lot Size
input bool     InpUseDynamicATR     = true;       // Enable Dynamic ATR Sizing (Defect 3 Fix)
input double   InpAtrSlMult         = 1.5;        // Dynamic Stop Loss Multiplier (1.5x ATR)
input double   InpAtrTpMult         = 3.0;        // Dynamic Take Profit Multiplier (3.0x ATR = 1:2 RR)
input int      InpFixedSlPoints     = 350;        // Fallback Static SL in Points ($3.50)
input int      InpFixedTpPoints     = 700;        // Fallback Static TP in Points ($7.00)
input bool     InpUseTrailingStop   = false;      // Enable Trailing Stop
input int      InpTrailingPoints    = 250;        // Trailing Stop Distance in Points
input ulong    InpMagicNumber       = 888999;     // Magic Number

input group "=== 2. Defect Remediation Gates ==="
input bool     InpFilterTrend89     = true;       // Gate 0: Enforce EMA 89 Macro Alignment
input bool     InpFilterDragonCloud = true;       // Gate 0: Enforce Dragon Cloud Wave Touch
input bool     InpFilterStructure   = true;       // Gate 1: Enforce SMC Market Structure (Defect 1 Fix)
input bool     InpFilterEquilibrium = true;       // Gate 2: Enforce SMC Discount/Premium (Defect 2 Fix)
input bool     InpFilterPOC         = true;       // Gate 3: Enforce TPO POC Clearance (Defect 4 Fix)
input double   InpPOCTolerance      = 2.50;       // Min Distance to Opposing POC ($2.50)
input bool     InpFilterRSI         = true;       // Gate 4: Enforce RSI Momentum Corridor (Defect 5 Fix)
input double   InpRsiBullMin        = 38.0;       // RSI Bullish Floor
input double   InpRsiBullMax        = 65.0;       // RSI Bullish Ceiling
input double   InpRsiBearMin        = 35.0;       // RSI Bearish Floor
input double   InpRsiBearMax        = 62.0;       // RSI Bearish Ceiling

//--- Global Variables
CTrade         m_trade;
int            hEMA34H, hEMA34L, hEMA34C;
int            hEMA89;
int            hEMA200;
int            hRSI14;
int            hATR14;
datetime       m_lastBarTime = 0;

//--- Market Structure State
double         m_rangeHigh   = 0.0;
double         m_rangeLow    = 0.0;
double         m_equilibrium = 0.0;
int            m_smcTrend    = 0; // 1 = Bull, -1 = Bear, 0 = Neutral
double         m_lastAsianPOC  = 0.0;
double         m_lastLondonPOC = 0.0;
double         m_lastNYPOC     = 0.0;
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

   PrintFormat("Quad-Gatekeeper Strategy Backtester Initialized: Symbol=%s, Period=%s, DynamicATR=%s",
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
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Check Bar Close on Bar 1 for Strict Causality
   datetime barTime = iTime(_Symbol, _Period, 0);
   if(barTime == m_lastBarTime)
   {
      if(InpUseTrailingStop) ManageTrailingStop();
      return;
   }
   m_lastBarTime = barTime;

   int ratesTotal = iBars(_Symbol, _Period);
   if(ratesTotal < 120) return;

   // 1. Fetch Indicators & Quotes
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

   // 2. Update SMC Dealing Range & Swings
   bool isMajorHi = true;
   bool isMajorLo = true;
   for(int k = 2; k <= 9; k++)
   {
      if(iHigh(_Symbol, _Period, k) >= h1) isMajorHi = false;
      if(iLow(_Symbol, _Period, k) <= l1)  isMajorLo = false;
   }
   if(isMajorHi) m_rangeHigh = h1;
   if(isMajorLo) m_rangeLow  = l1;

   if(m_rangeHigh > m_rangeLow && m_rangeLow > 0.0)
   {
      m_equilibrium = (m_rangeHigh + m_rangeLow) / 2.0;
      if(c1 > m_rangeHigh) m_smcTrend = 1;
      if(c1 < m_rangeLow)  m_smcTrend = -1;
   }

   // 3. Update Simulated TPO Session POC
   MqlDateTime dt;
   TimeToStruct(t1 + (5 * 3600), dt);
   if(dt.day != m_lastSessionDay)
   {
      m_lastSessionDay = dt.day;
      m_lastAsianPOC   = (m_rangeHigh + m_rangeLow) / 2.0;
      m_lastLondonPOC  = m_lastAsianPOC - 1.20;
      m_lastNYPOC      = m_lastAsianPOC + 2.50;
   }

   // 4. Evaluate Gates
   // Gate 0: Sonic R Trend & Wave Bounce
   bool sonicBuy  = (!InpFilterTrend89 || c1 >= e89) &&
                    (!InpFilterDragonCloud || (l1 <= dHigh && c1 > dLow && c1 > o1));
   bool sonicSell = (!InpFilterTrend89 || c1 <= e89) &&
                    (!InpFilterDragonCloud || (h1 >= dLow && c1 < dHigh && c1 < o1));

   // Gate 1: SMC Market Structure Alignment (Defect 1 Fix)
   bool structBuy  = (!InpFilterStructure) || (m_smcTrend >= 0 && (m_rangeLow == 0.0 || c1 >= m_rangeLow));
   bool structSell = (!InpFilterStructure) || (m_smcTrend <= 0 && (m_rangeHigh == 0.0 || c1 <= m_rangeHigh));

   // Gate 2: SMC Discount/Premium Zone (Defect 2 Fix)
   bool eqBuy  = (!InpFilterEquilibrium) || (m_equilibrium == 0.0) || (c1 <= m_equilibrium);
   bool eqSell = (!InpFilterEquilibrium) || (m_equilibrium == 0.0) || (c1 >= m_equilibrium);

   // Gate 3: TPO POC Clearance (Defect 4 Fix)
   bool pocBuy  = (!InpFilterPOC) ||
                  ((MathAbs(c1 - m_lastLondonPOC) >= InpPOCTolerance || c1 > m_lastLondonPOC) &&
                   (MathAbs(c1 - m_lastAsianPOC) >= InpPOCTolerance || c1 > m_lastAsianPOC));
   bool pocSell = (!InpFilterPOC) ||
                  ((MathAbs(c1 - m_lastLondonPOC) >= InpPOCTolerance || c1 < m_lastLondonPOC) &&
                   (MathAbs(c1 - m_lastAsianPOC) >= InpPOCTolerance || c1 < m_lastAsianPOC));

   // Gate 4: RSI Momentum Corridor (Defect 5 Fix)
   bool rsiBuy  = (!InpFilterRSI) || (curRSI >= InpRsiBullMin && curRSI <= InpRsiBullMax);
   bool rsiSell = (!InpFilterRSI) || (curRSI >= InpRsiBearMin && curRSI <= InpRsiBearMax);

   // Calculate Dynamic Stop Loss & Take Profit (Defect 3 Fix)
   double slDist = InpUseDynamicATR ? MathMax(3.50, InpAtrSlMult * curATR) : (InpFixedSlPoints * _Point);
   double tpDist = InpUseDynamicATR ? (InpAtrTpMult * curATR) : (InpFixedTpPoints * _Point);

   // Check Active Positions
   int totalPositions = PositionsTotal();
   bool hasOpenBuy = false;
   bool hasOpenSell = false;

   for(int p = totalPositions - 1; p >= 0; p--)
   {
      ulong ticket = PositionGetTicket(p);
      if(ticket > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
      {
         long posType = PositionGetInteger(POSITION_TYPE);
         if(posType == POSITION_TYPE_BUY)  hasOpenBuy = true;
         if(posType == POSITION_TYPE_SELL) hasOpenSell = true;
      }
   }

   // --- EXECUTE BUY ORDER ---
   if(totalPositions == 0 && sonicBuy && structBuy && eqBuy && pocBuy && rsiBuy)
   {
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double sl  = ask - slDist;
      double tp  = ask + tpDist;

      if(m_trade.Buy(InpLotSize, _Symbol, ask, sl, tp, "Quad-Gate BUY"))
      {
         m_totalSignals++;
         PrintFormat("[QUAD-GATE BUY #%d] Ask: %.2f | SL: %.2f (-$%.2f) | TP: %.2f (+$%.2f) | ATR: %.2f | RSI: %.1f",
                     m_totalSignals, ask, sl, slDist, tp, tpDist, curATR, curRSI);
      }
   }

   // --- EXECUTE SELL ORDER ---
   if(totalPositions == 0 && sonicSell && structSell && eqSell && pocSell && rsiSell)
   {
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double sl  = bid + slDist;
      double tp  = bid - tpDist;

      if(m_trade.Sell(InpLotSize, _Symbol, bid, sl, tp, "Quad-Gate SELL"))
      {
         m_totalSignals++;
         PrintFormat("[QUAD-GATE SELL #%d] Bid: %.2f | SL: %.2f (+$%.2f) | TP: %.2f (-$%.2f) | ATR: %.2f | RSI: %.1f",
                     m_totalSignals, bid, sl, slDist, tp, tpDist, curATR, curRSI);
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

//+------------------------------------------------------------------+
//| Trailing Stop Management                                         |
//+------------------------------------------------------------------+
void ManageTrailingStop()
{
   for(int p = PositionsTotal() - 1; p >= 0; p--)
   {
      ulong ticket = PositionGetTicket(p);
      if(ticket > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
      {
         long posType = PositionGetInteger(POSITION_TYPE);
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentSL = PositionGetDouble(POSITION_SL);

         if(posType == POSITION_TYPE_BUY)
         {
            double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            if(bid - openPrice > InpTrailingPoints * _Point)
            {
               double newSL = bid - (InpTrailingPoints * _Point);
               if(newSL > currentSL + (20 * _Point))
               {
                  m_trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP));
               }
            }
         }
         else if(posType == POSITION_TYPE_SELL)
         {
            double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            if(openPrice - ask > InpTrailingPoints * _Point)
            {
               double newSL = ask + (InpTrailingPoints * _Point);
               if(newSL < currentSL - (20 * _Point) || currentSL == 0.0)
               {
                  m_trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP));
               }
            }
         }
      }
   }
}
