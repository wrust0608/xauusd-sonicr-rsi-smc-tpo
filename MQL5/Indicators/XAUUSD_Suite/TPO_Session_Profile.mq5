//+------------------------------------------------------------------+
//|                                         TPO_Session_Profile.mq5 |
//|                                  Copyright 2026, Antigravity AI |
//|                       XAUUSD Quantitative Visualizer - Unleashed |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "2.55"
#property description "XAUUSD Time Price Opportunity (TPO) Market Profile Suite: S1/S2/S3 VN Sessions, 70% Value Area, POC, Initial Balance, Clean HUD & Non-Cluttering Density"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3

//--- Plot 1: POC (Point of Control)
#property indicator_label1  "Session POC"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrMagenta
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

//--- Plot 2: VAH (Value Area High)
#property indicator_label2  "Session VAH"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRoyalBlue
#property indicator_style2  STYLE_DASH
#property indicator_width2  1

//--- Plot 3: VAL (Value Area Low)
#property indicator_label3  "Session VAL"
#property indicator_type3   DRAW_LINE
#property indicator_color2  clrRoyalBlue
#property indicator_style3  STYLE_DASH
#property indicator_width3  1

//--- Input Parameters
input group "=== 1. TPO Price Step & Profile Geometry ==="
input double   InpRowHeight        = 0.50;          // TPO Price Row Height (Gold default = $0.50)
input int      InpHistoryDays      = 5;             // Number of Days to Profile
input double   InpValueAreaPct     = 70.0;          // Value Area Percentage (Standard = 70.0%)
input bool     InpDrawHistogram    = true;          // Render TPO Distribution Histogram Bars
input int      InpMaxHistBarsWidth = 12;            // Max Bar Width for TPO Histogram (in candles)

input group "=== 2. Session Definition (Vietnam Time Schedule) ==="
input int      InpTimeShiftHours   = 5;             // Time Shift (VN Time - Server Time, Exness UTC+0 = 7, UTC+2 = 5)
input bool     InpAutoSummerDST    = false;         // Summer 1-Hour Earlier Shift for London/NY
input bool     InpShowAsian        = true;          // Profile S1: Asian (06:00 - 14:59 VN)
input bool     InpShowLondon       = true;          // Profile S2: London (15:00 - 19:59 VN)
input bool     InpShowNY           = true;          // Profile S3: New York (20:00 - 05:59 VN)

input group "=== 3. Initial Balance & Market Auction Anatomy ==="
input bool     InpShowIB           = true;          // Show Initial Balance (IB 1st Hour)
input color    InpIBColor          = clrDarkOrange; // Initial Balance Color
input bool     InpShowSinglePrints = true;          // Highlight Single Prints (Unfinished Auction)
input color    InpSinglePrintColor = clrAqua;       // Single Prints Highlight Color
input bool     InpShowPoorExtremes = true;          // Detect Poor Highs / Poor Lows
input color    InpPoorHighColor    = clrTomato;     // Poor High Label Color
input color    InpPoorLowColor     = clrSpringGreen;// Poor Low Label Color

input group "=== 4. Session Colors ==="
input color    InpAsianVAColor     = clrDodgerBlue; // S1 Asian VA Border
input color    InpLondonVAColor    = clrSeaGreen;   // S2 London VA Border
input color    InpNYVAColor        = clrDarkSalmon; // S3 New York VA Border
input color    InpAsianHistColor   = C'18,28,42';  // S1 Histogram Bar
input color    InpLondonHistColor  = C'18,36,28';   // S2 Histogram Bar
input color    InpNYHistColor      = C'40,22,22';  // S3 Histogram Bar

input group "=== 5. Visual HUD Dashboard ==="
input bool     InpShowHUD          = true;          // Show TPO Status Dashboard
input int      InpHUDCorner        = 1;             // HUD Corner (1 = Top-Right, 0 = Top-Left)
input color    InpHUDColor         = clrWhite;      // HUD Text Color

input group "=== 6. Multi-Channel Alert Settings ==="
input bool     InpEnablePopup      = false;          // Enable Pop-up Alerts
input bool     InpEnableSound      = true;          // Enable Sound Alerts
input bool     InpEnablePush       = false;         // Enable Push Notification (Phone)
input bool     InpEnableEmail      = false;         // Enable Email Alerts

//--- Indicator Buffers
double BufferPOC[];
double BufferVAH[];
double BufferVAL[];

//--- Global State
string prefix;
datetime lastAlertTime = 0;
string g_activeSessionName = "None";
double g_activePOC = 0.0;
double g_activeVAH = 0.0;
double g_activeVAL = 0.0;
double g_activeIBHigh = 0.0;
double g_activeIBLow  = 0.0;
string g_activeAuctionState = "Inside Value";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, BufferPOC, INDICATOR_DATA);
   SetIndexBuffer(1, BufferVAH, INDICATOR_DATA);
   SetIndexBuffer(2, BufferVAL, INDICATOR_DATA);

   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   prefix = "TPO_" + _Symbol + "_";
   ObjectsDeleteAll(0, prefix);

   IndicatorSetString(INDICATOR_SHORTNAME, "TPO Unleashed (" + _Symbol + ")");
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
   if(InpEnableEmail) SendMail("TPO Session Alert", text);
}

//+------------------------------------------------------------------+
//| Helper: Convert Server Time to Vietnam Time                      |
//+------------------------------------------------------------------+
MqlDateTime ServerToVN(datetime srvTime)
{
   datetime vnTime = srvTime + (datetime)(InpTimeShiftHours * 3600);
   MqlDateTime dt;
   TimeToStruct(vnTime, dt);
   return(dt);
}

//+------------------------------------------------------------------+
//| Render HUD Dashboard - Compact Top-Right Dock                    |
//+------------------------------------------------------------------+
void UpdateHUD(double curPrice)
{
   if(!InpShowHUD) return;

   int startX = 15;
   int startY = 110; // Docked below Sonic R HUD in Top-Right
   int width  = 210;
   int height = 72;

   string bgName = prefix + "HUD_BG";
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

   string lines[4];
   lines[0] = "TPO MARKET PROFILE";
   lines[1] = StringFormat("Session: %s | %s", g_activeSessionName, g_activeAuctionState);
   lines[2] = StringFormat("POC: %.2f | IB: %.1f-%.1f", g_activePOC, g_activeIBLow, g_activeIBHigh);
   lines[3] = StringFormat("VA (70%%): %.1f - %.1f", g_activeVAL, g_activeVAH);

   color lineClrs[4];
   lineClrs[0] = clrCyan;
   lineClrs[1] = clrWhite;
   lineClrs[2] = clrMagenta;
   lineClrs[3] = (curPrice > g_activeVAH) ? clrSpringGreen : (curPrice < g_activeVAL) ? clrTomato : clrYellow;

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
      ObjectSetInteger(0, lblName, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      ObjectSetInteger(0, lblName, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0, lblName, OBJPROP_XDISTANCE, startX + width - 10);
      ObjectSetInteger(0, lblName, OBJPROP_YDISTANCE, startY + 6 + (k * 15));
      ObjectSetString(0, lblName, OBJPROP_TEXT, lines[k]);
      ObjectSetInteger(0, lblName, OBJPROP_COLOR, lineClrs[k]);
   }
}

//+------------------------------------------------------------------+
//| Calculate Value Area using strict 70% Outward Expansion Algorithm |
//+------------------------------------------------------------------+
void CalculateValueArea(const int &tpoCounts[], int numBins, double minPrice, double rowStep, double vaPct,
                        double &outPOC, double &outVAH, double &outVAL, int &pocIdx, int &valIdx, int &vahIdx)
{
   if(numBins <= 0) return;

   int maxCount = -1;
   pocIdx = 0;
   int totalTPO = 0;

   for(int i = 0; i < numBins; i++)
   {
      totalTPO += tpoCounts[i];
      if(tpoCounts[i] > maxCount)
      {
         maxCount = tpoCounts[i];
         pocIdx   = i;
      }
   }

   outPOC = minPrice + pocIdx * rowStep + (rowStep * 0.5);
   if(totalTPO <= 0)
   {
      outVAH = outPOC;
      outVAL = outPOC;
      valIdx = pocIdx;
      vahIdx = pocIdx;
      return;
   }

   int targetTPO = (int)MathRound(totalTPO * (vaPct / 100.0));
   int covered   = tpoCounts[pocIdx];
   int lowIdx    = pocIdx;
   int highIdx   = pocIdx;

   while(covered < targetTPO)
   {
      bool has_up   = (highIdx + 1 < numBins);
      bool has_down = (lowIdx - 1 >= 0);

      if(!has_up && !has_down) break;

      if(has_up && !has_down)
      {
         highIdx++;
         covered += tpoCounts[highIdx];
      }
      else if(has_down && !has_up)
      {
         lowIdx--;
         covered += tpoCounts[lowIdx];
      }
      else
      {
         int countUp   = tpoCounts[highIdx + 1];
         int countDown = tpoCounts[lowIdx - 1];

         if(countUp > countDown)
         {
            highIdx++;
            covered += tpoCounts[highIdx];
         }
         else if(countDown > countUp)
         {
            lowIdx--;
            covered += tpoCounts[lowIdx];
         }
         else
         {
            int distUp   = MathAbs((highIdx + 1) - pocIdx);
            int distDown = MathAbs((lowIdx - 1) - pocIdx);

            if(distUp < distDown)
            {
               highIdx++;
               covered += tpoCounts[highIdx];
            }
            else if(distDown < distUp)
            {
               lowIdx--;
               covered += tpoCounts[lowIdx];
            }
            else
            {
               highIdx++;
               covered += tpoCounts[highIdx];
            }
         }
      }
   }

   valIdx = lowIdx;
   vahIdx = highIdx;
   outVAL = minPrice + lowIdx * rowStep;
   outVAH = minPrice + (highIdx + 1) * rowStep;
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
   if(rates_total < 50) return(0);

   ArraySetAsSeries(time, true);
   ArraySetAsSeries(open, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(BufferPOC, true);
   ArraySetAsSeries(BufferVAH, true);
   ArraySetAsSeries(BufferVAL, true);

   for(int i = 0; i < 50 && i < rates_total; i++)
   {
      BufferPOC[i] = EMPTY_VALUE;
      BufferVAH[i] = EMPTY_VALUE;
      BufferVAL[i] = EMPTY_VALUE;
   }

   int maxBars = InpHistoryDays * 1440 / (PeriodSeconds() / 60);
   if(maxBars > rates_total - 1) maxBars = rates_total - 1;

   int idx = 0;
   int sessionCount = 0;

   while(idx < maxBars)
   {
      MqlDateTime dt = ServerToVN(time[idx]);
      int hour = dt.hour;
      int min  = dt.min;
      int totalMinutes = hour * 60 + min;

      string sessName = "";
      color  sessVAClr = clrWhite;
      color  sessHistClr = clrWhite;
      bool   isSession = false;

      // S1: Asian (06:00 to 14:59 VN)
      if(InpShowAsian && totalMinutes >= 360 && totalMinutes <= 899)
      {
         sessName    = "S1_Asian";
         sessVAClr   = InpAsianVAColor;
         sessHistClr = InpAsianHistColor;
         isSession   = true;
      }
      // S2: London (15:00 to 19:59 VN)
      int lonStart = InpAutoSummerDST ? 840 : 900;
      int lonEnd   = InpAutoSummerDST ? 1139 : 1199;
      if(InpShowLondon && totalMinutes >= lonStart && totalMinutes <= lonEnd)
      {
         sessName    = "S2_London";
         sessVAClr   = InpLondonVAColor;
         sessHistClr = InpLondonHistColor;
         isSession   = true;
      }
      // S3: NY (20:00 to 05:59 VN)
      int nyStart = InpAutoSummerDST ? 1140 : 1200;
      if(InpShowNY && (totalMinutes >= nyStart || totalMinutes <= 359))
      {
         sessName    = "S3_NewYork";
         sessVAClr   = InpNYVAColor;
         sessHistClr = InpNYHistColor;
         isSession   = true;
      }

      if(!isSession)
      {
         idx++;
         continue;
      }

      int startIdx = idx;
      while(startIdx + 1 < maxBars)
      {
         MqlDateTime dtNext = ServerToVN(time[startIdx + 1]);
         int nextMins = dtNext.hour * 60 + dtNext.min;

         bool sameSess = false;
         if(sessName == "S1_Asian"   && nextMins >= 360 && nextMins <= 899) sameSess = true;
         if(sessName == "S2_London"  && nextMins >= lonStart && nextMins <= lonEnd) sameSess = true;
         if(sessName == "S3_NewYork" && (nextMins >= nyStart || nextMins <= 359)) sameSess = true;

         if(sameSess) startIdx++;
         else break;
      }

      int endIdx = idx;
      datetime tStart = time[startIdx];
      datetime tEnd   = time[endIdx];

      double minP = 1000000.0;
      double maxP = 0.0;
      for(int b = startIdx; b >= endIdx; b--)
      {
         if(low[b]  < minP) minP = low[b];
         if(high[b] > maxP) maxP = high[b];
      }

      int numBins = (int)MathCeil((maxP - minP) / InpRowHeight) + 1;
      if(numBins > 0 && numBins < 1500)
      {
         sessionCount++;
         int tpoCounts[];
         ArrayResize(tpoCounts, numBins);
         ArrayInitialize(tpoCounts, 0);

         double ibHigh = 0.0, ibLow = 1000000.0;
         int ibEndIdx = startIdx;
         int barsPerHour = 3600 / PeriodSeconds();
         int ibBarLimit  = startIdx - barsPerHour;
         if(ibBarLimit < endIdx) ibBarLimit = endIdx;

         for(int b = startIdx; b >= endIdx; b--)
         {
            int bLowBin  = (int)MathFloor((low[b]  - minP) / InpRowHeight);
            int bHighBin = (int)MathFloor((high[b] - minP) / InpRowHeight);

            if(bLowBin  < 0) bLowBin  = 0;
            if(bHighBin >= numBins) bHighBin = numBins - 1;

            for(int bin = bLowBin; bin <= bHighBin; bin++)
            {
               tpoCounts[bin]++;
            }

            if(b >= ibBarLimit)
            {
               if(high[b] > ibHigh) ibHigh = high[b];
               if(low[b]  < ibLow)  ibLow  = low[b];
               ibEndIdx = b;
            }
         }

         double poc = 0.0, vah = 0.0, val = 0.0;
         int pocIdx = 0, valIdx = 0, vahIdx = 0;
         CalculateValueArea(tpoCounts, numBins, minP, InpRowHeight, InpValueAreaPct, poc, vah, val, pocIdx, valIdx, vahIdx);

         if(endIdx <= 1)
         {
            g_activeSessionName = sessName;
            g_activePOC         = poc;
            g_activeVAH         = vah;
            g_activeVAL         = val;
            g_activeIBHigh      = ibHigh;
            g_activeIBLow       = ibLow;

            double curP = close[0];
            if(curP > vah)      g_activeAuctionState = "Bullish Extension";
            else if(curP < val) g_activeAuctionState = "Bearish Extension";
            else                g_activeAuctionState = "Inside Value";

            for(int b = startIdx; b >= endIdx; b--)
            {
               BufferPOC[b] = poc;
               BufferVAH[b] = vah;
               BufferVAL[b] = val;
            }
         }

         // Render Graphic Objects
         string sessionID = sessName + "_" + TimeToString(tStart);

         // 1. Value Area Frame (Non-filled dashed boundary for clean chart)
         string vaBoxName = prefix + "VABox_" + sessionID;
         if(ObjectFind(0, vaBoxName) < 0)
         {
            ObjectCreate(0, vaBoxName, OBJ_RECTANGLE, 0, tStart, vah, tEnd, val);
            ObjectSetInteger(0, vaBoxName, OBJPROP_COLOR, sessVAClr);
            ObjectSetInteger(0, vaBoxName, OBJPROP_STYLE, STYLE_DASH);
            ObjectSetInteger(0, vaBoxName, OBJPROP_WIDTH, 1);
            ObjectSetInteger(0, vaBoxName, OBJPROP_FILL, false);
            ObjectSetInteger(0, vaBoxName, OBJPROP_BACK, true);
         }
         else
         {
            ObjectSetInteger(0, vaBoxName, OBJPROP_TIME, 1, tEnd);
         }

         // 2. POC Ray Line & Label
         string pocLineName = prefix + "POC_" + sessionID;
         if(ObjectFind(0, pocLineName) < 0)
         {
            ObjectCreate(0, pocLineName, OBJ_TREND, 0, tStart, poc, tEnd, poc);
            ObjectSetInteger(0, pocLineName, OBJPROP_COLOR, clrMagenta);
            ObjectSetInteger(0, pocLineName, OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0, pocLineName, OBJPROP_WIDTH, 2);
            ObjectSetInteger(0, pocLineName, OBJPROP_RAY_RIGHT, false);

            string pocLbl = pocLineName + "_lbl";
            ObjectCreate(0, pocLbl, OBJ_TEXT, 0, tEnd, poc);
            ObjectSetString(0, pocLbl, OBJPROP_TEXT, StringFormat("%s POC: %.2f", sessName, poc));
            ObjectSetInteger(0, pocLbl, OBJPROP_COLOR, clrMagenta);
            ObjectSetString(0, pocLbl, OBJPROP_FONT, "Segoe UI Semibold");
            ObjectSetInteger(0, pocLbl, OBJPROP_FONTSIZE, 8);
         }
         else
         {
            ObjectSetInteger(0, pocLineName, OBJPROP_TIME, 1, tEnd);
            ObjectSetInteger(0, pocLineName + "_lbl", OBJPROP_TIME, tEnd);
         }

         // 3. Initial Balance Box
         if(InpShowIB && ibHigh > 0 && ibLow < 1000000.0)
         {
            string ibBoxName = prefix + "IB_" + sessionID;
            datetime tIBEnd = time[ibEndIdx];
            if(ObjectFind(0, ibBoxName) < 0)
            {
               ObjectCreate(0, ibBoxName, OBJ_RECTANGLE, 0, tStart, ibHigh, tIBEnd, ibLow);
               ObjectSetInteger(0, ibBoxName, OBJPROP_COLOR, InpIBColor);
               ObjectSetInteger(0, ibBoxName, OBJPROP_STYLE, STYLE_DOT);
               ObjectSetInteger(0, ibBoxName, OBJPROP_WIDTH, 1);
               ObjectSetInteger(0, ibBoxName, OBJPROP_FILL, false);
            }
         }

         // 4. Poor High & Poor Low Markers
         if(InpShowPoorExtremes && numBins > 2)
         {
            int topBin = numBins - 2;
            while(topBin > 0 && tpoCounts[topBin] == 0) topBin--;
            int btmBin = 1;
            while(btmBin < numBins && tpoCounts[btmBin] == 0) btmBin++;

            if(tpoCounts[topBin] >= 2)
            {
               string phName = prefix + "PoorHi_" + sessionID;
               if(ObjectFind(0, phName) < 0)
               {
                  ObjectCreate(0, phName, OBJ_TEXT, 0, tStart + (datetime)((tEnd - tStart) / 2), maxP);
                  ObjectSetString(0, phName, OBJPROP_TEXT, "Poor Hi");
                  ObjectSetInteger(0, phName, OBJPROP_COLOR, InpPoorHighColor);
                  ObjectSetString(0, phName, OBJPROP_FONT, "Segoe UI Bold");
                  ObjectSetInteger(0, phName, OBJPROP_FONTSIZE, 7);
                  ObjectSetInteger(0, phName, OBJPROP_ANCHOR, ANCHOR_LOWER);
               }
            }

            if(tpoCounts[btmBin] >= 2)
            {
               string plName = prefix + "PoorLo_" + sessionID;
               if(ObjectFind(0, plName) < 0)
               {
                  ObjectCreate(0, plName, OBJ_TEXT, 0, tStart + (datetime)((tEnd - tStart) / 2), minP);
                  ObjectSetString(0, plName, OBJPROP_TEXT, "Poor Lo");
                  ObjectSetInteger(0, plName, OBJPROP_COLOR, InpPoorLowColor);
                  ObjectSetString(0, plName, OBJPROP_FONT, "Segoe UI Bold");
                  ObjectSetInteger(0, plName, OBJPROP_FONTSIZE, 7);
                  ObjectSetInteger(0, plName, OBJPROP_ANCHOR, ANCHOR_UPPER);
               }
            }
         }

         // 5. TPO Histogram Density (Rendered only for recent 2 sessions to avoid chart clutter)
         if(InpDrawHistogram && numBins > 1 && sessionCount <= 2)
         {
            int secPerBar = PeriodSeconds();
            for(int bin = 0; bin < numBins; bin++)
            {
               if(tpoCounts[bin] <= 0) continue;
               double rowP = minP + bin * InpRowHeight;
               int barWidth = (int)MathMin(tpoCounts[bin], InpMaxHistBarsWidth);
               datetime hEnd = tStart + (datetime)(barWidth * secPerBar);

               string histName = StringFormat("%sHist_%s_%d", prefix, sessionID, bin);
               if(ObjectFind(0, histName) < 0)
               {
                  ObjectCreate(0, histName, OBJ_RECTANGLE, 0, tStart, rowP + InpRowHeight, hEnd, rowP);
                  ObjectSetInteger(0, histName, OBJPROP_COLOR, sessHistClr);
                  ObjectSetInteger(0, histName, OBJPROP_BGCOLOR, sessHistClr);
                  ObjectSetInteger(0, histName, OBJPROP_STYLE, STYLE_SOLID);
                  ObjectSetInteger(0, histName, OBJPROP_WIDTH, 1);
                  ObjectSetInteger(0, histName, OBJPROP_FILL, true);
                  ObjectSetInteger(0, histName, OBJPROP_BACK, true);
               }
            }
         }
      }

      idx = startIdx + 1;
   }

   UpdateHUD(close[0]);
   return(rates_total);
}
//+------------------------------------------------------------------+
