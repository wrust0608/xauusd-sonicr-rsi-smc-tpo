//+------------------------------------------------------------------+
//|                                 SMC_MarketStructure_Overlay.mq5 |
//|                                  Copyright 2026, Antigravity AI |
//|                       XAUUSD Quantitative Visualizer - Unleashed |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "2.55"
#property description "XAUUSD Smart Money Concepts Suite: Major & Internal Structure (BOS/CHoCH), Order Blocks, FVGs, EQH/EQL, Liquidity Sweeps, Premium/Discount & Clean HUD"
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4

//--- Plot 1: Major Swing High
#property indicator_label1  "Major Swing High"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrTomato
#property indicator_width1  2

//--- Plot 2: Major Swing Low
#property indicator_label2  "Major Swing Low"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrMediumSeaGreen
#property indicator_width2  2

//--- Plot 3: Internal Swing High
#property indicator_label3  "Internal Swing High"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrOrangeRed
#property indicator_width3  1

//--- Plot 4: Internal Swing Low
#property indicator_label4  "Internal Swing Low"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrLimeGreen
#property indicator_width4  1

//--- Input Parameters
input group "=== 1. Major Swing Structure Settings ==="
input bool     InpShowSwingDots    = false;         // Show Swing High/Low Arrow Dots on Candles
input bool     InpDrawDealingBoxes = false;         // Draw Giant Premium/Discount Bounding Boxes
input int      InpMajorLookback    = 8;             // Major Swing Lookback (bars left/right)
input int      InpMaxHistoryBars   = 1200;          // Max History Bars to Analyze
input bool     InpShowMajorBOS     = true;          // Show Major BOS (Break of Structure)
input bool     InpShowMajorCHoCH   = true;          // Show Major CHoCH (Change of Character)
input color    InpBullBOSColor     = clrSpringGreen;// Bullish BOS Color
input color    InpBearBOSColor     = clrCrimson;    // Bearish BOS Color
input color    InpCHoCHColor       = clrGold;       // CHoCH Color

input group "=== 2. Internal Structure Settings ==="
input bool     InpShowInternal     = true;          // Show Internal Structure
input int      InpMinorLookback    = 3;             // Internal Swing Lookback
input bool     InpShowInternalBOS  = true;          // Show Internal BOS (iBOS)
input bool     InpShowInternalCHoCH= true;          // Show Internal CHoCH (iCHoCH)

input group "=== 3. Liquidity Pools (EQH / EQL) & Sweeps ==="
input bool     InpShowLiquidity    = true;          // Show EQH / EQL Liquidity Pools
input double   InpEQHTolerance     = 2.0;           // EQH/EQL Tolerance in Points ($0.20 on Gold)
input color    InpLiquidityColor   = clrDeepSkyBlue;// Liquidity Pool ($$$) Color
input bool     InpShowSweeps       = true;          // Show Liquidity Sweeps / SFP (Swing Failure)
input color    InpBullSweepColor   = clrAqua;       // Bullish Sweep Color
input color    InpBearSweepColor   = clrMagenta;    // Bearish Sweep Color

input group "=== 4. Order Blocks (OB) Settings ==="
input bool     InpShowOB           = true;          // Show Order Blocks
input color    InpBullOBColor      = clrDarkSeaGreen;// Bullish OB Color
input color    InpBearOBColor      = clrIndianRed;   // Bearish OB Color
input int      InpMaxActiveOB      = 8;             // Max Active OBs on Chart

input group "=== 5. Fair Value Gaps (FVG) Settings ==="
input bool     InpShowFVG          = true;          // Show Fair Value Gaps (FVG)
input color    InpBullFVGColor     = C'35,55,35';    // Bullish FVG Fill Color (Subtle Dark)
input color    InpBearFVGColor     = C'55,35,35';    // Bearish FVG Fill Color (Subtle Dark)
input double   InpMinFVGPips       = 3.0;           // Min FVG Gap Size (Points/Pips)

input group "=== 6. Premium / Discount & Equilibrium ==="
input bool     InpShowPremDisc     = true;          // Show Premium / Discount Range
input color    InpPremiumColor     = clrIndianRed;  // Premium Zone Border Color
input color    InpDiscountColor    = clrDarkSeaGreen;// Discount Zone Border Color
input color    InpEquilibriumColor = clrSilver;     // 50% Equilibrium Line Color

input group "=== 7. Visual HUD Dashboard ==="
input bool     InpShowHUD          = true;          // Show SMC Status Dashboard
input int      InpHUDCorner        = 0;             // HUD Corner (0 = Top-Left, 1 = Top-Right)
input color    InpHUDColor         = clrWhite;      // HUD Text Color

input group "=== 8. Multi-Channel Alert Settings ==="
input bool     InpEnablePopup      = false;          // Enable Pop-up Alerts
input bool     InpEnableSound      = true;          // Enable Sound Alerts
input bool     InpEnablePush       = false;         // Enable Push Notification (Phone)
input bool     InpEnableEmail      = false;         // Enable Email Alerts

//--- Indicator Buffers
double BufferMajorHi[];
double BufferMajorLo[];
double BufferMinorHi[];
double BufferMinorLo[];

//--- Global Variables
string prefix;
datetime lastAlertTime = 0;
datetime lastSweepBullTime = 0;
datetime lastSweepBearTime = 0;
string g_lastStructureEvent = "None";
int    g_activeBullOBCount = 0;
int    g_activeBearOBCount = 0;
int    g_activeBullFVGCount = 0;
int    g_activeBearFVGCount = 0;
double g_currentEqPrice = 0.0;
string g_currentZone = "Equilibrium";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, BufferMajorHi, INDICATOR_DATA);
   SetIndexBuffer(1, BufferMajorLo, INDICATOR_DATA);
   SetIndexBuffer(2, BufferMinorHi, INDICATOR_DATA);
   SetIndexBuffer(3, BufferMinorLo, INDICATOR_DATA);

   ArrayInitialize(BufferMajorHi, EMPTY_VALUE);
   ArrayInitialize(BufferMajorLo, EMPTY_VALUE);
   ArrayInitialize(BufferMinorHi, EMPTY_VALUE);
   ArrayInitialize(BufferMinorLo, EMPTY_VALUE);

   if(!InpShowSwingDots)
   {
      PlotIndexSetInteger(0, PLOT_DRAW_TYPE, DRAW_NONE);
      PlotIndexSetInteger(1, PLOT_DRAW_TYPE, DRAW_NONE);
      PlotIndexSetInteger(2, PLOT_DRAW_TYPE, DRAW_NONE);
      PlotIndexSetInteger(3, PLOT_DRAW_TYPE, DRAW_NONE);
   }
   else
   {
      PlotIndexSetInteger(0, PLOT_ARROW, 159);
      PlotIndexSetInteger(1, PLOT_ARROW, 159);
      PlotIndexSetInteger(2, PLOT_DRAW_TYPE, DRAW_NONE);
      PlotIndexSetInteger(3, PLOT_DRAW_TYPE, DRAW_NONE);
   }

   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetDouble(3, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   prefix = "SMC_" + _Symbol + "_";
   ObjectsDeleteAll(0, prefix);

   IndicatorSetString(INDICATOR_SHORTNAME, "SMC Unleashed (" + _Symbol + ")");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, prefix);
}

//+------------------------------------------------------------------+
//| Helper: Send Alert                                               |
//+------------------------------------------------------------------+
void TriggerAlert(string text)
{
   if(!MQLInfoInteger(MQL_TESTER) && InpEnablePopup) Alert(text);
   if(InpEnableSound) PlaySound("alert.wav");
   if(InpEnablePush)  SendNotification(text);
   if(InpEnableEmail) SendMail("SMC Market Structure Alert", text);
}

//+------------------------------------------------------------------+
//| Helper: Draw Structure Line (BOS / CHoCH)                        |
//+------------------------------------------------------------------+
void DrawStructureLine(string name, datetime t1, double p1, datetime t2, double p2, color clr, string text)
{
   string objName = prefix + name;
   if(ObjectFind(0, objName) < 0)
   {
      ObjectCreate(0, objName, OBJ_TREND, 0, t1, p1, t2, p2);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DASH);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, objName, OBJPROP_RAY_RIGHT, false);
      ObjectSetInteger(0, objName, OBJPROP_BACK, true);

      // Label at middle
      string lblName = objName + "_lbl";
      datetime midTime = t1 + (datetime)((t2 - t1) / 2);
      ObjectCreate(0, lblName, OBJ_TEXT, 0, midTime, p1);
      ObjectSetString(0, lblName, OBJPROP_TEXT, text);
      ObjectSetInteger(0, lblName, OBJPROP_COLOR, clr);
      ObjectSetString(0, lblName, OBJPROP_FONT, "Segoe UI Semibold");
      ObjectSetInteger(0, lblName, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, lblName, OBJPROP_ANCHOR, ANCHOR_LOWER);
   }
}

//+------------------------------------------------------------------+
//| Helper: Draw Liquidity Pool Line ($$$)                           |
//+------------------------------------------------------------------+
void DrawLiquidityLine(string name, datetime t1, double p, datetime t2, color clr, string label)
{
   string objName = prefix + name;
   if(ObjectFind(0, objName) < 0)
   {
      ObjectCreate(0, objName, OBJ_TREND, 0, t1, p, t2, p);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DOT);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, objName, OBJPROP_RAY_RIGHT, false);

      string lblName = objName + "_lbl";
      ObjectCreate(0, lblName, OBJ_TEXT, 0, t2, p);
      ObjectSetString(0, lblName, OBJPROP_TEXT, label);
      ObjectSetInteger(0, lblName, OBJPROP_COLOR, clr);
      ObjectSetString(0, lblName, OBJPROP_FONT, "Segoe UI");
      ObjectSetInteger(0, lblName, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, lblName, OBJPROP_ANCHOR, ANCHOR_LEFT);
   }
}

//+------------------------------------------------------------------+
//| Helper: Draw Sweep / SFP Label                                   |
//+------------------------------------------------------------------+
void DrawSweepLabel(string name, datetime t, double p, color clr, string label, bool isBull)
{
   string objName = prefix + name;
   if(ObjectFind(0, objName) < 0)
   {
      ObjectCreate(0, objName, OBJ_TEXT, 0, t, p);
      ObjectSetString(0, objName, OBJPROP_TEXT, label);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clr);
      ObjectSetString(0, objName, OBJPROP_FONT, "Segoe UI Bold");
      ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 7);
      ObjectSetInteger(0, objName, OBJPROP_ANCHOR, isBull ? ANCHOR_UPPER : ANCHOR_LOWER);
   }
}

//+------------------------------------------------------------------+
//| Helper: Draw Box (Order Block / FVG / Premium-Discount)          |
//+------------------------------------------------------------------+
void DrawBox(string name, datetime t1, double top, datetime t2, double btm, color clr, bool isFilled)
{
   string objName = prefix + name;
   if(ObjectFind(0, objName) < 0)
   {
      ObjectCreate(0, objName, OBJ_RECTANGLE, 0, t1, top, t2, btm);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, clr);
      ObjectSetInteger(0, objName, OBJPROP_STYLE, isFilled ? STYLE_SOLID : STYLE_DOT);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, objName, OBJPROP_FILL, isFilled);
      ObjectSetInteger(0, objName, OBJPROP_BACK, true);
   }
   else
   {
      ObjectSetInteger(0, objName, OBJPROP_TIME, 1, t2);
   }
}

//+------------------------------------------------------------------+
//| Render HUD Dashboard - Ultra Sleek & Compact (Top-Left)          |
//+------------------------------------------------------------------+
void UpdateHUD(int activeTrend, double currentPrice, double rangeHigh, double rangeLow)
{
   if(!InpShowHUD) return;

   int startX = 15;
   int startY = 36;
   int width  = 210;
   int height = 82;

   string bgName = prefix + "HUD_BG";
   if(ObjectFind(0, bgName) < 0)
   {
      ObjectCreate(0, bgName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, bgName, OBJPROP_BGCOLOR, C'15,18,24');
      ObjectSetInteger(0, bgName, OBJPROP_BORDER_COLOR, C'45,55,72');
      ObjectSetInteger(0, bgName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, bgName, OBJPROP_BACK, false);
   }
   ObjectSetInteger(0, bgName, OBJPROP_CORNER, InpHUDCorner);
   ObjectSetInteger(0, bgName, OBJPROP_XDISTANCE, startX);
   ObjectSetInteger(0, bgName, OBJPROP_YDISTANCE, startY);
   ObjectSetInteger(0, bgName, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, bgName, OBJPROP_YSIZE, height);

   string lines[4];
   lines[0] = "SMC STRUCTURE (M5)";
   lines[1] = StringFormat("Bias: %s", (activeTrend > 0) ? "BULLISH (BOS)" : (activeTrend < 0) ? "BEARISH (BOS)" : "RANGING / NEUTRAL");
   lines[2] = StringFormat("Range: %.1f - %.1f | EQ: %.1f", rangeLow, rangeHigh, g_currentEqPrice);
   lines[3] = StringFormat("Zone: %s | OB: %d/%d | FVG: %d", g_currentZone, g_activeBullOBCount, g_activeBearOBCount, g_activeBullFVGCount + g_activeBearFVGCount);

   color lineClrs[4];
   lineClrs[0] = clrGold;
   lineClrs[1] = (activeTrend > 0) ? clrSpringGreen : (activeTrend < 0) ? clrTomato : clrYellow;
   lineClrs[2] = clrLightGray;
   lineClrs[3] = (g_currentZone == "Premium") ? clrTomato : (g_currentZone == "Discount") ? clrSpringGreen : clrWhite;

   for(int k = 0; k < 4; k++)
   {
      string lblName = prefix + "HUD_Txt_" + IntegerToString(k);
      if(ObjectFind(0, lblName) < 0)
      {
         ObjectCreate(0, lblName, OBJ_LABEL, 0, 0, 0);
         ObjectSetString(0, lblName, OBJPROP_FONT, (k == 0) ? "Segoe UI Bold" : "Segoe UI Semibold");
         ObjectSetInteger(0, lblName, OBJPROP_FONTSIZE, 8);
         ObjectSetInteger(0, lblName, OBJPROP_BACK, false);
      }
      ObjectSetInteger(0, lblName, OBJPROP_CORNER, InpHUDCorner);
      ObjectSetInteger(0, lblName, OBJPROP_XDISTANCE, startX + 10);
      ObjectSetInteger(0, lblName, OBJPROP_YDISTANCE, startY + 8 + (k * 17));
      ObjectSetString(0, lblName, OBJPROP_TEXT, lines[k]);
      ObjectSetInteger(0, lblName, OBJPROP_COLOR, lineClrs[k]);
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
   if(rates_total < InpMajorLookback * 2 + 10) return(0);

   ArraySetAsSeries(time, true);
   ArraySetAsSeries(open, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(BufferMajorHi, true);
   ArraySetAsSeries(BufferMajorLo, true);
   ArraySetAsSeries(BufferMinorHi, true);
   ArraySetAsSeries(BufferMinorLo, true);

   int limit = rates_total - prev_calculated + InpMajorLookback * 2;
   if(limit > rates_total - InpMajorLookback - 1) limit = rates_total - InpMajorLookback - 1;
   if(limit > InpMaxHistoryBars) limit = InpMaxHistoryBars;

   // 1. Reset buffers
   for(int i = limit; i >= 0; i--)
   {
      BufferMajorHi[i] = EMPTY_VALUE;
      BufferMajorLo[i] = EMPTY_VALUE;
      BufferMinorHi[i] = EMPTY_VALUE;
      BufferMinorLo[i] = EMPTY_VALUE;
   }

   // 2. Identify Major & Minor Swings
   for(int i = limit; i >= InpMinorLookback; i--)
   {
      // Minor Swings
      if(InpShowInternal && i <= limit - InpMinorLookback && i >= InpMinorLookback)
      {
         bool isMinorH = true;
         bool isMinorL = true;
         for(int k = 1; k <= InpMinorLookback; k++)
         {
            if(high[i] <= high[i - k] || high[i] < high[i + k]) isMinorH = false;
            if(low[i]  >= low[i - k]  || low[i]  > low[i + k])  isMinorL = false;
         }
         if(isMinorH) BufferMinorHi[i] = high[i];
         if(isMinorL) BufferMinorLo[i] = low[i];
      }

      // Major Swings
      if(i <= limit - InpMajorLookback && i >= InpMajorLookback)
      {
         bool isMajorH = true;
         bool isMajorL = true;
         for(int k = 1; k <= InpMajorLookback; k++)
         {
            if(high[i] <= high[i - k] || high[i] < high[i + k]) isMajorH = false;
            if(low[i]  >= low[i - k]  || low[i]  > low[i + k])  isMajorL = false;
         }
         if(isMajorH) BufferMajorHi[i] = high[i];
         if(isMajorL) BufferMajorLo[i] = low[i];
      }
   }

   // 3. FVG Detection (3-Candle Imbalances)
   g_activeBullFVGCount = 0;
   g_activeBearFVGCount = 0;
   if(InpShowFVG)
   {
      double minGap = InpMinFVGPips * _Point * 10.0;
      for(int i = limit; i >= 2; i--)
      {
         // Bullish FVG
         if(low[i - 2] - high[i] >= minGap)
         {
            datetime endT = time[0];
            bool mitigated = false;
            for(int m = i - 1; m >= 0; m--)
            {
               if(low[m] <= high[i]) { endT = time[m]; mitigated = true; break; }
            }
            if(!mitigated) g_activeBullFVGCount++;
            string fvgName = StringFormat("FVG_Bull_%s", TimeToString(time[i - 1]));
            DrawBox(fvgName, time[i], low[i - 2], endT, high[i], InpBullFVGColor, true);
         }

         // Bearish FVG
         if(low[i] - high[i - 2] >= minGap)
         {
            datetime endT = time[0];
            bool mitigated = false;
            for(int m = i - 1; m >= 0; m--)
            {
               if(high[m] >= low[i]) { endT = time[m]; mitigated = true; break; }
            }
            if(!mitigated) g_activeBearFVGCount++;
            string fvgName = StringFormat("FVG_Bear_%s", TimeToString(time[i - 1]));
            DrawBox(fvgName, time[i], low[i], endT, high[i - 2], InpBearFVGColor, true);
         }
      }
   }

   // 4. Liquidity Pools (Equal Highs EQH / Equal Lows EQL)
   if(InpShowLiquidity)
   {
      double eqTol = InpEQHTolerance * _Point * 10.0;
      double prevSH = EMPTY_VALUE;
      datetime prevSH_time = 0;
      double prevSL = EMPTY_VALUE;
      datetime prevSL_time = 0;

      for(int i = limit; i >= 1; i--)
      {
         if(BufferMajorHi[i] != EMPTY_VALUE)
         {
            if(prevSH != EMPTY_VALUE && MathAbs(BufferMajorHi[i] - prevSH) <= eqTol)
            {
               string eqhName = StringFormat("EQH_%s", TimeToString(time[i]));
               DrawLiquidityLine(eqhName, prevSH_time, BufferMajorHi[i], time[0], InpLiquidityColor, "$$$ EQH");
            }
            prevSH = BufferMajorHi[i];
            prevSH_time = time[i];
         }

         if(BufferMajorLo[i] != EMPTY_VALUE)
         {
            if(prevSL != EMPTY_VALUE && MathAbs(BufferMajorLo[i] - prevSL) <= eqTol)
            {
               string eqlName = StringFormat("EQL_%s", TimeToString(time[i]));
               DrawLiquidityLine(eqlName, prevSL_time, BufferMajorLo[i], time[0], InpLiquidityColor, "$$$ EQL");
            }
            prevSL = BufferMajorLo[i];
            prevSL_time = time[i];
         }
      }
   }

   // 5. Major BOS, CHoCH, Liquidity Sweeps (SFP) & Order Blocks
   int lastTrend = 0; // +1 = Uptrend, -1 = Downtrend
   double lastSH = EMPTY_VALUE, lastSL = EMPTY_VALUE;
   datetime lastSH_time = 0, lastSL_time = 0;
   int lastSH_bar = 0, lastSL_bar = 0;

   g_activeBullOBCount = 0;
   g_activeBearOBCount = 0;

   for(int i = limit; i >= 1; i--)
   {
      if(BufferMajorHi[i] != EMPTY_VALUE && BufferMajorHi[i] > 100.0)
      {
         lastSH      = BufferMajorHi[i];
         lastSH_time = time[i];
         lastSH_bar  = i;
      }
      if(BufferMajorLo[i] != EMPTY_VALUE && BufferMajorLo[i] > 100.0)
      {
         lastSL      = BufferMajorLo[i];
         lastSL_time = time[i];
         lastSL_bar  = i;
      }

      // Check Liquidity Sweeps / SFP (Wick beyond, Close inside)
      if(InpShowSweeps)
      {
         // Bearish SFP (Sweep of Swing High)
         if(lastSH != EMPTY_VALUE && high[i] > lastSH && close[i] < lastSH && close[i + 1] < lastSH)
         {
            if(time[i] - lastSweepBearTime > PeriodSeconds() * 3)
            {
               lastSweepBearTime = time[i];
               string sfpName = StringFormat("SFP_Bear_%s", TimeToString(time[i]));
               DrawSweepLabel(sfpName, time[i], high[i], InpBearSweepColor, "SFP", false);
               if(i == 1 && time[1] != lastAlertTime)
               {
                  TriggerAlert(StringFormat("[SMC ALERT] %s M%d: Bearish Liquidity Sweep (SFP) at %.2f", _Symbol, _Period, high[1]));
                  lastAlertTime = time[1];
                  g_lastStructureEvent = "Bearish SFP";
               }
            }
         }

         // Bullish SFP (Sweep of Swing Low)
         if(lastSL != EMPTY_VALUE && low[i] < lastSL && close[i] > lastSL && close[i + 1] > lastSL)
         {
            if(time[i] - lastSweepBullTime > PeriodSeconds() * 3)
            {
               lastSweepBullTime = time[i];
               string sfpName = StringFormat("SFP_Bull_%s", TimeToString(time[i]));
               DrawSweepLabel(sfpName, time[i], low[i], InpBullSweepColor, "SFP", true);
               if(i == 1 && time[1] != lastAlertTime)
               {
                  TriggerAlert(StringFormat("[SMC ALERT] %s M%d: Bullish Liquidity Sweep (SFP) at %.2f", _Symbol, _Period, low[1]));
                  lastAlertTime = time[1];
                  g_lastStructureEvent = "Bullish SFP";
               }
            }
         }
      }

      // Check Bullish Breakout (Candle Close Above Swing High)
      if(lastSH != EMPTY_VALUE && close[i] > lastSH && close[i + 1] <= lastSH)
      {
         bool isBOS = (lastTrend >= 0);
         string tag = isBOS ? "BOS" : "CHoCH";
         color  clr = isBOS ? InpBullBOSColor : InpCHoCHColor;

         if((isBOS && InpShowMajorBOS) || (!isBOS && InpShowMajorCHoCH))
         {
            string lineName = StringFormat("Major_%s_Bull_%s", tag, TimeToString(time[i]));
            DrawStructureLine(lineName, lastSH_time, lastSH, time[i], lastSH, clr, tag);
         }

         if(i == 1 && time[1] != lastAlertTime)
         {
            TriggerAlert(StringFormat("[SMC ALERT] %s M%d: Major Bullish %s Break at %.2f", _Symbol, _Period, tag, close[1]));
            lastAlertTime = time[1];
            g_lastStructureEvent = "Major Bullish " + tag;
         }

         // Order Block: last down candle before expansion
         if(InpShowOB && lastSH_bar > i)
         {
            int obBar = -1;
            for(int b = lastSH_bar - 1; b >= i; b--)
            {
               if(close[b] < open[b]) { obBar = b; break; }
            }
            if(obBar > 0)
            {
               datetime endT = time[0];
               bool mitigated = false;
               for(int m = obBar - 1; m >= 0; m--)
               {
                  if(close[m] < low[obBar]) { endT = time[m]; mitigated = true; break; }
               }
               if(!mitigated) g_activeBullOBCount++;
               string obName = StringFormat("OB_Bull_%s", TimeToString(time[obBar]));
               DrawBox(obName, time[obBar], high[obBar], endT, low[obBar], InpBullOBColor, false);
            }
         }

         lastTrend = 1;
         lastSH    = EMPTY_VALUE; // Consumed
      }

      // Check Bearish Breakout (Candle Close Below Swing Low)
      if(lastSL != EMPTY_VALUE && close[i] < lastSL && close[i + 1] >= lastSL)
      {
         bool isBOS = (lastTrend <= 0);
         string tag = isBOS ? "BOS" : "CHoCH";
         color  clr = isBOS ? InpBearBOSColor : InpCHoCHColor;

         if((isBOS && InpShowMajorBOS) || (!isBOS && InpShowMajorCHoCH))
         {
            string lineName = StringFormat("Major_%s_Bear_%s", tag, TimeToString(time[i]));
            DrawStructureLine(lineName, lastSL_time, lastSL, time[i], lastSL, clr, tag);
         }

         if(i == 1 && time[1] != lastAlertTime)
         {
            TriggerAlert(StringFormat("[SMC ALERT] %s M%d: Major Bearish %s Break at %.2f", _Symbol, _Period, tag, close[1]));
            lastAlertTime = time[1];
            g_lastStructureEvent = "Major Bearish " + tag;
         }

         // Order Block: last up candle before expansion
         if(InpShowOB && lastSL_bar > i)
         {
            int obBar = -1;
            for(int b = lastSL_bar - 1; b >= i; b--)
            {
               if(close[b] > open[b]) { obBar = b; break; }
            }
            if(obBar > 0)
            {
               datetime endT = time[0];
               bool mitigated = false;
               for(int m = obBar - 1; m >= 0; m--)
               {
                  if(close[m] > high[obBar]) { endT = time[m]; mitigated = true; break; }
               }
               if(!mitigated) g_activeBearOBCount++;
               string obName = StringFormat("OB_Bear_%s", TimeToString(time[obBar]));
               DrawBox(obName, time[obBar], high[obBar], endT, low[obBar], InpBearOBColor, false);
            }
         }

         lastTrend = -1;
         lastSL    = EMPTY_VALUE; // Consumed
      }
   }

   // 6. Dealing Range (Premium / Discount / Equilibrium)
   double activeHi = 0.0, activeLo = 0.0;
   datetime hiTime = 0, loTime = 0;
   for(int i = 1; i < InpMaxHistoryBars && i < rates_total; i++)
   {
      if(BufferMajorHi[i] != EMPTY_VALUE && BufferMajorHi[i] > 100.0 && activeHi == 0.0)
      {
         activeHi = BufferMajorHi[i];
         hiTime   = time[i];
      }
      if(BufferMajorLo[i] != EMPTY_VALUE && BufferMajorLo[i] > 100.0 && activeLo == 0.0)
      {
         activeLo = BufferMajorLo[i];
         loTime   = time[i];
      }
      if(activeHi > 0.0 && activeLo > 0.0) break;
   }

   if(activeHi > 0.0 && activeLo > 0.0 && activeHi > activeLo)
   {
      datetime rangeStart = MathMin(hiTime, loTime);
      g_currentEqPrice = (activeHi + activeLo) / 2.0;
      double curP = close[0];

      if(curP > g_currentEqPrice)      g_currentZone = "Premium";
      else if(curP < g_currentEqPrice) g_currentZone = "Discount";
      else                             g_currentZone = "Equilibrium";

      if(InpShowPremDisc)
      {
         if(InpDrawDealingBoxes)
         {
            DrawBox("Prem_Box", rangeStart, activeHi, time[0], g_currentEqPrice, InpPremiumColor, false);
            DrawBox("Disc_Box", rangeStart, g_currentEqPrice, time[0], activeLo, InpDiscountColor, false);
         }
         else
         {
            ObjectDelete(0, prefix + "Prem_Box");
            ObjectDelete(0, prefix + "Disc_Box");
         }

         // Equilibrium 50% Line
         string eqLineName = prefix + "Eq_Line";
         if(ObjectFind(0, eqLineName) < 0)
         {
            ObjectCreate(0, eqLineName, OBJ_TREND, 0, rangeStart, g_currentEqPrice, time[0], g_currentEqPrice);
            ObjectSetInteger(0, eqLineName, OBJPROP_COLOR, InpEquilibriumColor);
            ObjectSetInteger(0, eqLineName, OBJPROP_STYLE, STYLE_DASH);
            ObjectSetInteger(0, eqLineName, OBJPROP_WIDTH, 1);
            ObjectSetInteger(0, eqLineName, OBJPROP_RAY_RIGHT, true);
         }
         else
         {
            ObjectSetDouble(0, eqLineName, OBJPROP_PRICE, 0, g_currentEqPrice);
            ObjectSetDouble(0, eqLineName, OBJPROP_PRICE, 1, g_currentEqPrice);
         }
      }

      // Update HUD
      UpdateHUD(lastTrend, curP, activeHi, activeLo);
   }

   return(rates_total);
}
//+------------------------------------------------------------------+
