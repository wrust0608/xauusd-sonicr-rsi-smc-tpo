//+------------------------------------------------------------------+
//|                                         RSI_Trend_Pulse_Pane.mq5 |
//|                                  Copyright 2026, Antigravity AI |
//|                       XAUUSD Quantitative Visualizer - Unleashed |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "2.55"
#property description "XAUUSD MTF RSI Trend Pulse Suite: RSI 14, EMA 9, WMA 45, Clean Pane HUD, Divergence Lines & MTF Zones"
#property indicator_separate_window
#property indicator_buffers 7
#property indicator_plots   7

//--- Set Levels
#property indicator_level1 30.0
#property indicator_level2 40.0
#property indicator_level3 50.0
#property indicator_level4 60.0
#property indicator_level5 70.0
#property indicator_levelcolor clrDimGray
#property indicator_levelstyle STYLE_DOT

//--- Plot 1: RSI 14
#property indicator_label1  "RSI 14"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrWhite
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//--- Plot 2: EMA 9 (on RSI)
#property indicator_label2  "EMA 9 (on RSI)"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrCyan
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

//--- Plot 3: WMA 45 (on RSI)
#property indicator_label3  "WMA 45 (on RSI)"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrange
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2

//--- Plot 4: HTF Bull + M15 Wait Zone (45)
#property indicator_label4  "HTF Bull (45)"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrSpringGreen
#property indicator_style4  STYLE_SOLID
#property indicator_width4  2

//--- Plot 5: HTF Bear + M15 Wait Zone (55)
#property indicator_label5  "HTF Bear (55)"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrRed
#property indicator_style5  STYLE_SOLID
#property indicator_width5  2

//--- Plot 6: M5 Bull Momentum Confirm
#property indicator_label6  "Bull Momentum"
#property indicator_type6   DRAW_ARROW
#property indicator_color6  clrSpringGreen
#property indicator_width6  2

//--- Plot 7: M5 Bear Momentum Confirm
#property indicator_label7  "Bear Momentum"
#property indicator_type7   DRAW_ARROW
#property indicator_color7  clrRed
#property indicator_width7  2

//--- Input Parameters
input group "=== 1. MTF Trend Pulse Confluence Settings ==="
input bool     InpStrictHtf      = false;       // Strict H4 & H1 Full Alignment
input double   InpMinSlope       = 0.05;        // Min H4/H1 WMA45 Slope
input double   InpTangleSpread   = 2.5;         // Min H4/H1 3-Line Spread (No Tangle)
input double   InpW45Tolerance   = 2.0;         // M15 WMA45 Touch Tolerance

input group "=== 2. M5 Momentum Divergence Settings ==="
input int      InpPivotLookback  = 24;          // M5 Pivot Max Lookback (6-50)
input double   InpDoubleTol      = 3.0;         // M5 Double Bottom/Top Tolerance
input double   InpDoubleProm     = 4.0;         // M5 Double Bottom/Top Prominence
input bool     InpDrawDivLines   = true;        // Draw Divergence Lines on RSI Pane

input group "=== 3. Visual Dashboard Settings ==="
input bool     InpShowHUD        = true;        // Show MTF Status Dashboard on Pane
input int      InpHUDCorner      = 0;           // HUD Corner (0 = Top Left, 1 = Top Right)
input color    InpHUDColor       = clrWhite;    // HUD Text Color

input group "=== 4. Multi-Channel Alert Settings ==="
input bool     InpEnablePopup    = true;        // Enable Pop-up Alert
input bool     InpEnableSound    = true;        // Enable Sound Alert
input bool     InpEnablePush     = false;       // Enable Push Notification (Phone)
input bool     InpEnableEmail    = false;       // Enable Email Alert

//--- Indicator Buffers
double BufferRsi[];
double BufferEma9[];
double BufferWma45[];
double BufferContextBull[];
double BufferContextBear[];
double BufferSignalBuy[];
double BufferSignalSell[];

int    handleRsi;
bool   latch_up;
bool   latch_dn;
int    lock_u_bar;
int    lock_d_bar;
datetime lastAlertTime;
string prefix;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, BufferRsi,         INDICATOR_DATA);
   SetIndexBuffer(1, BufferEma9,        INDICATOR_DATA);
   SetIndexBuffer(2, BufferWma45,       INDICATOR_DATA);
   SetIndexBuffer(3, BufferContextBull, INDICATOR_DATA);
   SetIndexBuffer(4, BufferContextBear, INDICATOR_DATA);
   SetIndexBuffer(5, BufferSignalBuy,   INDICATOR_DATA);
   SetIndexBuffer(6, BufferSignalSell,  INDICATOR_DATA);

   PlotIndexSetInteger(5, PLOT_ARROW, 233); // Wingdings Up Arrow
   PlotIndexSetInteger(6, PLOT_ARROW, 234); // Wingdings Down Arrow

   // Hide internal / trigger buffers from subwindow header
   PlotIndexSetInteger(3, PLOT_SHOW_DATA, false);
   PlotIndexSetInteger(4, PLOT_SHOW_DATA, false);
   PlotIndexSetInteger(5, PLOT_SHOW_DATA, false);
   PlotIndexSetInteger(6, PLOT_SHOW_DATA, false);

   for(int i = 0; i < 7; i++)
   {
      PlotIndexSetDouble(i, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   }

   handleRsi = iRSI(_Symbol, _Period, 14, PRICE_CLOSE);
   if(handleRsi == INVALID_HANDLE)
   {
      Print("Failed to create RSI handle");
      return(INIT_FAILED);
   }

   latch_up      = false;
   latch_dn      = false;
   lock_u_bar    = -1;
   lock_d_bar    = -1;
   lastAlertTime = 0;
   prefix        = "RSI_PULSE_";

   IndicatorSetString(INDICATOR_SHORTNAME, "RSI Trend Pulse MTF Unleashed (" + _Symbol + ")");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   IndicatorRelease(handleRsi);
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
   int copied = CopyRates(_Symbol, tf, 1, requiredBars, rates);
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
//| Helper: Draw Divergence Trendline on Subwindow                   |
//+------------------------------------------------------------------+
void DrawDivLine(string name, datetime t1, double p1, datetime t2, double p2, color clr)
{
   if(!InpDrawDivLines) return;

   int subwindow = ChartWindowFind(0, "RSI Trend Pulse MTF Unleashed (" + _Symbol + ")");
   if(subwindow < 0) subwindow = 1;

   string objName = prefix + name;
   if(ObjectFind(0, objName) < 0)
   {
      ObjectCreate(0, objName, OBJ_TREND, subwindow, t1, p1, t2, p2);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, objName, OBJPROP_RAY_RIGHT, false);
   }
}

//+------------------------------------------------------------------+
//| Helper: Render Subwindow Status HUD - Compact Dark Badge         |
//+------------------------------------------------------------------+
void RenderPaneHUD(bool b4_up, bool b4_dn, double sp4, double sl4,
                   bool b1_up, bool b1_dn, double sp1, double sl1,
                   bool m15_up, bool m15_dn, double r15, double w15)
{
   if(!InpShowHUD) return;

   int subwindow = ChartWindowFind(0, "RSI Trend Pulse MTF Unleashed (" + _Symbol + ")");
   if(subwindow < 0) subwindow = 1;

   int bgX = 10;
   int bgY = 24;
   int bgW = 260;
   int bgH = 56;

   string bgName = prefix + "Pane_BG";
   if(ObjectFind(0, bgName) < 0)
   {
      ObjectCreate(0, bgName, OBJ_RECTANGLE_LABEL, subwindow, 0, 0);
      ObjectSetInteger(0, bgName, OBJPROP_BGCOLOR, C'15,18,24');
      ObjectSetInteger(0, bgName, OBJPROP_BORDER_COLOR, C'45,55,72');
      ObjectSetInteger(0, bgName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, bgName, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, bgName, OBJPROP_CORNER, InpHUDCorner);
   ObjectSetInteger(0, bgName, OBJPROP_XDISTANCE, bgX);
   ObjectSetInteger(0, bgName, OBJPROP_YDISTANCE, bgY);
   ObjectSetInteger(0, bgName, OBJPROP_XSIZE, bgW);
   ObjectSetInteger(0, bgName, OBJPROP_YSIZE, bgH);

   string lines[3];
   lines[0] = StringFormat("H4: %s (Sp:%.1f) | H1: %s (Sp:%.1f)", b4_up ? "BULL" : (b4_dn ? "BEAR" : "CHOP"), sp4, b1_up ? "BULL" : (b1_dn ? "BEAR" : "CHOP"), sp1);
   lines[1] = StringFormat("M15: %s [RSI: %.1f | WMA: %.1f]", m15_up ? "WAIT BUY (40-50)" : (m15_dn ? "WAIT SELL (50-60)" : "OUTSIDE"), r15, w15);
   lines[2] = StringFormat("M5 State: LatchUp=%s | LatchDn=%s", latch_up ? "ON" : "OFF", latch_dn ? "ON" : "OFF");

   int startY = bgY + 4;
   for(int i = 0; i < 3; i++)
   {
      string lblName = prefix + "HUD_" + IntegerToString(i);
      if(ObjectFind(0, lblName) < 0)
      {
         ObjectCreate(0, lblName, OBJ_LABEL, subwindow, 0, 0);
         ObjectSetString(0, lblName, OBJPROP_FONT, "Segoe UI Semibold");
         ObjectSetInteger(0, lblName, OBJPROP_FONTSIZE, 8);
         ObjectSetInteger(0, lblName, OBJPROP_BACK, false);
      }
      ObjectSetInteger(0, lblName, OBJPROP_CORNER, InpHUDCorner);
      ObjectSetInteger(0, lblName, OBJPROP_XDISTANCE, bgX + 8);
      ObjectSetInteger(0, lblName, OBJPROP_YDISTANCE, startY + (i * 15));

      color clr = InpHUDColor;
      if(i == 0) clr = (b4_up && b1_up) ? clrSpringGreen : ((b4_dn && b1_dn) ? clrTomato : clrYellow);
      if(i == 1) clr = (m15_up || m15_dn) ? clrGold : clrLightSlateGray;
      if(i == 2) clr = (latch_up || latch_dn) ? clrCyan : clrWhite;
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
   if(rates_total < InpPivotLookback + 60) return(0);

   ArraySetAsSeries(time, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(BufferRsi, true);
   ArraySetAsSeries(BufferEma9, true);
   ArraySetAsSeries(BufferWma45, true);
   ArraySetAsSeries(BufferContextBull, true);
   ArraySetAsSeries(BufferContextBear, true);
   ArraySetAsSeries(BufferSignalBuy, true);
   ArraySetAsSeries(BufferSignalSell, true);

   double fullRsi[];
   ArraySetAsSeries(fullRsi, true);
   int rsiCopied = CopyBuffer(handleRsi, 0, 0, rates_total, fullRsi);
   if(rsiCopied <= 0) return(0);

   int maxAvailable = MathMin(rates_total, rsiCopied);
   if(maxAvailable <= InpPivotLookback + 50) return(0);

   double r4 = 0, e4 = 0, w4 = 0, s4 = 0;
   double r1 = 0, e1 = 0, w1 = 0, s1 = 0;
   double r15 = 0, e15 = 0, w15 = 0, s15 = 0;

   bool htf_ok = GetHtfPulse(PERIOD_H4, r4, e4, w4, s4) &&
                 GetHtfPulse(PERIOD_H1, r1, e1, w1, s1) &&
                 GetHtfPulse(PERIOD_M15, r15, e15, w15, s15);

   double sp4 = MathMax(r4, MathMax(e4, w4)) - MathMin(r4, MathMin(e4, w4));
   double sp1 = MathMax(r1, MathMax(e1, w1)) - MathMin(r1, MathMin(e1, w1));

   bool b4_up = htf_ok && (r4 > w4 && e4 > w4 && s4 >= InpMinSlope && sp4 >= InpTangleSpread);
   bool b4_dn = htf_ok && (r4 < w4 && e4 < w4 && s4 <= -InpMinSlope && sp4 >= InpTangleSpread);

   bool b1_up = htf_ok && ((InpStrictHtf ? (r1 > w1) : true) && e1 >= w1 && s1 >= InpMinSlope && sp1 >= InpTangleSpread);
   bool b1_dn = htf_ok && ((InpStrictHtf ? (r1 < w1) : true) && e1 <= w1 && s1 <= -InpMinSlope && sp1 >= InpTangleSpread);

   bool m15_up = htf_ok && (((40.0 <= r15 && r15 <= 50.0) || MathAbs(r15 - w15) <= InpW45Tolerance) && (38.0 <= r15 && r15 < 70.0));
   bool m15_dn = htf_ok && (((50.0 <= r15 && r15 <= 60.0) || MathAbs(r15 - w15) <= InpW45Tolerance) && (30.0 < r15 && r15 <= 62.0));

   double wSum = 45.0 * 46.0 / 2.0;
   double k_ema = 2.0 / (9.0 + 1.0);

   int limit = (prev_calculated == 0) ? (maxAvailable - 1) : (rates_total - prev_calculated + 2);
   if(limit >= maxAvailable) limit = maxAvailable - 1;
   if(limit < 0) limit = 0;

   for(int i = limit; i >= 0; i--)
   {
      BufferRsi[i] = fullRsi[i];

      if(i + 45 < maxAvailable)
      {
         double num = 0.0;
         for(int j = 0; j < 45; j++)
         {
            num += fullRsi[i + j] * (45 - j);
         }
         BufferWma45[i] = num / wSum;
      }
      else
      {
         BufferWma45[i] = EMPTY_VALUE;
      }

      BufferContextBull[i] = (b4_up && b1_up && m15_up) ? 45.0 : EMPTY_VALUE;
      BufferContextBear[i] = (b4_dn && b1_dn && m15_dn) ? 55.0 : EMPTY_VALUE;

      BufferSignalBuy[i]  = EMPTY_VALUE;
      BufferSignalSell[i] = EMPTY_VALUE;
   }

   int emaStart = (prev_calculated == 0) ? (maxAvailable - 20) : limit;
   if(emaStart >= maxAvailable) emaStart = maxAvailable - 1;
   for(int i = emaStart; i >= 0; i--)
   {
      if(i >= maxAvailable - 20 || i + 1 >= maxAvailable)
      {
         BufferEma9[i] = BufferRsi[i];
      }
      else
      {
         BufferEma9[i] = BufferRsi[i] * k_ema + BufferEma9[i + 1] * (1.0 - k_ema);
      }
   }

   if((b4_dn && b1_dn) || (r15 >= 55.0 && BufferRsi[1] >= 60.0) || r15 < 35.0) latch_up = false;
   if((b4_up && b1_up) || (r15 <= 45.0 && BufferRsi[1] <= 40.0) || r15 > 65.0) latch_dn = false;

   int kl2_r = 0, kl1_r = 0, kh2_r = 0, kh1_r = 0;
   double mid_hi = -1.0, mid_lo = 101.0;
   bool used_l = false, used_h = false;

   for(int k = 2; k < InpPivotLookback + 8 && (k + 2) < maxAvailable; k++)
   {
      bool r_pl = BufferRsi[k] < BufferRsi[k - 1] && BufferRsi[k] <= BufferRsi[k + 1] && BufferRsi[k] < BufferRsi[k + 2];
      if(kl2_r == 0)
      {
         if(r_pl && k <= 7 && !used_l) kl2_r = k;
         if(BufferRsi[k] > BufferEma9[k] && BufferRsi[k + 1] <= BufferEma9[k + 1]) used_l = true;
      }
      else if(kl1_r == 0)
      {
         if(r_pl) kl1_r = k;
         else     mid_hi = MathMax(mid_hi, BufferRsi[k]);
      }

      bool r_ph = BufferRsi[k] > BufferRsi[k - 1] && BufferRsi[k] >= BufferRsi[k + 1] && BufferRsi[k] > BufferRsi[k + 2];
      if(kh2_r == 0)
      {
         if(r_ph && k <= 7 && !used_h) kh2_r = k;
         if(BufferRsi[k] < BufferEma9[k] && BufferRsi[k + 1] >= BufferEma9[k + 1]) used_h = true;
      }
      else if(kh1_r == 0)
      {
         if(r_ph) kh1_r = k;
         else     mid_lo = MathMin(mid_lo, BufferRsi[k]);
      }
   }

   bool v_lo = kl1_r > 0 && 3 <= (kl1_r - kl2_r) && (kl1_r - kl2_r) <= InpPivotLookback && BufferRsi[1] >= BufferRsi[kl2_r];
   bool v_hi = kh1_r > 0 && 3 <= (kh1_r - kh2_r) && (kh1_r - kh2_r) <= InpPivotLookback && BufferRsi[1] <= BufferRsi[kh2_r];

   bool isRegBull = (v_lo && MathMin(low[kl2_r], low[kl2_r + 1]) < MathMin(low[kl1_r], low[kl1_r + 1]) && BufferRsi[kl2_r] > BufferRsi[kl1_r]);
   bool isHidBull = (v_lo && MathMin(low[kl2_r], low[kl2_r + 1]) > MathMin(low[kl1_r], low[kl1_r + 1]) && BufferRsi[kl2_r] < BufferRsi[kl1_r]);
   bool isDbBull  = (v_lo && MathAbs(BufferRsi[kl2_r] - BufferRsi[kl1_r]) <= InpDoubleTol && (mid_hi - MathMax(BufferRsi[kl2_r], BufferRsi[kl1_r])) >= InpDoubleProm);

   bool m5_bull = (isRegBull || isHidBull || isDbBull) && BufferRsi[1] > BufferEma9[1] && BufferRsi[2] <= BufferEma9[2];

   bool isRegBear = (v_hi && MathMax(high[kh2_r], high[kh2_r + 1]) > MathMax(high[kh1_r], high[kh1_r + 1]) && BufferRsi[kh2_r] < BufferRsi[kh1_r]);
   bool isHidBear = (v_hi && MathMax(high[kh2_r], high[kh2_r + 1]) < MathMax(high[kh1_r], high[kh1_r + 1]) && BufferRsi[kh2_r] > BufferRsi[kh1_r]);
   bool isDbBear  = (v_hi && MathAbs(BufferRsi[kh2_r] - BufferRsi[kh1_r]) <= InpDoubleTol && (MathMin(BufferRsi[kh2_r], BufferRsi[kh1_r]) - mid_lo) >= InpDoubleProm);

   bool m5_bear = (isRegBear || isHidBear || isDbBear) && BufferRsi[1] < BufferEma9[1] && BufferRsi[2] >= BufferEma9[2];

   bool fire_u = (!latch_up) && (rates_total - kl2_r > lock_u_bar) && m5_bull;
   bool fire_d = (!latch_dn) && (rates_total - kh2_r > lock_d_bar) && m5_bear;

   if(fire_u)
   {
      BufferSignalBuy[1] = BufferRsi[1];
      latch_up           = true;
      lock_u_bar         = rates_total;

      if(kl1_r > 0 && kl2_r > 0)
      {
         string divName = StringFormat("Div_Bull_%s", TimeToString(time[kl2_r]));
         DrawDivLine(divName, time[kl1_r], BufferRsi[kl1_r], time[kl2_r], BufferRsi[kl2_r], clrSpringGreen);
      }

      if(time[0] != lastAlertTime)
      {
         lastAlertTime = time[0];
         string typeStr = isRegBull ? "Regular Bullish Divergence" : (isHidBull ? "Hidden Bullish Divergence" : "RSI Double Bottom");
         string msg = StringFormat("[RSI Pulse] XAUUSD M5 Momentum Confirmed: %s @ %s", typeStr, TimeToString(time[1]));
         if(!MQLInfoInteger(MQL_TESTER) && InpEnablePopup) Alert(msg);
         if(InpEnableSound) PlaySound("alert.wav");
         if(InpEnablePush)  SendNotification(msg);
         if(InpEnableEmail) SendMail("RSI Trend Pulse Alert", msg);
      }
   }

   if(fire_d)
   {
      BufferSignalSell[1] = BufferRsi[1];
      latch_dn            = true;
      lock_d_bar          = rates_total;

      if(kh1_r > 0 && kh2_r > 0)
      {
         string divName = StringFormat("Div_Bear_%s", TimeToString(time[kh2_r]));
         DrawDivLine(divName, time[kh1_r], BufferRsi[kh1_r], time[kh2_r], BufferRsi[kh2_r], clrRed);
      }

      if(time[0] != lastAlertTime)
      {
         lastAlertTime = time[0];
         string typeStr = isRegBear ? "Regular Bearish Divergence" : (isHidBear ? "Hidden Bearish Divergence" : "RSI Double Top");
         string msg = StringFormat("[RSI Pulse] XAUUSD M5 Momentum Confirmed: %s @ %s", typeStr, TimeToString(time[1]));
         if(!MQLInfoInteger(MQL_TESTER) && InpEnablePopup) Alert(msg);
         if(InpEnableSound) PlaySound("alert.wav");
         if(InpEnablePush)  SendNotification(msg);
         if(InpEnableEmail) SendMail("RSI Trend Pulse Alert", msg);
      }
   }

   RenderPaneHUD(b4_up, b4_dn, sp4, s4, b1_up, b1_dn, sp1, s1, m15_up, m15_dn, r15, w15);

   return(rates_total);
}
//+------------------------------------------------------------------+
