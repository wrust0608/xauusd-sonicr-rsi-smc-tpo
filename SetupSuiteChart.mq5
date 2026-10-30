//+------------------------------------------------------------------+
//|                                              SetupSuiteChart.mq5 |
//|                                  Copyright 2026, Antigravity AI  |
//|                                     XAUUSD Suite One-Click Setup |
//+------------------------------------------------------------------+
#property copyright "Antigravity AI"
#property link      "https://antigravity.ai"
#property version   "1.00"
#property script_show_inputs false

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   long chartId = ChartID();
   Print("Initializing XAUUSD Suite Setup on Chart ", chartId, " Symbol: ", _Symbol, " Period: ", EnumToString((ENUM_TIMEFRAMES)_Period));

   // 1. Chart Canvas & Visual Architecture (Dark Elegance)
   ChartSetInteger(chartId, CHART_MODE, CHART_CANDLES);
   ChartSetInteger(chartId, CHART_SHOW_GRID, false);
   ChartSetInteger(chartId, CHART_SHOW_VOLUMES, CHART_VOLUME_HIDE);
   ChartSetInteger(chartId, CHART_SHOW_PERIOD_SEP, false);
   ChartSetInteger(chartId, CHART_SHOW_OHLC, false);
   ChartSetInteger(chartId, CHART_SHOW_ONE_CLICK, false);
   ChartSetInteger(chartId, CHART_AUTOSCROLL, true);
   ChartSetInteger(chartId, CHART_SHIFT, true);
   ChartSetDouble(chartId, CHART_SHIFT_SIZE, 15.0);
   
   // Premium Dark Theme Palette
   ChartSetInteger(chartId, CHART_COLOR_BACKGROUND, C'16,18,24');     // Deep Obsidian Navy
   ChartSetInteger(chartId, CHART_COLOR_FOREGROUND, C'200,205,215');  // Soft Silver White
   ChartSetInteger(chartId, CHART_COLOR_GRID, C'28,32,42');          // Subtle Grid
   ChartSetInteger(chartId, CHART_COLOR_CANDLE_BULL, C'41,98,255');   // Premium Electric Blue
   ChartSetInteger(chartId, CHART_COLOR_CHART_UP, C'41,98,255');      // Bull border & wick
   ChartSetInteger(chartId, CHART_COLOR_CANDLE_BEAR, C'242,54,69');   // Premium Coral Crimson
   ChartSetInteger(chartId, CHART_COLOR_CHART_DOWN, C'242,54,69');    // Bear border & wick
   ChartSetInteger(chartId, CHART_COLOR_CHART_LINE, C'160,165,175');  // Neutral Line
   ChartSetInteger(chartId, CHART_COLOR_BID, C'41,98,255');
   ChartSetInteger(chartId, CHART_COLOR_ASK, C'242,54,69');

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

   // 2. Attach Indicator 1: Sonic R Setup Overlay (Subwindow 0)
   int hSonic = iCustom(_Symbol, _Period, "XAUUSD_Suite\\SonicR_Setup_Overlay");
   if(hSonic == INVALID_HANDLE) hSonic = iCustom(_Symbol, _Period, "SonicR_Setup_Overlay");
   if(hSonic != INVALID_HANDLE) ChartIndicatorAdd(chartId, 0, hSonic);

   // 3. Attach Indicator 2: SMC Market Structure Overlay (Subwindow 0)
   int hSMC = iCustom(_Symbol, _Period, "XAUUSD_Suite\\SMC_MarketStructure_Overlay");
   if(hSMC == INVALID_HANDLE) hSMC = iCustom(_Symbol, _Period, "SMC_MarketStructure_Overlay");
   if(hSMC != INVALID_HANDLE) ChartIndicatorAdd(chartId, 0, hSMC);

   // 4. Attach Indicator 3: TPO Session Profile (Subwindow 0)
   int hTPO = iCustom(_Symbol, _Period, "XAUUSD_Suite\\TPO_Session_Profile");
   if(hTPO == INVALID_HANDLE) hTPO = iCustom(_Symbol, _Period, "TPO_Session_Profile");
   if(hTPO != INVALID_HANDLE) ChartIndicatorAdd(chartId, 0, hTPO);

   // 5. Attach Indicator 4: RSI Trend Pulse Pane (Subwindow 1)
   int hRSI = iCustom(_Symbol, _Period, "XAUUSD_Suite\\RSI_Trend_Pulse_Pane");
   if(hRSI == INVALID_HANDLE) hRSI = iCustom(_Symbol, _Period, "RSI_Trend_Pulse_Pane");
   if(hRSI != INVALID_HANDLE) ChartIndicatorAdd(chartId, 1, hRSI);

   ChartRedraw(chartId);

   // 6. Save natively generated MT5 templates
   ChartSaveTemplate(chartId, "XAUUSD_SonicR_System.tpl");
   ChartSaveTemplate(chartId, "default.tpl");
   Print("XAUUSD Suite refined layout applied and saved to default.tpl successfully!");
}
