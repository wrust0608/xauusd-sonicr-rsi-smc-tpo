//+------------------------------------------------------------------+
//|                                              SetupSuiteChart.mq5 |
//|                                  Copyright 2026, Antigravity AI  |
//|                 XAUUSD Suite One-Click Setup - Pristine Candlesticks |
//+------------------------------------------------------------------+
#property copyright "Antigravity AI"
#property link      "https://antigravity.ai"
#property version   "2.70"
#property script_show_inputs false

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   long chartId = ChartID();
   Print("Initializing XAUUSD Suite Setup - Pristine Candlestick Mode on Chart ", chartId);

   // 1. Chart Visual Architecture - Candlesticks as the Hero Element
   ChartSetInteger(chartId, CHART_SCALE, 3);                // Optimal Zoom Scale (clear candle bodies & wicks!)
   ChartSetInteger(chartId, CHART_FOREGROUND, true);         // CANDLESTICKS ALWAYS RENDERED ON TOP!
   ChartSetInteger(chartId, CHART_MODE, CHART_CANDLES);     // Candlesticks Mode
   ChartSetInteger(chartId, CHART_SHOW_GRID, false);        // Zero Grid Clutter
   ChartSetInteger(chartId, CHART_SHOW_VOLUMES, CHART_VOLUME_HIDE); // Zero Volume Bars
   ChartSetInteger(chartId, CHART_SHOW_PERIOD_SEP, false);
   ChartSetInteger(chartId, CHART_SHOW_OHLC, false);
   ChartSetInteger(chartId, CHART_SHOW_ONE_CLICK, false);
   ChartSetInteger(chartId, CHART_AUTOSCROLL, true);
   ChartSetInteger(chartId, CHART_SHIFT, true);
   ChartSetDouble(chartId, CHART_SHIFT_SIZE, 15.0);

   // 2. TradingView Dark Aesthetic Palette
   ChartSetInteger(chartId, CHART_COLOR_BACKGROUND, C'19,23,34');     // TradingView Obsidian Dark #131722
   ChartSetInteger(chartId, CHART_COLOR_FOREGROUND, C'209,212,220');  // Clean Muted White Font
   ChartSetInteger(chartId, CHART_COLOR_GRID, C'28,32,42');
   ChartSetInteger(chartId, CHART_COLOR_CANDLE_BULL, C'38,166,154');  // TV Emerald Green Bull Body
   ChartSetInteger(chartId, CHART_COLOR_CHART_UP, C'38,166,154');     // TV Emerald Green Wick & Border
   ChartSetInteger(chartId, CHART_COLOR_CANDLE_BEAR, C'239,83,80');   // TV Coral Red Bear Body
   ChartSetInteger(chartId, CHART_COLOR_CHART_DOWN, C'239,83,80');    // TV Coral Red Wick & Border
   ChartSetInteger(chartId, CHART_COLOR_CHART_LINE, C'120,123,134');
   ChartSetInteger(chartId, CHART_COLOR_BID, C'38,166,154');
   ChartSetInteger(chartId, CHART_COLOR_ASK, C'239,83,80');

   // 3. Purge all legacy and orphaned objects from chart
   ObjectsDeleteAll(chartId, 0, -1);

   // Remove existing indicators to re-apply cleanly without duplicates
   for(int w = 2; w >= 0; w--)
   {
      int totalInd = ChartIndicatorsTotal(chartId, w);
      for(int i = totalInd - 1; i >= 0; i--)
      {
         string name = ChartIndicatorName(chartId, w, i);
         if(name != "Main") ChartIndicatorDelete(chartId, w, name);
      }
   }

   // 4. Attach Indicator 1: Sonic R Setup Overlay (Subwindow 0)
   int hSonic = iCustom(_Symbol, _Period, "XAUUSD_Suite\\SonicR_Setup_Overlay");
   if(hSonic == INVALID_HANDLE) hSonic = iCustom(_Symbol, _Period, "SonicR_Setup_Overlay");
   if(hSonic != INVALID_HANDLE) ChartIndicatorAdd(chartId, 0, hSonic);

   // 5. Attach Indicator 2: SMC Market Structure Overlay (Subwindow 0)
   int hSMC = iCustom(_Symbol, _Period, "XAUUSD_Suite\\SMC_MarketStructure_Overlay");
   if(hSMC == INVALID_HANDLE) hSMC = iCustom(_Symbol, _Period, "SMC_MarketStructure_Overlay");
   if(hSMC != INVALID_HANDLE) ChartIndicatorAdd(chartId, 0, hSMC);

   // 6. Attach Indicator 3: TPO Session Profile (Subwindow 0)
   int hTPO = iCustom(_Symbol, _Period, "XAUUSD_Suite\\TPO_Session_Profile");
   if(hTPO == INVALID_HANDLE) hTPO = iCustom(_Symbol, _Period, "TPO_Session_Profile");
   if(hTPO != INVALID_HANDLE) ChartIndicatorAdd(chartId, 0, hTPO);

   // 7. Attach Indicator 4: RSI Trend Pulse Pane (Subwindow 1)
   int hRSI = iCustom(_Symbol, _Period, "XAUUSD_Suite\\RSI_Trend_Pulse_Pane");
   if(hRSI == INVALID_HANDLE) hRSI = iCustom(_Symbol, _Period, "RSI_Trend_Pulse_Pane");
   if(hRSI != INVALID_HANDLE) ChartIndicatorAdd(chartId, 1, hRSI);

   ChartRedraw(chartId);

   // 8. Permanently save to MT5 template files
   ChartSaveTemplate(chartId, "XAUUSD_SonicR_System.tpl");
   ChartSaveTemplate(chartId, "default.tpl");
   Print("Pristine Candlestick layout applied and saved to default.tpl successfully!");
}
