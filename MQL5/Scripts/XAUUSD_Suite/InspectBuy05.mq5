//+------------------------------------------------------------------+
//|                                                InspectBuy05.mq5 |
//|                                  Copyright 2026, Antigravity AI |
//|        Comprehensive Multi-Timeframe Technical Audit for Buy 3905 |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "1.00"
#property script_show_inputs false

void OnStart()
{
   Print("=== STARTING AUDIT FOR BUY 3905 ===");

   int fileHandle = FileOpen("audit_buy_05.txt", FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(fileHandle == INVALID_HANDLE)
   {
      Print("Failed to open output file.");
      return;
   }

   string report = "";
   report += "========================================================================================\n";
   report += "MULTI-TIMEFRAME TECHNICAL AUDIT: EVALUATION OF TIMING BUY AT 3905.00 (XAUUSD)\n";
   report += "========================================================================================\n\n";

   double curBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double curAsk = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   report += StringFormat("Symbol: %s | Current Bid: %.2f | Ask: %.2f | Server Time: %s\n\n",
                          _Symbol, curBid, curAsk, TimeToString(TimeCurrent()));

   // 1. M5 MICRO STRUCTURE
   MqlRates m5Rates[];
   ArraySetAsSeries(m5Rates, true);
   CopyRates(_Symbol, PERIOD_M5, 0, 100, m5Rates);

   int hM5Ema34H = iMA(_Symbol, PERIOD_M5, 34, 0, MODE_EMA, PRICE_HIGH);
   int hM5Ema34C = iMA(_Symbol, PERIOD_M5, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hM5Ema34L = iMA(_Symbol, PERIOD_M5, 34, 0, MODE_EMA, PRICE_LOW);
   int hM5E89    = iMA(_Symbol, PERIOD_M5, 89, 0, MODE_EMA, PRICE_CLOSE);
   int hM5E200   = iMA(_Symbol, PERIOD_M5, 200, 0, MODE_EMA, PRICE_CLOSE);
   int hM5Rsi    = iRSI(_Symbol, PERIOD_M5, 14, PRICE_CLOSE);
   int hM5Atr    = iATR(_Symbol, PERIOD_M5, 14);

   double m5Dh[], m5Dc[], m5Dl[], m5E89[], m5E200[], m5Rsi[], m5Atr[];
   ArraySetAsSeries(m5Dh, true); ArraySetAsSeries(m5Dc, true); ArraySetAsSeries(m5Dl, true);
   ArraySetAsSeries(m5E89, true); ArraySetAsSeries(m5E200, true); ArraySetAsSeries(m5Rsi, true); ArraySetAsSeries(m5Atr, true);
   CopyBuffer(hM5Ema34H, 0, 0, 5, m5Dh);
   CopyBuffer(hM5Ema34C, 0, 0, 5, m5Dc);
   CopyBuffer(hM5Ema34L, 0, 0, 5, m5Dl);
   CopyBuffer(hM5E89, 0, 0, 5, m5E89);
   CopyBuffer(hM5E200, 0, 0, 5, m5E200);
   CopyBuffer(hM5Rsi, 0, 0, 5, m5Rsi);
   CopyBuffer(hM5Atr, 0, 0, 5, m5Atr);

   report += "--- 1. M5 MICRO PERSPECTIVE ---\n";
   report += StringFormat("M5 Dragon: High=%.2f, Axis=%.2f, Low=%.2f\n", m5Dh[0], m5Dc[0], m5Dl[0]);
   report += StringFormat("M5 EMA 89: %.2f | M5 EMA 200: %.2f\n", m5E89[0], m5E200[0]);
   report += StringFormat("M5 RSI(14): %.2f | M5 ATR(14): %.2f\n", m5Rsi[0], m5Atr[0]);
   report += StringFormat("Distance from Price (%.2f) to 3905.00: %.2f pts\n", curBid, curBid - 3905.00);
   report += StringFormat("Distance from Price to M5 Dragon Low: %.2f pts\n", curBid - m5Dl[0]);
   report += "Recent 5 M5 Candles:\n";
   for(int i = 0; i < 5; i++)
   {
      report += StringFormat("  M5[%d] (%s): O=%.2f, H=%.2f, L=%.2f, C=%.2f, Range=%.2f, TickVol=%d\n",
                             i, TimeToString(m5Rates[i].time, TIME_MINUTES), m5Rates[i].open, m5Rates[i].high, m5Rates[i].low, m5Rates[i].close,
                             m5Rates[i].high - m5Rates[i].low, (int)m5Rates[i].tick_volume);
   }
   report += "\n";

   // 2. M15 STRUCTURE
   MqlRates m15Rates[];
   ArraySetAsSeries(m15Rates, true);
   CopyRates(_Symbol, PERIOD_M15, 0, 60, m15Rates);

   int hM15Ema34C = iMA(_Symbol, PERIOD_M15, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hM15E89    = iMA(_Symbol, PERIOD_M15, 89, 0, MODE_EMA, PRICE_CLOSE);
   int hM15E200   = iMA(_Symbol, PERIOD_M15, 200, 0, MODE_EMA, PRICE_CLOSE);
   int hM15Rsi    = iRSI(_Symbol, PERIOD_M15, 14, PRICE_CLOSE);
   int hM15Atr    = iATR(_Symbol, PERIOD_M15, 14);

   double m15Dc[], m15E89[], m15E200[], m15Rsi[], m15Atr[];
   ArraySetAsSeries(m15Dc, true); ArraySetAsSeries(m15E89, true); ArraySetAsSeries(m15E200, true);
   ArraySetAsSeries(m15Rsi, true); ArraySetAsSeries(m15Atr, true);
   CopyBuffer(hM15Ema34C, 0, 0, 3, m15Dc);
   CopyBuffer(hM15E89, 0, 0, 3, m15E89);
   CopyBuffer(hM15E200, 0, 0, 3, m15E200);
   CopyBuffer(hM15Rsi, 0, 0, 3, m15Rsi);
   CopyBuffer(hM15Atr, 0, 0, 3, m15Atr);

   report += "--- 2. M15 STRUCTURE ---\n";
   report += StringFormat("M15 EMA 34: %.2f | EMA 89: %.2f | EMA 200: %.2f\n", m15Dc[0], m15E89[0], m15E200[0]);
   report += StringFormat("M15 RSI: %.2f | M15 ATR: %.2f\n", m15Rsi[0], m15Atr[0]);
   report += "Recent 5 M15 Candles:\n";
   for(int i = 0; i < 5; i++)
   {
      report += StringFormat("  M15[%d] (%s): O=%.2f, H=%.2f, L=%.2f, C=%.2f\n",
                             i, TimeToString(m15Rates[i].time), m15Rates[i].open, m15Rates[i].high, m15Rates[i].low, m15Rates[i].close);
   }
   report += "\n";

   // 3. H1 & H4 TREND
   MqlRates h1Rates[], h4Rates[];
   ArraySetAsSeries(h1Rates, true); ArraySetAsSeries(h4Rates, true);
   CopyRates(_Symbol, PERIOD_H1, 0, 40, h1Rates);
   CopyRates(_Symbol, PERIOD_H4, 0, 40, h4Rates);

   int hH1E34 = iMA(_Symbol, PERIOD_H1, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hH1E89 = iMA(_Symbol, PERIOD_H1, 89, 0, MODE_EMA, PRICE_CLOSE);
   int hH1E200= iMA(_Symbol, PERIOD_H1, 200, 0, MODE_EMA, PRICE_CLOSE);
   int hH1Rsi = iRSI(_Symbol, PERIOD_H1, 14, PRICE_CLOSE);

   int hH4E34 = iMA(_Symbol, PERIOD_H4, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hH4E89 = iMA(_Symbol, PERIOD_H4, 89, 0, MODE_EMA, PRICE_CLOSE);
   int hH4E200= iMA(_Symbol, PERIOD_H4, 200, 0, MODE_EMA, PRICE_CLOSE);
   int hH4Rsi = iRSI(_Symbol, PERIOD_H4, 14, PRICE_CLOSE);

   double h1E34[], h1E89[], h1E200[], h1Rsi[];
   double h4E34[], h4E89[], h4E200[], h4Rsi[];
   ArraySetAsSeries(h1E34, true); ArraySetAsSeries(h1E89, true); ArraySetAsSeries(h1E200, true); ArraySetAsSeries(h1Rsi, true);
   ArraySetAsSeries(h4E34, true); ArraySetAsSeries(h4E89, true); ArraySetAsSeries(h4E200, true); ArraySetAsSeries(h4Rsi, true);
   CopyBuffer(hH1E34, 0, 0, 2, h1E34); CopyBuffer(hH1E89, 0, 0, 2, h1E89); CopyBuffer(hH1E200, 0, 0, 2, h1E200); CopyBuffer(hH1Rsi, 0, 0, 2, h1Rsi);
   CopyBuffer(hH4E34, 0, 0, 2, h4E34); CopyBuffer(hH4E89, 0, 0, 2, h4E89); CopyBuffer(hH4E200, 0, 0, 2, h4E200); CopyBuffer(hH4Rsi, 0, 0, 2, h4Rsi);

   report += "--- 3. H1 & H4 TREND CONFLUENCE ---\n";
   report += StringFormat("H1: EMA 34=%.2f | EMA 89=%.2f | EMA 200=%.2f | RSI=%.2f\n", h1E34[0], h1E89[0], h1E200[0], h1Rsi[0]);
   report += StringFormat("H4: EMA 34=%.2f | EMA 89=%.2f | EMA 200=%.2f | RSI=%.2f\n", h4E34[0], h4E89[0], h4E200[0], h4Rsi[0]);
   report += "\n";

   // 4. SCAN HISTORICAL SUPPORTS & RESISTANCES AROUND 3895 - 3915
   report += "--- 4. HISTORICAL PRICE ACTION & STRUCTURE AROUND 3900 - 3910 ---\n";
   report += "Scanning past M15 swings near 3905 (+/- $10.00):\n";
   for(int i = 5; i < 60; i++)
   {
      if(m15Rates[i].low <= 3915.0 && m15Rates[i].high >= 3895.0)
      {
         report += StringFormat("  M15[%d] (%s): Low=%.2f, High=%.2f, Close=%.2f\n",
                                i, TimeToString(m15Rates[i].time), m15Rates[i].low, m15Rates[i].high, m15Rates[i].close);
      }
   }
   report += "\n";

   report += "Scanning past H1 swings near 3905 (+/- $15.00):\n";
   for(int i = 1; i < 40; i++)
   {
      if(h1Rates[i].low <= 3920.0 && h1Rates[i].high >= 3890.0)
      {
         report += StringFormat("  H1[%d] (%s): Low=%.2f, High=%.2f, Open=%.2f, Close=%.2f\n",
                                i, TimeToString(h1Rates[i].time), h1Rates[i].low, h1Rates[i].high, h1Rates[i].open, h1Rates[i].close);
      }
   }
   report += "\n";

   // 5. SESSION LEVELS (TPO / SESSIONS)
   report += "--- 5. TODAY'S SESSIONS (ASIA & EARLY LONDON) ---\n";
   // Let's find today's High and Low so far
   datetime startOfDay = iTime(_Symbol, PERIOD_D1, 0);
   double dayHigh = -1.0, dayLow = 999999.0;
   for(int i = 0; i < 150; i++)
   {
      if(m5Rates[i].time >= startOfDay)
      {
         if(m5Rates[i].high > dayHigh) dayHigh = m5Rates[i].high;
         if(m5Rates[i].low < dayLow)   dayLow = m5Rates[i].low;
      }
      else break;
   }
   report += StringFormat("Today's High: %.2f | Today's Low: %.2f | Today's Daily Range: %.2f pts\n",
                          dayHigh, dayLow, dayHigh - dayLow);

   FileWriteString(fileHandle, report);
   FileClose(fileHandle);
   Print("Audit completed successfully. Output written to audit_buy_05.txt");
}
