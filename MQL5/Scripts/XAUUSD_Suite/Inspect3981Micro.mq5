//+------------------------------------------------------------------+
//|                                           Inspect3981Micro.mq5  |
//|                                  Copyright 2026, Antigravity AI  |
//+------------------------------------------------------------------+
#property copyright "Antigravity AI"
#property script_show_inputs false

void OnStart()
{
   int fileHandle = FileOpen("micro_3981.txt", FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(fileHandle == INVALID_HANDLE) return;

   MqlRates m5Rates[];
   ArraySetAsSeries(m5Rates, true);
   int copied = CopyRates(_Symbol, PERIOD_M5, 0, 300, m5Rates);

   string text = "CHRONOLOGY OF M5 BARS BETWEEN 10:00 AND 14:30 TODAY (DROP TO 3981):\n";
   text += "Time | Open | High | Low | Close | Range | Vol | Lower Wick | Upper Wick\n";

   for(int i = 0; i < copied; i++)
   {
      MqlDateTime dt;
      TimeToStruct(m5Rates[i].time, dt);
      if(dt.year == 2026 && dt.mon == 10 && dt.day == 30 && dt.hour >= 8 && dt.hour <= 15)
      {
         double o = m5Rates[i].open;
         double h = m5Rates[i].high;
         double l = m5Rates[i].low;
         double c = m5Rates[i].close;
         double rng = h - l;
         double lWick = MathMin(o, c) - l;
         double uWick = h - MathMax(o, c);
         text += StringFormat("%s | %.2f | %.2f | %.2f | %.2f | %.2f | %d | %.2f (%.1f%%) | %.2f (%.1f%%)\n",
                              TimeToString(m5Rates[i].time), o, h, l, c, rng, m5Rates[i].tick_volume,
                              lWick, (rng>0)?(lWick/rng*100):0, uWick, (rng>0)?(uWick/rng*100):0);
      }
   }

   FileWriteString(fileHandle, text);
   FileClose(fileHandle);
}

