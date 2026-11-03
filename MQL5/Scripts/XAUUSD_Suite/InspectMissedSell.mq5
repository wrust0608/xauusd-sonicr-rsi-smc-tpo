//+------------------------------------------------------------------+
//|                                           InspectMissedSell.mq5 |
//|                                  Copyright 2026, Antigravity AI |
//|           Diagnostic script to find why EMA 34 pullback missed   |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "1.00"
#property script_show_inputs false

void OnStart()
{
   int fileHandle = FileOpen("missed_sell_diag.txt", FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(fileHandle == INVALID_HANDLE) return;

   MqlRates m5[];
   ArraySetAsSeries(m5, true);
   int copied = CopyRates(_Symbol, PERIOD_M5, 0, 30, m5);

   int hDh = iMA(_Symbol, PERIOD_M5, 34, 0, MODE_EMA, PRICE_HIGH);
   int hDc = iMA(_Symbol, PERIOD_M5, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hDl = iMA(_Symbol, PERIOD_M5, 34, 0, MODE_EMA, PRICE_LOW);
   int h89 = iMA(_Symbol, PERIOD_M5, 89, 0, MODE_EMA, PRICE_CLOSE);
   int h200= iMA(_Symbol, PERIOD_M5, 200, 0, MODE_EMA, PRICE_CLOSE);
   int hAtr= iATR(_Symbol, PERIOD_M5, 14);

   double dh[], dc[], dl[], e89[], e200[], atr[];
   ArraySetAsSeries(dh, true); ArraySetAsSeries(dc, true); ArraySetAsSeries(dl, true);
   ArraySetAsSeries(e89, true); ArraySetAsSeries(e200, true); ArraySetAsSeries(atr, true);
   CopyBuffer(hDh, 0, 0, 30, dh);
   CopyBuffer(hDc, 0, 0, 30, dc);
   CopyBuffer(hDl, 0, 0, 30, dl);
   CopyBuffer(h89, 0, 0, 30, e89);
   CopyBuffer(h200, 0, 0, 30, e200);
   CopyBuffer(hAtr, 0, 0, 30, atr);

   string out = "=== DETAILED AUDIT OF RECENT 25 M5 BARS ===\n\n";

   for(int i = 0; i < 25; i++)
   {
      double cRange = m5[i].high - m5[i].low;
      double uWick  = m5[i].high - MathMax(m5[i].open, m5[i].close);
      double lWick  = MathMin(m5[i].open, m5[i].close) - m5[i].low;
      double body   = MathAbs(m5[i].close - m5[i].open);
      double uRatio = (cRange > 0) ? (uWick / cRange) : 0;
      double lRatio = (cRange > 0) ? (lWick / cRange) : 0;
      double bodyRatio = (cRange > 0) ? (body / cRange) : 0;
      double closeLowRatio = (cRange > 0) ? ((m5[i].close - m5[i].low) / cRange) : 0;

      // Filter checks
      bool f_range = (cRange >= 1.50);
      bool f_uRatio = (uRatio >= 0.45);
      bool f_uWickPts = (uWick >= 1.00);
      bool f_wickBody = (uWick >= 2.0 * body);
      bool f_bodyRatio = (bodyRatio <= 0.35);
      bool f_oppWick = (lRatio <= 0.20);
      bool f_closeExtreme = (closeLowRatio <= 0.35);

      bool isBearWickForm = f_uRatio && f_uWickPts && f_wickBody && f_bodyRatio && f_oppWick && f_closeExtreme;

      // Check touch of EMA 34 / Dragon
      bool touchDragonLow  = (m5[i].high >= dl[i] - 0.20);
      bool touchDragonAxis = (m5[i].high >= dc[i] - 0.20);
      bool touchDragonHigh = (m5[i].high >= dh[i] - 0.20);
      bool touchE89        = (m5[i].high >= e89[i] - 0.20);

      // Check close rejection
      bool closeRejLow  = (m5[i].close <= dl[i] + 0.15);
      bool closeRejAxis = (m5[i].close <= dc[i] + 0.15);

      out += StringFormat("Bar[%d] Time: %s | O=%.2f H=%.2f L=%.2f C=%.2f | Range=%.2f\n",
                          i, TimeToString(m5[i].time, TIME_MINUTES), m5[i].open, m5[i].high, m5[i].low, m5[i].close, cRange);
      out += StringFormat("   Dragon: Low=%.2f, Axis=%.2f, High=%.2f | EMA89=%.2f\n", dl[i], dc[i], dh[i], e89[i]);
      out += StringFormat("   uWick=%.2f (%.1f%%) | Body=%.2f (%.1f%%) | lWick=%.2f (%.1f%%) | CloseAtLow=%.1f%%\n",
                          uWick, uRatio*100, body, bodyRatio*100, lWick, lRatio*100, closeLowRatio*100);
      out += StringFormat("   Checks: Range:%d, uRatio(>=45%%):%d, uPts(>=1):%d, 2xBody:%d, Body(<=35%%):%d, OppWick(<=20%%):%d, CloseExt(<=35%%):%d\n",
                          f_range, f_uRatio, f_uWickPts, f_wickBody, f_bodyRatio, f_oppWick, f_closeExtreme);
      out += StringFormat("   Touch: DL:%d, DC:%d, DH:%d, E89:%d | CloseRej: DL:%d, DC:%d | FormPass:%d\n\n",
                          touchDragonLow, touchDragonAxis, touchDragonHigh, touchE89, closeRejLow, closeRejAxis, isBearWickForm);
   }

   FileWriteString(fileHandle, out);
   FileClose(fileHandle);
}
