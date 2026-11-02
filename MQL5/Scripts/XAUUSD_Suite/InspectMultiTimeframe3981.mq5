//+------------------------------------------------------------------+
//|                                     InspectMultiTimeframe3981.mq5|
//|                                  Copyright 2026, Antigravity AI  |
//|    Multi-Timeframe Deep Forensic Analysis of the Drop to 3981    |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "1.00"
#property script_show_inputs false

void OnStart()
{
   Print("=== STARTING MULTI-TIMEFRAME FORENSIC AUDIT OF 3981 ===");

   int fileHandle = FileOpen("analysis_3981.txt", FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(fileHandle == INVALID_HANDLE)
   {
      Print("Failed to open output file.");
      return;
   }

   string report = "";
   report += "========================================================================================\n";
   report += "MULTI-TIMEFRAME FORENSIC ANALYSIS: THE REASON BEHIND THE STALL & DEFENSE AT 3981.00\n";
   report += "========================================================================================\n\n";

   // 1. Current Price & Recent Drop Info
   MqlRates m5Rates[];
   ArraySetAsSeries(m5Rates, true);
   CopyRates(_Symbol, PERIOD_M5, 0, 100, m5Rates);
   
   double curBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double curAsk = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   report += StringFormat("Symbol: %s | Current Bid: %.2f | Ask: %.2f | Time: %s\n\n",
                          _Symbol, curBid, curAsk, TimeToString(TimeCurrent()));

   // 2. DAILY (D1) PERSPECTIVE
   MqlRates d1Rates[];
   ArraySetAsSeries(d1Rates, true);
   CopyRates(_Symbol, PERIOD_D1, 0, 30, d1Rates);

   int hD1EMA34 = iMA(_Symbol, PERIOD_D1, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hD1EMA89 = iMA(_Symbol, PERIOD_D1, 89, 0, MODE_EMA, PRICE_CLOSE);
   int hD1EMA200= iMA(_Symbol, PERIOD_D1, 200, 0, MODE_EMA, PRICE_CLOSE);

   double d1Ema34[2], d1Ema89[2], d1Ema200[2];
   ArraySetAsSeries(d1Ema34, true); ArraySetAsSeries(d1Ema89, true); ArraySetAsSeries(d1Ema200, true);
   CopyBuffer(hD1EMA34, 0, 0, 2, d1Ema34);
   CopyBuffer(hD1EMA89, 0, 0, 2, d1Ema89);
   CopyBuffer(hD1EMA200, 0, 0, 2, d1Ema200);

   report += "--- 1. DAILY (D1) MACRO CONTEXT ---\n";
   report += StringFormat("Today's Range (D1[0]): High=%.2f | Low=%.2f | Open=%.2f | Close=%.2f\n",
                          d1Rates[0].high, d1Rates[0].low, d1Rates[0].open, d1Rates[0].close);
   report += StringFormat("Yesterday (D1[1])    : High=%.2f | Low=%.2f | Open=%.2f | Close=%.2f\n",
                          d1Rates[1].high, d1Rates[1].low, d1Rates[1].open, d1Rates[1].close);
   report += StringFormat("Day Before (D1[2])   : High=%.2f | Low=%.2f | Open=%.2f | Close=%.2f\n",
                          d1Rates[2].high, d1Rates[2].low, d1Rates[2].open, d1Rates[2].close);
   report += StringFormat("Daily EMA 34: %.2f | Daily EMA 89: %.2f | Daily EMA 200: %.2f\n",
                          d1Ema34[0], d1Ema89[0], d1Ema200[0]);
   
   // Scan past D1 swing highs and lows
   report += "Past 10 Daily Lows:\n";
   for(int d = 1; d <= 10; d++)
   {
      report += StringFormat("  D1[%d] (%s): Low = %.2f, High = %.2f\n",
                             d, TimeToString(d1Rates[d].time, TIME_DATE), d1Rates[d].low, d1Rates[d].high);
   }
   report += "\n";

   // 3. H4 (4-HOUR) STRUCTURE & ZONES
   MqlRates h4Rates[];
   ArraySetAsSeries(h4Rates, true);
   CopyRates(_Symbol, PERIOD_H4, 0, 60, h4Rates);

   int hH4EMA34 = iMA(_Symbol, PERIOD_H4, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hH4EMA89 = iMA(_Symbol, PERIOD_H4, 89, 0, MODE_EMA, PRICE_CLOSE);
   int hH4EMA200= iMA(_Symbol, PERIOD_H4, 200, 0, MODE_EMA, PRICE_CLOSE);
   int hH4RSI   = iRSI(_Symbol, PERIOD_H4, 14, PRICE_CLOSE);

   double h4Ema34[2], h4Ema89[2], h4Ema200[2], h4Rsi[2];
   ArraySetAsSeries(h4Ema34, true); ArraySetAsSeries(h4Ema89, true); ArraySetAsSeries(h4Ema200, true); ArraySetAsSeries(h4Rsi, true);
   CopyBuffer(hH4EMA34, 0, 0, 2, h4Ema34);
   CopyBuffer(hH4EMA89, 0, 0, 2, h4Ema89);
   CopyBuffer(hH4EMA200, 0, 0, 2, h4Ema200);
   CopyBuffer(hH4RSI, 0, 0, 2, h4Rsi);

   report += "--- 2. H4 STRUCTURE & INSTITUTIONAL FOOTPRINTS ---\n";
   report += StringFormat("H4 EMA 34: %.2f | H4 EMA 89: %.2f | H4 EMA 200: %.2f | H4 RSI: %.1f\n",
                          h4Ema34[0], h4Ema89[0], h4Ema200[0], h4Rsi[0]);
   report += "Recent H4 Bars:\n";
   for(int h = 0; h < 8; h++)
   {
      report += StringFormat("  H4[%d] (%s): O=%.2f, H=%.2f, L=%.2f, C=%.2f\n",
                             h, TimeToString(h4Rates[h].time), h4Rates[h].open, h4Rates[h].high, h4Rates[h].low, h4Rates[h].close);
   }

   // Search H4 Swings and FVGs near 3981
   report += "H4 Swings & Candles near 3981 (+/- $15.00):\n";
   for(int h = 1; h < 55; h++)
   {
      if((h4Rates[h].low >= 3965.0 && h4Rates[h].low <= 3995.0) ||
         (h4Rates[h].high >= 3965.0 && h4Rates[h].high <= 3995.0))
      {
         report += StringFormat("  * H4[%d] @ %s | Low=%.2f, High=%.2f, Close=%.2f, Vol=%d\n",
                                h, TimeToString(h4Rates[h].time), h4Rates[h].low, h4Rates[h].high, h4Rates[h].close, h4Rates[h].tick_volume);
      }
   }
   report += "\n";

   // 4. H1 (1-HOUR) STRUCTURE & ZONES
   MqlRates h1Rates[];
   ArraySetAsSeries(h1Rates, true);
   CopyRates(_Symbol, PERIOD_H1, 0, 100, h1Rates);

   int hH1EMA34 = iMA(_Symbol, PERIOD_H1, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hH1EMA89 = iMA(_Symbol, PERIOD_H1, 89, 0, MODE_EMA, PRICE_CLOSE);
   int hH1EMA200= iMA(_Symbol, PERIOD_H1, 200, 0, MODE_EMA, PRICE_CLOSE);
   int hH1RSI   = iRSI(_Symbol, PERIOD_H1, 14, PRICE_CLOSE);

   double h1Ema34[2], h1Ema89[2], h1Ema200[2], h1Rsi[2];
   ArraySetAsSeries(h1Ema34, true); ArraySetAsSeries(h1Ema89, true); ArraySetAsSeries(h1Ema200, true); ArraySetAsSeries(h1Rsi, true);
   CopyBuffer(hH1EMA34, 0, 0, 2, h1Ema34);
   CopyBuffer(hH1EMA89, 0, 0, 2, h1Ema89);
   CopyBuffer(hH1EMA200, 0, 0, 2, h1Ema200);
   CopyBuffer(hH1RSI, 0, 0, 2, h1Rsi);

   report += "--- 3. H1 STRUCTURE & LIQUIDITY LEVELS ---\n";
   report += StringFormat("H1 EMA 34: %.2f | H1 EMA 89: %.2f | H1 EMA 200: %.2f | H1 RSI: %.1f\n",
                          h1Ema34[0], h1Ema89[0], h1Ema200[0], h1Rsi[0]);
   report += "Recent H1 Bars during the drop:\n";
   for(int h = 0; h < 12; h++)
   {
      report += StringFormat("  H1[%d] (%s): O=%.2f, H=%.2f, L=%.2f, C=%.2f, Vol=%d\n",
                             h, TimeToString(h1Rates[h].time), h1Rates[h].open, h1Rates[h].high, h1Rates[h].low, h1Rates[h].close, h1Rates[h].tick_volume);
   }

   // Search H1 Bullish Order Blocks & FVGs near 3981
   report += "H1 Key Historical Points near 3981 (+/- $10.00):\n";
   for(int h = 1; h < 95; h++)
   {
      if(MathAbs(h1Rates[h].low - 3981.0) <= 6.0 || MathAbs(h1Rates[h].high - 3981.0) <= 6.0)
      {
         report += StringFormat("  * H1[%d] @ %s | Low=%.2f, High=%.2f, Close=%.2f\n",
                                h, TimeToString(h1Rates[h].time), h1Rates[h].low, h1Rates[h].high, h1Rates[h].close);
      }
   }
   report += "\n";

   // 5. M15 & M5 INTRADAY CHRONOLOGY OF THE DROP
   report += "--- 4. M5 INTRADAY DROP CHRONOLOGY & EXACT BOUNCE MECHANISM ---\n";
   // Find the lowest bar of the drop
   int minBarIdx = 0;
   double minPrice = 999999.0;
   for(int m = 0; m < 50; m++)
   {
      if(m5Rates[m].low < minPrice)
      {
         minPrice = m5Rates[m].low;
         minBarIdx = m;
      }
   }
   report += StringFormat("Lowest point reached on M5: %.2f at %s (Bar M5[%d])\n",
                          minPrice, TimeToString(m5Rates[minBarIdx].time), minBarIdx);
   report += "M5 sequence around the bounce:\n";
   for(int m = minBarIdx + 5; m >= MathMax(0, minBarIdx - 5); m--)
   {
      double rRange = m5Rates[m].high - m5Rates[m].low;
      double lWick  = MathMin(m5Rates[m].open, m5Rates[m].close) - m5Rates[m].low;
      report += StringFormat("  M5[%d] (%s): O=%.2f, H=%.2f, L=%.2f, C=%.2f | Range=%.2f | LowWick=%.2f (%.1f%%) | Vol=%d\n",
                             m, TimeToString(m5Rates[m].time), m5Rates[m].open, m5Rates[m].high, m5Rates[m].low, m5Rates[m].close,
                             rRange, lWick, (rRange > 0) ? (lWick/rRange*100.0) : 0, m5Rates[m].tick_volume);
   }

   FileWriteString(fileHandle, report);
   FileClose(fileHandle);

   Print("Multi-Timeframe Audit finished. Results written to MQL5\\Files\\analysis_3981.txt");
}

