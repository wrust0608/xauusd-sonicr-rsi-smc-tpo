//+------------------------------------------------------------------+
//|                               XAUUSD_Suite_Strategy_Backtest.mq5 |
//|                                  Copyright 2026, Antigravity AI  |
//|                 Quantitative Strategy Backtester & Verification  |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "1.00"
#property description "Quantitative verification EA for XAUUSD Suite (Sonic R + RSI Trend Pulse + SMC + TPO)"

#include <Trade\Trade.mqh>

//--- Inputs
input group "=== 1. Risk & Execution Parameters ==="
input double   InpLotSize           = 0.10;       // Fixed Lot Size
input int      InpStopLossPoints    = 350;        // Stop Loss in Points (350 pts = $3.50 on Gold)
input int      InpTakeProfitPoints  = 700;        // Take Profit in Points (700 pts = $7.00 on Gold, 1:2 RR)
input bool     InpUseTrailingStop   = true;       // Enable Trailing Stop
input int      InpTrailingPoints    = 250;        // Trailing Stop Distance in Points
input ulong    InpMagicNumber       = 888999;     // Magic Number

input group "=== 2. Strategy Filters ==="
input bool     InpFilterTrend89     = true;       // Enforce EMA 89 Macro Alignment
input bool     InpFilterDragonCloud = true;       // Enforce Dragon Cloud Wave Bounce
input bool     InpFilterRSI         = true;       // Enforce RSI 14 Momentum Support

//--- Global Variables
CTrade         m_trade;
int            hEMA34H, hEMA34L, hEMA34C;
int            hEMA89;
int            hEMA200;
int            hRSI14;
datetime       m_lastBarTime = 0;

//--- Performance Metrics
int            m_totalSignals = 0;
int            m_totalWins    = 0;
int            m_totalLosses  = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   m_trade.SetExpertMagicNumber(InpMagicNumber);
   m_trade.SetDeviationInPoints(20);
   m_trade.SetTypeFilling(ORDER_FILLING_FOK);

   // Create handles for Core Indicators
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

   Print("XAUUSD Suite Strategy Backtester initialized successfully. Symbol: ", _Symbol, " Period: ", EnumToString((ENUM_TIMEFRAMES)_Period));
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

   PrintFormat("=== XAUUSD Suite Strategy Performance Summary ===");
   PrintFormat("Total Setups Triggered: %d | Wins: %d | Losses: %d", m_totalSignals, m_totalWins, m_totalLosses);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Check bar close (Strict Non-Repainting Causality on Bar 1)
   datetime barTime = iTime(_Symbol, _Period, 0);
   if(barTime == m_lastBarTime)
   {
      // Manage Trailing Stop on intra-bar ticks
      if(InpUseTrailingStop) ManageTrailingStop();
      return;
   }
   m_lastBarTime = barTime;

   // Read indicator buffers at Bar 1 & Bar 2
   double ema34H[2], ema34L[2], ema34C[2];
   double ema89[2], ema200[2];
   double rsi[3];

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

   // Price quotes at bar 1
   MqlRates rates[2];
   ArraySetAsSeries(rates, true);
   if(CopyRates(_Symbol, _Period, 1, 2, rates) < 2) return;

   double c1 = rates[0].close;
   double o1 = rates[0].open;
   double h1 = rates[0].high;
   double l1 = rates[0].low;

   double dHigh = ema34H[0];
   double dLow  = ema34L[0];
   double dMean = ema34C[0];
   double e89   = ema89[0];
   double e89_prev = ema89[1];
   double e200  = ema200[0];

   double currentRSI = rsi[0];
   double prevRSI    = rsi[1];

   // 1. Sonic R Trend Direction (EMA 89)
   bool bullMacro = (!InpFilterTrend89) || (c1 >= e89);
   bool bearMacro = (!InpFilterTrend89) || (c1 <= e89);

   // 2. Sonic R Wave Touch/Bounce (Dragon Cloud Interaction)
   // Long: Low probed into Dragon, Close bounced back above Dragon Mean
   bool bullWaveBounce = (!InpFilterDragonCloud) || (l1 <= dHigh && c1 > dLow && c1 > o1);
   // Short: High probed into Dragon, Close rejected back below Dragon Mean
   bool bearWaveBounce = (!InpFilterDragonCloud) || (h1 >= dLow && c1 < dHigh && c1 < o1);

   // 3. RSI Momentum Confirmation
   bool bullRSISetup = (!InpFilterRSI) || (currentRSI >= 40.0 && currentRSI <= 68.0 && currentRSI >= prevRSI - 0.5);
   bool bearRSISetup = (!InpFilterRSI) || (currentRSI >= 32.0 && currentRSI <= 60.0 && currentRSI <= prevRSI + 0.5);

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
         if(posType == POSITION_TYPE_BUY) hasOpenBuy = true;
         if(posType == POSITION_TYPE_SELL) hasOpenSell = true;
      }
   }

   // --- EXECUTE BUY SETUP ---
   if(!hasOpenBuy && bullMacro && bullWaveBounce && bullRSISetup)
   {
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double sl  = ask - (InpStopLossPoints * _Point);
      double tp  = ask + (InpTakeProfitPoints * _Point);

      if(m_trade.Buy(InpLotSize, _Symbol, ask, sl, tp, "XAUUSD Suite [BULL_WAVE]"))
      {
         m_totalSignals++;
         PrintFormat("[STRATEGY BUY] Ticket: %I64d | Ask: %.2f | SL: %.2f | TP: %.2f | RSI: %.1f | EMA89: %.2f",
                     m_trade.ResultOrder(), ask, sl, tp, currentRSI, e89);
      }
   }

   // --- EXECUTE SELL SETUP ---
   if(!hasOpenSell && bearMacro && bearWaveBounce && bearRSISetup)
   {
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double sl  = bid + (InpStopLossPoints * _Point);
      double tp  = bid - (InpTakeProfitPoints * _Point);

      if(m_trade.Sell(InpLotSize, _Symbol, bid, sl, tp, "XAUUSD Suite [BEAR_WAVE]"))
      {
         m_totalSignals++;
         PrintFormat("[STRATEGY SELL] Ticket: %I64d | Bid: %.2f | SL: %.2f | TP: %.2f | RSI: %.1f | EMA89: %.2f",
                     m_trade.ResultOrder(), bid, sl, tp, currentRSI, e89);
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
