//+------------------------------------------------------------------+
//|                                         SonicR_Setup_Overlay.mq5 |
//|                                  Copyright 2026, Antigravity AI |
//|                       XAUUSD Quantitative Visualizer - Unleashed |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "2.55"
#property description "XAUUSD Sonic R Suite: Dragon Cloud, Trend 89, Macro 200, Swings, Round Numbers, Clean HUD & MTF Signals"
#property indicator_chart_window
#property indicator_buffers 12
#property indicator_plots   7

//--- Plot 1: Dragon Cloud High
#property indicator_label1  "Dragon High"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDodgerBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//--- Plot 2: Dragon Center (EMA 34 Close)
#property indicator_label2  "Dragon Center"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrDeepSkyBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2

//--- Plot 3: Dragon Cloud Low
#property indicator_label3  "Dragon Low"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrDodgerBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

//--- Plot 4: Trend Line (EMA 89)
#property indicator_label4  "Trend Line (EMA 89)"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrOrange
#property indicator_style4  STYLE_SOLID
#property indicator_width4  2

//--- Plot 5: Macro EMA 200
#property indicator_label5  "Macro EMA 200"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrSilver
#property indicator_style5  STYLE_DASH
#property indicator_width5  1

//--- Plot 6: Bullish Setup Trigger
#property indicator_label6  "Potential Bull Setup"
#property indicator_type6   DRAW_ARROW
#property indicator_color6  clrSpringGreen
#property indicator_width6  2

//--- Plot 7: Bearish Setup Trigger
#property indicator_label7  "Potential Bear Setup"
#property indicator_type7   DRAW_ARROW
#property indicator_color7  clrRed
#property indicator_width7  2

//--- Input Parameters
input group "=== 1. MTF Trend Confluence Settings ==="
input bool     InpStrictHtf      = false;       // Strict H4 & H1 Full Alignment
input double   InpMinSlope       = 0.05;        // Min H4/H1 WMA45 Slope
input double   InpTangleSpread   = 2.5;         // Min H4/H1 3-Line Spread (No Tangle)
input double   InpW45Tolerance   = 2.0;         // M15 WMA45 Touch Tolerance (Points)

input group "=== 2. M5 Price Action Wave & Trigger ==="
input int      InpPivotLookback  = 24;          // M5 Pivot Max Lookback (6-50)
input double   InpDoubleTol      = 3.0;         // M5 Double Bottom/Top Tolerance
input double   InpDoubleProm     = 4.0;         // M5 Double Bottom/Top Prominence
input bool     InpRequireEma200  = false;       // Require Price Beyond EMA 200
input int      InpTriggerMode    = 0;           // Trigger Mode (0=Bounce Dragon, 1=Break Swing)
input double   InpRoundStep      = 10.0;        // Round Number Grid Step (Gold = $10)

input group "=== 3. Visual Dashboard & HUD ==="
input bool     InpShowHUD        = true;        // Show On-Chart Information HUD
input int      InpHUDCorner      = 1;           // HUD Corner (1 = Top Right, 0 = Top Left)
input color    InpHUDColor       = clrWhite;    // HUD Text Color

input group "=== 4. Multi-Channel Alert Settings ==="
input bool     InpEnablePopup    = true;        // Enable Pop-up Alert
input bool     InpEnableSound    = true;        // Enable Sound Alert
input bool     InpEnablePush     = false;       // Enable Push Notification (Phone)
input bool     InpEnableEmail    = false;       // Enable Email Alert

//--- Indicator Buffers
double BufferDh[];
double BufferDc[];
double BufferDl[];
double BufferE89[];
double BufferE200[];
double BufferSwingHi[];
double BufferSwingLo[];
double BufferRoundHi[];
double BufferRoundLo[];
double BufferSignalBuy[];
double BufferSignalSell[];
double BufferCloud[]; // Hidden calculation buffer

//--- Handles
int handleEma34High;
int handleEma34Close;
int handleEma34Low;
int handleEma89;
int handleEma200;
int handleAtr14;

//--- State Variables
int      lock_u_bar;
int      lock_d_bar;
double   lock_ph;
double   lock_pl;
datetime lastAlertTime;
string   prefix;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0,  BufferDh,         INDICATOR_DATA);
   SetIndexBuffer(1,  BufferDc,         INDICATOR_DATA);
   SetIndexBuffer(2,  BufferDl,         INDICATOR_DATA);
   SetIndexBuffer(3,  BufferE89,        INDICATOR_DATA);
   SetIndexBuffer(4,  BufferE200,       INDICATOR_DATA);
   SetIndexBuffer(5,  BufferSignalBuy,  INDICATOR_DATA);
   SetIndexBuffer(6,  BufferSignalSell, INDICATOR_DATA);
   SetIndexBuffer(7,  BufferSwingHi,    INDICATOR_CALCULATIONS);
   SetIndexBuffer(8,  BufferSwingLo,    INDICATOR_CALCULATIONS);
   SetIndexBuffer(9,  BufferRoundHi,    INDICATOR_CALCULATIONS);
   SetIndexBuffer(10, BufferRoundLo,    INDICATOR_CALCULATIONS);
   SetIndexBuffer(11, BufferCloud,      INDICATOR_CALCULATIONS);

   PlotIndexSetInteger(5,  PLOT_ARROW, 233); // Wingdings Up Arrow
   PlotIndexSetInteger(6,  PLOT_ARROW, 234); // Wingdings Down Arrow

   for(int i = 0; i < 7; i++)
   {
      PlotIndexSetDouble(i, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   }

   prefix        = "SONIC_HUD_";
   ObjectsDeleteAll(0, prefix);

   handleEma34High  = iMA(_Symbol, _Period, 34, 0, MODE_EMA, PRICE_HIGH);
   handleEma34Close = iMA(_Symbol, _Period, 34, 0, MODE_EMA, PRICE_CLOSE);
   handleEma34Low   = iMA(_Symbol, _Period, 34, 0, MODE_EMA, PRICE_LOW);
   handleEma89      = iMA(_Symbol, _Period, 89, 0, MODE_EMA, PRICE_CLOSE);
   handleEma200     = iMA(_Symbol, _Period, 200, 0, MODE_EMA, PRICE_CLOSE);
   handleAtr14      = iATR(_Symbol, _Period, 14);

   if(handleEma34High == INVALID_HANDLE || handleEma34Close == INVALID_HANDLE ||
      handleEma34Low == INVALID_HANDLE  || handleEma89 == INVALID_HANDLE ||
      handleEma200 == INVALID_HANDLE    || handleAtr14 == INVALID_HANDLE)
   {
      Print("Error creating indicator handles on M5");
      return(INIT_FAILED);
   }

   lock_u_bar    = -1;
   lock_d_bar    = -1;
   lock_ph       = EMPTY_VALUE;
   lock_pl       = EMPTY_VALUE;
   lastAlertTime = 0;

   IndicatorSetString(INDICATOR_SHORTNAME, "Sonic R Overlay Unleashed (" + _Symbol + ")");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   IndicatorRelease(handleEma34High);
   IndicatorRelease(handleEma34Close);
   IndicatorRelease(handleEma34Low);
   IndicatorRelease(handleEma89);
   IndicatorRelease(handleEma200);
   IndicatorRelease(handleAtr14);
   ObjectsDeleteAll(0, prefix);
}

//+------------------------------------------------------------------+
//| Helper: Calculate RSI Wilder + EMA9 + WMA45 on an MTF timeframe  |
//+------------------------------------------------------------------+
bool GetHtfPulse(ENUM_TIMEFRAMES tf, double &out_r, double &out_e, double &out_w, double &out_slope)
{
   int requiredBars = 75;
   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   int copied = CopyRates(_Symbol, tf, 1, requiredBars, rates); // Closed bar [1]
   if(copied < requiredBars) return(false);

   double rsi[];
   ArrayResize(rsi, copied);
   ArrayInitialize(rsi, 0.0);

   double gainSum = 0.0, lossSum = 0.0;
   for(int i = copied - 2; i >= copied - 14; i--)
   {
      double diff = rates[i].close - rates[i + 1].close;
      if(diff > 0) gainSum += diff;
      else         lossSum += -diff;
   }
   double avgGain = gainSum / 14.0;
   double avgLoss = lossSum / 14.0;
   rsi[copied - 15] = (avgLoss == 0.0) ? 100.0 : 100.0 - (100.0 / (1.0 + (avgGain / avgLoss)));

   for(int i = copied - 16; i >= 0; i--)
   {
      double diff = rates[i].close - rates[i + 1].close;
      double g = (diff > 0) ? diff : 0.0;
      double l = (diff < 0) ? -diff : 0.0;
      avgGain = (avgGain * 13.0 + g) / 14.0;
      avgLoss = (avgLoss * 13.0 + l) / 14.0;
      rsi[i] = (avgLoss == 0.0) ? 100.0 : 100.0 - (100.0 / (1.0 + (avgGain / avgLoss)));
   }

   double k_ema = 2.0 / (9.0 + 1.0);
   double ema9 = rsi[copied - 25];
   for(int i = copied - 26; i >= 0; i--)
   {
      ema9 = rsi[i] * k_ema + ema9 * (1.0 - k_ema);
   }

   double num0 = 0.0, num1 = 0.0;
   double wSum = 45.0 * 46.0 / 2.0;
   for(int j = 0; j < 45; j++)
   {
      num0 += rsi[j] * (45 - j);
      num1 += rsi[j + 1] * (45 - j);
   }

   out_r     = rsi[0];
   out_e     = ema9;
   out_w     = num0 / wSum;
   out_slope = (num0 / wSum) - (num1 / wSum);
   return(true);
}

//+------------------------------------------------------------------+
//| Helper: Render On-Chart HUD Information Panel (Top-Right)        |
//+------------------------------------------------------------------+
void RenderHUD(bool htf_up, bool htf_dn, bool m15_up, bool m15_dn, double distDragon, string waveStatus)
{
   if(!InpShowHUD) return;

   int startX = 15;
   int startY = 15;
   int width  = 210;
   int height = 88;

   // HUD Background Box
   string bgName = prefix + "BG";
   if(ObjectFind(0, bgName) < 0)
   {
      ObjectCreate(0, bgName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, bgName, OBJPROP_BGCOLOR, C'15,18,24');
      ObjectSetInteger(0, bgName, OBJPROP_BORDER_COLOR, C'45,55,72');
      ObjectSetInteger(0, bgName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, bgName, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, bgName, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSetInteger(0, bgName, OBJPROP_XDISTANCE, startX);
   ObjectSetInteger(0, bgName, OBJPROP_YDISTANCE, startY);
   ObjectSetInteger(0, bgName, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, bgName, OBJPROP_YSIZE, height);

   string lines[5];
   lines[0] = "SONIC R XAUUSD (M5)";
   lines[1] = StringFormat("H4 Trend : %s", htf_up ? "BULLISH (UP)" : (htf_dn ? "BEARISH (DOWN)" : "NEUTRAL/TANGLE"));
   lines[2] = StringFormat("M15 Wait : %s", m15_up ? "BUY ZONE (40-50)" : (m15_dn ? "SELL ZONE (50-60)" : "NO SETUP"));
   lines[3] = StringFormat("M5 Wave  : %s", waveStatus);
   lines[4] = StringFormat("Dist Dragon: %.2f pts", distDragon);

   for(int i = 0; i < 5; i++)
   {
      string lblName = prefix + IntegerToString(i);
      if(ObjectFind(0, lblName) < 0)
      {
         ObjectCreate(0, lblName, OBJ_LABEL, 0, 0, 0);
         ObjectSetString(0, lblName, OBJPROP_FONT, (i == 0) ? "Segoe UI Bold" : "Segoe UI Semibold");
         ObjectSetInteger(0, lblName, OBJPROP_FONTSIZE, 8);
         ObjectSetInteger(0, lblName, OBJPROP_BACK, false);
      }
      ObjectSetInteger(0, lblName, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      ObjectSetInteger(0, lblName, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0, lblName, OBJPROP_XDISTANCE, startX + width - 10);
      ObjectSetInteger(0, lblName, OBJPROP_YDISTANCE, startY + 8 + (i * 15));
      color clr = InpHUDColor;
      if(i == 0) clr = clrGold;
      if(i == 1) clr = htf_up ? clrSpringGreen : (htf_dn ? clrTomato : clrYellow);
      if(i == 2) clr = (m15_up || m15_dn) ? clrGold : clrLightSlateGray;
      if(i == 3) clr = (StringFind(waveStatus, "BULL") >= 0) ? clrSpringGreen : ((StringFind(waveStatus, "BEAR") >= 0) ? clrTomato : clrCyan);
      ObjectSetString(0, lblName, OBJPROP_TEXT, lines[i]);
      ObjectSetInteger(0, lblName, OBJPROP_COLOR, clr);
   }
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   if(rates_total < InpPivotLookback + 200) return(0);

   ArraySetAsSeries(time, true);
   ArraySetAsSeries(open, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(BufferDh, true);
   ArraySetAsSeries(BufferDc, true);
   ArraySetAsSeries(BufferDl, true);
   ArraySetAsSeries(BufferE89, true);
   ArraySetAsSeries(BufferE200, true);
   ArraySetAsSeries(BufferSwingHi, true);
   ArraySetAsSeries(BufferSwingLo, true);
   ArraySetAsSeries(BufferRoundHi, true);
   ArraySetAsSeries(BufferRoundLo, true);
   ArraySetAsSeries(BufferSignalBuy, true);
   ArraySetAsSeries(BufferSignalSell, true);

   double dh[], dc[], dl[], e89[], e200[], atr[];
   ArraySetAsSeries(dh, true);
   ArraySetAsSeries(dc, true);
   ArraySetAsSeries(dl, true);
   ArraySetAsSeries(e89, true);
   ArraySetAsSeries(e200, true);
   ArraySetAsSeries(atr, true);

   if(CopyBuffer(handleEma34High, 0, 0, rates_total, dh) <= 0) return(0);
   if(CopyBuffer(handleEma34Close, 0, 0, rates_total, dc) <= 0) return(0);
   if(CopyBuffer(handleEma34Low, 0, 0, rates_total, dl) <= 0) return(0);
   if(CopyBuffer(handleEma89, 0, 0, rates_total, e89) <= 0) return(0);
   if(CopyBuffer(handleEma200, 0, 0, rates_total, e200) <= 0) return(0);
   if(CopyBuffer(handleAtr14, 0, 0, rates_total, atr) <= 0) return(0);

   int limit = rates_total - prev_calculated + 10;
   if(limit > rates_total - 1) limit = rates_total - 1;

   // 1. Calculate Multi-Timeframe Trend Pulse Confluence
   double r4 = 0, e4 = 0, w4 = 0, s4 = 0;
   double r1 = 0, e1 = 0, w1 = 0, s1 = 0;
   double r15 = 0, e15 = 0, w15 = 0, s15 = 0;

   bool ok4  = GetHtfPulse(PERIOD_H4, r4, e4, w4, s4);
   bool ok1  = GetHtfPulse(PERIOD_H1, r1, e1, w1, s1);
   bool ok15 = GetHtfPulse(PERIOD_M15, r15, e15, w15, s15);

   bool h4_up = ok4 && (r4 > e4 && e4 > w4) && ((r4 - w4) >= InpTangleSpread) && (s4 >= InpMinSlope);
   bool h4_dn = ok4 && (r4 < e4 && e4 < w4) && ((w4 - r4) >= InpTangleSpread) && (s4 <= -InpMinSlope);

   bool h1_up = ok1 && (r1 > e1 && e1 > w1) && ((r1 - w1) >= InpTangleSpread) && (s1 >= InpMinSlope);
   bool h1_dn = ok1 && (r1 < e1 && e1 < w1) && ((w1 - r1) >= InpTangleSpread) && (s1 <= -InpMinSlope);

   bool htf_up = InpStrictHtf ? (h4_up && h1_up) : h4_up;
   bool htf_dn = InpStrictHtf ? (h4_dn && h1_dn) : h4_dn;

   bool m15_up = ok15 && (r15 >= 40.0 && r15 <= 50.0) && (MathAbs(r15 - w15) <= InpW45Tolerance);
   bool m15_dn = ok15 && (r15 >= 50.0 && r15 <= 60.0) && (MathAbs(r15 - w15) <= InpW45Tolerance);

   // 2. Main Loop for M5 Indicators and Execution
   string waveStr = "SEARCHING WAVE";

   for(int i = limit; i >= 0; i--)
   {
      BufferDh[i]   = dh[i];
      BufferDc[i]   = dc[i];
      BufferDl[i]   = dl[i];
      BufferE89[i]  = e89[i];
      BufferE200[i] = e200[i];

      // Round Number Levels ($10 Gold Step)
      double cVal = close[i];
      BufferRoundHi[i] = MathCeil(cVal / InpRoundStep) * InpRoundStep;
      BufferRoundLo[i] = MathFloor(cVal / InpRoundStep) * InpRoundStep;

      BufferSignalBuy[i]  = EMPTY_VALUE;
      BufferSignalSell[i] = EMPTY_VALUE;

      // Track M5 Pivot Highs & Lows
      int kh = 0, kl = 0, kh_o = 0, kl_o = 0, k_hl = 0, k_lh = 0;
      int tch_u = 0, tch_d = 0;
      bool inv_u = false, inv_d = false;
      int rph = 0, rpl = 0;

      for(int k = 1; k <= InpPivotLookback; k++)
      {
         int barIdx = i + k;
         if(barIdx < 2 || barIdx + 2 >= rates_total) continue;

         bool is_ph = (high[barIdx] > high[barIdx + 1] && high[barIdx] > high[barIdx + 2] &&
                       high[barIdx] > high[barIdx - 1] && high[barIdx] > high[barIdx - 2]);
         bool is_pl = (low[barIdx] < low[barIdx + 1] && low[barIdx] < low[barIdx + 2] &&
                       low[barIdx] < low[barIdx - 1] && low[barIdx] < low[barIdx - 2]);

         if(is_ph && rph == 0) rph = barIdx;
         if(is_pl && rpl == 0) rpl = barIdx;

         // Bull Wave Tracking
         if(kh == 0 && k >= 3 && is_ph && high[k] > dh[k] && (close[k] > dh[k] || close[k + 1] > dh[k + 1]))
         {
            kh = k;
         }
         else if(kh == 0)
         {
            if(low[k] <= low[k_hl]) k_hl = k;
            if(low[k] <= dh[k] && tch_u == 0) tch_u = k;
            inv_u = inv_u || (close[k] < e89[k]);
         }
         else if(kl_o == 0 && is_pl)
         {
            kl_o = k;
         }

         // Bear Wave Tracking
         if(kl == 0 && k >= 3 && is_pl && low[k] < dl[k] && (close[k] < dl[k] || close[k + 1] < dl[k + 1]))
         {
            kl = k;
         }
         else if(kl == 0)
         {
            if(high[k] >= high[k_lh]) k_lh = k;
            if(high[k] >= dl[k] && tch_d == 0) tch_d = k;
            inv_d = inv_d || (close[k] > e89[k]);
         }
         else if(kh_o == 0 && is_ph)
         {
            kh_o = k;
         }
      }

      BufferSwingHi[i] = (rph > 2) ? high[rph] : EMPTY_VALUE;
      BufferSwingLo[i] = (rpl > 2) ? low[rpl]  : EMPTY_VALUE;

      if(i == 0 && rates_total >= InpPivotLookback + 8)
      {
         double ph = (kh > 0) ? high[kh] : EMPTY_VALUE;
         double pl = (kl > 0) ? low[kl]  : EMPTY_VALUE;

         bool w_up = (kl_o > kh && kh > k_hl && k_hl >= 2 && 2 <= tch_u && tch_u < kh && !inv_u && low[1] >= low[k_hl] && low[k_hl] > low[kl_o]);
         bool w_dn = (kh_o > kl && kl > k_lh && k_lh >= 2 && 2 <= tch_d && tch_d < kl && !inv_d && high[1] <= high[k_lh] && high[k_lh] < high[kh_o]);

         if(w_up) waveStr = "BULL WAVE (L-H-HL)";
         if(w_dn) waveStr = "BEAR WAVE (H-L-LH)";

         bool ev_up = (InpTriggerMode == 0) ? (close[1] > dh[1] && close[1] > open[1] && (close[2] <= dh[2] || low[2] <= dh[2])) : (close[1] > ph && close[2] <= ph);
         bool ev_dn = (InpTriggerMode == 0) ? (close[1] < dl[1] && close[1] < open[1] && (close[2] >= dl[2] || high[2] >= dl[2])) : (close[1] < pl && close[2] >= pl);

         bool cyc_u = (rates_total - kh > lock_u_bar) && (lock_ph == EMPTY_VALUE || ph >= lock_ph);
         bool cyc_d = (rates_total - kl > lock_d_bar) && (lock_pl == EMPTY_VALUE || pl <= lock_pl);

         bool fire_up = htf_up && m15_up && cyc_u && dc[1] > e89[1] && dc[1] > dc[2] && (!InpRequireEma200 || close[1] > e200[1]) && w_up && ev_up;
         bool fire_dn = htf_dn && m15_dn && cyc_d && dc[1] < e89[1] && dc[1] < dc[2] && (!InpRequireEma200 || close[1] < e200[1]) && w_dn && ev_dn;

         if(fire_up)
         {
            BufferSignalBuy[1] = low[1] - (atr[1] * 0.25);
            lock_u_bar         = rates_total;
            lock_ph            = ph;

            if(time[0] != lastAlertTime)
            {
               lastAlertTime = time[0];
               string msg = StringFormat("[Sonic R] XAUUSD M5 Bullish Setup Confirmed @ %s (Price: %.2f)", TimeToString(time[1]), close[1]);
               if(!MQLInfoInteger(MQL_TESTER) && InpEnablePopup) Alert(msg);
               if(InpEnableSound) PlaySound("alert.wav");
               if(InpEnablePush)  SendNotification(msg);
               if(InpEnableEmail) SendMail("Sonic R Alert", msg);
            }
         }

         if(fire_dn)
         {
            BufferSignalSell[1] = high[1] + (atr[1] * 0.25);
            lock_d_bar          = rates_total;
            lock_pl             = pl;

            if(time[0] != lastAlertTime)
            {
               lastAlertTime = time[0];
               string msg = StringFormat("[Sonic R] XAUUSD M5 Bearish Setup Confirmed @ %s (Price: %.2f)", TimeToString(time[1]), close[1]);
               if(!MQLInfoInteger(MQL_TESTER) && InpEnablePopup) Alert(msg);
               if(InpEnableSound) PlaySound("alert.wav");
               if(InpEnablePush)  SendNotification(msg);
               if(InpEnableEmail) SendMail("Sonic R Alert", msg);
            }
         }
      }
   }

   double distDragon = (dc[0] > 0) ? (close[0] - dc[0]) : 0.0;
   RenderHUD(htf_up, htf_dn, m15_up, m15_dn, distDragon, waveStr);

   return(rates_total);
}
//+------------------------------------------------------------------+
