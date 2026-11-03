//+------------------------------------------------------------------+
//|                                             TestTunedFilter.mq5 |
//|                                  Copyright 2026, Antigravity AI |
//|        Test tuned filter on recent 800 bars to verify Bar[12]   |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "1.00"
#property script_show_inputs false

void OnStart()
{
   int fileHandle = FileOpen("tuned_filter_result.txt", FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(fileHandle == INVALID_HANDLE) return;

   int totalBars = 800;
   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   int copied = CopyRates(_Symbol, PERIOD_M5, 0, totalBars, rates);

   int hDh = iMA(_Symbol, PERIOD_M5, 34, 0, MODE_EMA, PRICE_HIGH);
   int hDc = iMA(_Symbol, PERIOD_M5, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hDl = iMA(_Symbol, PERIOD_M5, 34, 0, MODE_EMA, PRICE_LOW);
   int h89 = iMA(_Symbol, PERIOD_M5, 89, 0, MODE_EMA, PRICE_CLOSE);
   int h200= iMA(_Symbol, PERIOD_M5, 200, 0, MODE_EMA, PRICE_CLOSE);
   int hAtr= iATR(_Symbol, PERIOD_M5, 14);

   double dh[], dc[], dl[], e89[], e200[], atr[];
   ArraySetAsSeries(dh, true); ArraySetAsSeries(dc, true); ArraySetAsSeries(dl, true);
   ArraySetAsSeries(e89, true); ArraySetAsSeries(e200, true); ArraySetAsSeries(atr, true);
   CopyBuffer(hDh, 0, 0, totalBars, dh);
   CopyBuffer(hDc, 0, 0, totalBars, dc);
   CopyBuffer(hDl, 0, 0, totalBars, dl);
   CopyBuffer(h89, 0, 0, totalBars, e89);
   CopyBuffer(h200, 0, 0, totalBars, e200);
   CopyBuffer(hAtr, 0, 0, totalBars, atr);

   int countBuy = 0, countSell = 0;
   string out = "=== BACKTEST OF TUNED FILTER ON 800 BARS ===\n\n";

   double signalSell[];
   double signalBuy[];
   ArrayResize(signalSell, totalBars);
   ArrayResize(signalBuy, totalBars);
   ArrayInitialize(signalSell, EMPTY_VALUE);
   ArrayInitialize(signalBuy, EMPTY_VALUE);

   for(int i = totalBars - 1; i >= 1; i--)
   {
      double cRange = rates[i].high - rates[i].low;
      if(cRange < 1.50) continue;

      double uWick = rates[i].high - MathMax(rates[i].open, rates[i].close);
      double lWick = MathMin(rates[i].open, rates[i].close) - rates[i].low;
      double uRatio = uWick / cRange;
      double lRatio = lWick / cRange;
      double body = MathAbs(rates[i].close - rates[i].open);
      double bodyRatio = body / cRange;

      bool isSonicBullM5 = (dc[i] > e89[i]);
      bool isSonicBearM5 = (dc[i] < e89[i]);
      bool isDragonChop = (MathAbs(dc[i] - e89[i]) < 0.60 * atr[i]);

      // TUNED BEAR WICK:
      // Allow opposite wick up to 25% normally, or up to 28% if uRatio >= 50%, or absolute lWick <= $0.70
      bool oppWickBearOk = (lRatio <= 0.25) || (lWick <= 0.70) || (uRatio >= 0.50 && lRatio <= 0.28);
      bool isBearWickForm = (uRatio >= 0.40) &&
                            (uWick >= 1.00) &&
                            (uWick >= 1.8 * body) &&
                            (bodyRatio <= 0.38) &&
                            oppWickBearOk &&
                            ((rates[i].close - rates[i].low) / cRange <= 0.38);

      if(isBearWickForm)
      {
         string zName = "";
         if(rates[i].high >= e200[i] - 0.20 && rates[i].close <= e200[i] + 0.25) zName = "EMA200";
         else if(rates[i].high >= e89[i] - 0.20 && rates[i].close <= e89[i] + 0.25) zName = "EMA89";
         else if(rates[i].high >= dh[i] - 0.20 && rates[i].close <= dh[i] + 0.25) zName = "DragonHigh";
         else if(rates[i].high >= dc[i] - 0.20 && rates[i].close <= dc[i] + 0.25) zName = "DragonAxis";
         else if(rates[i].high >= dl[i] - 0.20 && rates[i].close <= dl[i] + 0.25) zName = "DragonLow";

         if(zName != "")
         {
            bool allowSell = (isSonicBearM5 && !isDragonChop) || (zName == "EMA200") || (zName == "EMA89" && dc[i] <= e89[i] + 0.50);
            if(isSonicBullM5 && !isDragonChop && zName != "EMA200") allowSell = false;

            if(allowSell)
            {
               bool cooldownOk = true;
               double maxRecentHigh = 0.0;
               for(int k = 1; k <= 3 && (i + k) < totalBars; k++)
               {
                  if(signalSell[i + k] != EMPTY_VALUE && rates[i + k].high > maxRecentHigh)
                     maxRecentHigh = rates[i + k].high;
               }
               if(maxRecentHigh > 0.0 && rates[i].high < maxRecentHigh + 0.40) cooldownOk = false;

               if(cooldownOk)
               {
                  signalSell[i] = rates[i].high;
                  countSell++;
                  out += StringFormat("SELL at Bar[%d] (%s): O=%.2f H=%.2f L=%.2f C=%.2f | zName=%s | uWick=%.2f (%.1f%%) | lWick=%.2f (%.1f%%)\n",
                                      i, TimeToString(rates[i].time), rates[i].open, rates[i].high, rates[i].low, rates[i].close,
                                      zName, uWick, uRatio*100, lWick, lRatio*100);
               }
            }
         }
      }

      // TUNED BULL WICK:
      bool oppWickBullOk = (uRatio <= 0.25) || (uWick <= 0.70) || (lRatio >= 0.50 && uRatio <= 0.28);
      bool isBullWickForm = (lRatio >= 0.40) &&
                            (lWick >= 1.00) &&
                            (lWick >= 1.8 * body) &&
                            (bodyRatio <= 0.38) &&
                            oppWickBullOk &&
                            ((rates[i].high - rates[i].close) / cRange <= 0.38);

      if(isBullWickForm)
      {
         string zName = "";
         if(rates[i].low <= e200[i] + 0.20 && rates[i].close >= e200[i] - 0.25) zName = "EMA200";
         else if(rates[i].low <= e89[i] + 0.20 && rates[i].close >= e89[i] - 0.25) zName = "EMA89";
         else if(rates[i].low <= dl[i] + 0.20 && rates[i].close >= dl[i] - 0.25) zName = "DragonLow";
         else if(rates[i].low <= dc[i] + 0.20 && rates[i].close >= dc[i] - 0.25) zName = "DragonAxis";
         else if(rates[i].low <= dh[i] + 0.20 && rates[i].close >= dh[i] - 0.25) zName = "DragonHigh";

         if(zName != "")
         {
            bool allowBuy = (isSonicBullM5 && !isDragonChop) || (zName == "EMA200") || (zName == "EMA89" && dc[i] >= e89[i] - 0.50);
            if(isSonicBearM5 && !isDragonChop && zName != "EMA200") allowBuy = false;

            if(allowBuy)
            {
               bool cooldownOk = true;
               double minRecentLow = 999999.0;
               for(int k = 1; k <= 3 && (i + k) < totalBars; k++)
               {
                  if(signalBuy[i + k] != EMPTY_VALUE && rates[i + k].low < minRecentLow)
                     minRecentLow = rates[i + k].low;
               }
               if(minRecentLow < 999999.0 && rates[i].low > minRecentLow - 0.40) cooldownOk = false;

               if(cooldownOk)
               {
                  signalBuy[i] = rates[i].low;
                  countBuy++;
                  out += StringFormat("BUY  at Bar[%d] (%s): O=%.2f H=%.2f L=%.2f C=%.2f | zName=%s | lWick=%.2f (%.1f%%) | uWick=%.2f (%.1f%%)\n",
                                      i, TimeToString(rates[i].time), rates[i].open, rates[i].high, rates[i].low, rates[i].close,
                                      zName, lWick, lRatio*100, uWick, uRatio*100);
               }
            }
         }
      }
   }

   out += StringFormat("\nTOTAL SIGNALS ON 800 BARS: Buy=%d | Sell=%d | Total=%d\n", countBuy, countSell, countBuy + countSell);

   FileWriteString(fileHandle, out);
   FileClose(fileHandle);
}
