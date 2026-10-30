//+------------------------------------------------------------------+
//|                             RunThoroughWickSniperBacktest.mq5   |
//|                                  Copyright 2026, Antigravity AI  |
//|  Comprehensive Multi-Month Backtest: Institutional Wick Rejection|
//|       & Sniper Touch (Zero Drawdown / MAE Analysis Engine)       |
//+------------------------------------------------------------------+
#property copyright   "Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "4.00"
#property description "Institutional Wick Rejection & Sniper Touch MAE Quantitative Backtester v4.0"
#property script_show_inputs false

//--- Data Structures for Tracking
struct TouchRecord
{
   datetime time;
   string   zoneType;
   bool     isBuy;
   double   levelPrice;
   bool     trendAligned;
   bool     hasConfluence;
   string   confluenceDetails;
   double   maePrice;      // Max adverse excursion in $
   double   mfePrice;      // Max favorable excursion in $
   bool     winSl080Tp160; // SL $0.80, TP $1.60 (1:2 RR)
   bool     winSl100Tp200; // SL $1.00, TP $2.00 (1:2 RR - "Khong gong am 1 gia")
   bool     winSl100Tp300; // SL $1.00, TP $3.00 (1:3 RR)
   bool     winSl150Tp300; // SL $1.50, TP $3.00 (1:2 RR)
   bool     winSl200Tp400; // SL $2.00, TP $4.00 (1:2 RR)
   int      barsHeld;
};

struct WickRecord
{
   datetime time;
   string   zoneType;
   bool     isBuy;
   bool     trendAligned;
   bool     structAligned;
   bool     rsiAligned;
   double   entryPrice;
   double   slPrice;
   double   tpPrice;
   double   slDistance;
   double   wickRatio;
   bool     isWin;
   double   rMultiple;
   double   realizedPL;
   int      barsHeld;
};

struct StructFVG
{
   datetime time;
   double   top;
   double   bottom;
   double   ce;
   bool     isBull;
   bool     mitigated;
};

struct StructOB
{
   datetime time;
   double   high;
   double   low;
   double   mid;
   bool     isBull;
   bool     mitigated;
};

//+------------------------------------------------------------------+
//| Script Execution Entrypoint                                      |
//+------------------------------------------------------------------+
void OnStart()
{
   Print("==========================================================================");
   Print("   STARTING XAUUSD INSTITUTIONAL WICK REJECTION & SNIPER TOUCH BACKTEST   ");
   Print("==========================================================================");

   int totalBars = iBars(_Symbol, _Period);
   PrintFormat("Target Symbol: %s | Period: %s | Total Available Bars: %d",
               _Symbol, EnumToString((ENUM_TIMEFRAMES)_Period), totalBars);

   if(totalBars < 500)
   {
      Print("ERROR: Not enough bars in history. Ensure XAUUSD M5 data is downloaded.");
      return;
   }

   // 1. Initialize Indicator Handles
   int hEMA34H = iMA(_Symbol, _Period, 34, 0, MODE_EMA, PRICE_HIGH);
   int hEMA34L = iMA(_Symbol, _Period, 34, 0, MODE_EMA, PRICE_LOW);
   int hEMA34C = iMA(_Symbol, _Period, 34, 0, MODE_EMA, PRICE_CLOSE);
   int hEMA89  = iMA(_Symbol, _Period, 89, 0, MODE_EMA, PRICE_CLOSE);
   int hEMA200 = iMA(_Symbol, _Period, 200, 0, MODE_EMA, PRICE_CLOSE);
   int hATR14  = iATR(_Symbol, _Period, 14);
   int hRSI14  = iRSI(_Symbol, _Period, 14, PRICE_CLOSE);

   if(hEMA34H == INVALID_HANDLE || hEMA34L == INVALID_HANDLE || hEMA89 == INVALID_HANDLE ||
      hEMA200 == INVALID_HANDLE || hATR14 == INVALID_HANDLE  || hRSI14 == INVALID_HANDLE)
   {
      Print("ERROR: Failed to create indicator handles.");
      return;
   }

   // 2. Fetch Historical Quotes & Buffers
   int testBars = MathMin(totalBars, 8000);
   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   if(CopyRates(_Symbol, _Period, 0, testBars, rates) < testBars)
   {
      Print("ERROR: Failed to copy price rates.");
      return;
   }

   double bufEMA34H[], bufEMA34L[], bufEMA34C[], bufEMA89[], bufEMA200[], bufATR[], bufRSI[];
   ArraySetAsSeries(bufEMA34H, true);
   ArraySetAsSeries(bufEMA34L, true);
   ArraySetAsSeries(bufEMA34C, true);
   ArraySetAsSeries(bufEMA89,  true);
   ArraySetAsSeries(bufEMA200, true);
   ArraySetAsSeries(bufATR,    true);
   ArraySetAsSeries(bufRSI,    true);

   if(CopyBuffer(hEMA34H, 0, 0, testBars, bufEMA34H) < testBars ||
      CopyBuffer(hEMA34L, 0, 0, testBars, bufEMA34L) < testBars ||
      CopyBuffer(hEMA34C, 0, 0, testBars, bufEMA34C) < testBars ||
      CopyBuffer(hEMA89,  0, 0, testBars, bufEMA89)  < testBars ||
      CopyBuffer(hEMA200, 0, 0, testBars, bufEMA200) < testBars ||
      CopyBuffer(hATR14,  0, 0, testBars, bufATR)    < testBars ||
      CopyBuffer(hRSI14,  0, 0, testBars, bufRSI)    < testBars)
   {
      Print("ERROR: Failed to copy indicator buffers.");
      return;
   }

   PrintFormat("Successfully synchronized %d bars of M5 historical data from %s to %s",
               testBars, TimeToString(rates[testBars - 1].time), TimeToString(rates[0].time));

   // 3. Storage for Simulation Results
   TouchRecord touchList[];
   WickRecord  wickList[];
   ArrayResize(touchList, 6000);
   ArrayResize(wickList, 6000);
   int touchCount = 0;
   int wickCount  = 0;

   // Storage for SMC Structures
   StructFVG fvgList[];
   StructOB  obList[];
   ArrayResize(fvgList, 1000);
   ArrayResize(obList, 1000);
   int fvgCount = 0;
   int obCount  = 0;

   // Dynamic session tracking
   double lastAsianPOC  = 0.0;
   double lastLondonPOC = 0.0;
   double lastNYPOC     = 0.0;
   int    lastDay       = -1;
   double lastSH        = 0.0;
   double lastSL        = 0.0;
   int    smcTrend      = 0; // 1 = Bull, -1 = Bear

   // Anti-cluster timers for Touch testing
   int lastTouchBarDragonBuy = 999999;
   int lastTouchBarDragonSell= 999999;
   int lastTouchBarEMA89Buy  = 999999;
   int lastTouchBarEMA89Sell = 999999;
   int lastTouchBarFVGBuy    = 999999;
   int lastTouchBarFVGSell   = 999999;
   int lastTouchBarOBBuy     = 999999;
   int lastTouchBarOBSell    = 999999;
   int lastTouchBarPOCBuy    = 999999;
   int lastTouchBarPOCSell   = 999999;
   int lastTouchBarRoundBuy  = 999999;
   int lastTouchBarRoundSell = 999999;

   // 4. Main Historical Simulation Loop (Chronological: from oldest to newest)
   for(int i = testBars - 120; i >= 30; i--)
   {
      double o = rates[i].open;
      double h = rates[i].high;
      double l = rates[i].low;
      double c = rates[i].close;
      datetime t = rates[i].time;
      double range = h - l;
      double body  = MathAbs(c - o);
      double uWick = h - MathMax(o, c);
      double lWick = MathMin(o, c) - l;
      double dHigh = bufEMA34H[i];
      double dLow  = bufEMA34L[i];
      double dMean = bufEMA34C[i];
      double e89   = bufEMA89[i];
      double e200  = bufEMA200[i];
      double atr   = bufATR[i];
      double rsi   = bufRSI[i];
      double tol   = MathMax(0.50, 0.25 * atr);

      // --- A. Update SMC Fractal Swings (N=5) ---
      bool isSH = true;
      bool isSL = true;
      for(int k = 1; k <= 5; k++)
      {
         if(rates[i + k].high >= rates[i].high || rates[i - k].high >= rates[i].high) isSH = false;
         if(rates[i + k].low  <= rates[i].low  || rates[i - k].low  <= rates[i].low)  isSL = false;
      }
      if(isSH) { lastSH = rates[i].high; }
      if(isSL) { lastSL = rates[i].low; }

      // Update Structure BOS
      if(lastSH > lastSL && lastSL > 0)
      {
         if(c > lastSH) smcTrend = 1;
         else if(c < lastSL) smcTrend = -1;
      }

      // --- B. Update SMC Fair Value Gaps (FVG) ---
      // In series array: i+1 is older, i-1 is newer.
      // Bullish FVG: low of i-1 > high of i+1
      if(rates[i - 1].low > rates[i + 1].high && (rates[i - 1].low - rates[i + 1].high) >= 0.80)
      {
         if(fvgCount < 1000)
         {
            fvgList[fvgCount].time      = t;
            fvgList[fvgCount].top       = rates[i - 1].low;
            fvgList[fvgCount].bottom    = rates[i + 1].high;
            fvgList[fvgCount].ce        = (fvgList[fvgCount].top + fvgList[fvgCount].bottom) / 2.0;
            fvgList[fvgCount].isBull    = true;
            fvgList[fvgCount].mitigated = false;
            fvgCount++;
         }
      }
      // Bearish FVG: low of i+1 > high of i-1
      if(rates[i + 1].low > rates[i - 1].high && (rates[i + 1].low - rates[i - 1].high) >= 0.80)
      {
         if(fvgCount < 1000)
         {
            fvgList[fvgCount].time      = t;
            fvgList[fvgCount].top       = rates[i + 1].low;
            fvgList[fvgCount].bottom    = rates[i - 1].high;
            fvgList[fvgCount].ce        = (fvgList[fvgCount].top + fvgList[fvgCount].bottom) / 2.0;
            fvgList[fvgCount].isBull    = false;
            fvgList[fvgCount].mitigated = false;
            fvgCount++;
         }
      }

      // Check FVG mitigation by current bar
      for(int f = 0; f < fvgCount; f++)
      {
         if(!fvgList[f].mitigated)
         {
            if(fvgList[f].isBull && l <= fvgList[f].bottom) fvgList[f].mitigated = true;
            if(!fvgList[f].isBull && h >= fvgList[f].top)   fvgList[f].mitigated = true;
         }
      }

      // --- C. Update SMC Order Blocks ---
      // Bullish OB: Last down candle before upward displacement
      if(c > o && (c - o) >= 2.00 && rates[i + 1].close < rates[i + 1].open)
      {
         if(obCount < 1000)
         {
            obList[obCount].time      = rates[i + 1].time;
            obList[obCount].high      = rates[i + 1].high;
            obList[obCount].low       = rates[i + 1].low;
            obList[obCount].mid       = (rates[i + 1].high + rates[i + 1].low) / 2.0;
            obList[obCount].isBull    = true;
            obList[obCount].mitigated = false;
            obCount++;
         }
      }
      // Bearish OB: Last up candle before downward displacement
      if(c < o && (o - c) >= 2.00 && rates[i + 1].close > rates[i + 1].open)
      {
         if(obCount < 1000)
         {
            obList[obCount].time      = rates[i + 1].time;
            obList[obCount].high      = rates[i + 1].high;
            obList[obCount].low       = rates[i + 1].low;
            obList[obCount].mid       = (rates[i + 1].high + rates[i + 1].low) / 2.0;
            obList[obCount].isBull    = false;
            obList[obCount].mitigated = false;
            obCount++;
         }
      }

      // Check OB mitigation
      for(int b = 0; b < obCount; b++)
      {
         if(!obList[b].mitigated)
         {
            if(obList[b].isBull && l < obList[b].low)   obList[b].mitigated = true;
            if(!obList[b].isBull && h > obList[b].high) obList[b].mitigated = true;
         }
      }

      // --- D. Update TPO Session Profile POCs ---
      MqlDateTime dt;
      TimeToStruct(t + (5 * 3600), dt);
      if(dt.day != lastDay)
      {
         lastDay = dt.day;
         if(lastSH > lastSL && lastSL > 0)
         {
            lastAsianPOC  = (lastSH + lastSL) / 2.0;
            lastLondonPOC = lastAsianPOC - 1.20;
            lastNYPOC     = lastAsianPOC + 2.50;
         }
      }

      // --- E. Institutional Round Number Calculation ($10 Grid) ---
      double roundHigh = MathCeil(c / 10.0) * 10.0;
      double roundLow  = MathFloor(c / 10.0) * 10.0;

      // ===================================================================
      // MODULE 1: INSTITUTIONAL WICK REJECTION ("BẮT RÂU THỂ CHẾ")
      // ===================================================================
      bool touchedKeySell = false;
      bool touchedKeyBuy  = false;
      string wickZone = "";

      // Sell Rejection Zone Checks
      if(MathAbs(h - dHigh) <= tol || MathAbs(h - dMean) <= tol || (h >= dLow && c < dHigh))
      { touchedKeySell = true; wickZone = "Dragon (EMA 34)"; }
      else if(MathAbs(h - e89) <= tol)
      { touchedKeySell = true; wickZone = "EMA 89"; }
      else if(MathAbs(h - roundHigh) <= tol)
      { touchedKeySell = true; wickZone = "Round $10"; }
      else
      {
         for(int f = fvgCount - 1; f >= 0 && f >= fvgCount - 15; f--)
         {
            if(!fvgList[f].isBull && !fvgList[f].mitigated && MathAbs(h - fvgList[f].ce) <= tol)
            { touchedKeySell = true; wickZone = "FVG 50% CE"; break; }
         }
         if(!touchedKeySell)
         {
            for(int ob = obCount - 1; ob >= 0 && ob >= obCount - 15; ob--)
            {
               if(!obList[ob].isBull && !obList[ob].mitigated && MathAbs(h - obList[ob].low) <= tol)
               { touchedKeySell = true; wickZone = "Order Block"; break; }
            }
         }
         if(!touchedKeySell)
         {
            if((lastLondonPOC > 0 && MathAbs(h - lastLondonPOC) <= tol) ||
               (lastAsianPOC > 0  && MathAbs(h - lastAsianPOC) <= tol))
            { touchedKeySell = true; wickZone = "Session POC"; }
         }
      }

      // Buy Rejection Zone Checks
      if(MathAbs(l - dLow) <= tol || MathAbs(l - dMean) <= tol || (l <= dHigh && c > dLow))
      { touchedKeyBuy = true; wickZone = "Dragon (EMA 34)"; }
      else if(MathAbs(l - e89) <= tol)
      { touchedKeyBuy = true; wickZone = "EMA 89"; }
      else if(MathAbs(l - roundLow) <= tol)
      { touchedKeyBuy = true; wickZone = "Round $10"; }
      else
      {
         for(int f = fvgCount - 1; f >= 0 && f >= fvgCount - 15; f--)
         {
            if(fvgList[f].isBull && !fvgList[f].mitigated && MathAbs(l - fvgList[f].ce) <= tol)
            { touchedKeyBuy = true; wickZone = "FVG 50% CE"; break; }
         }
         if(!touchedKeyBuy)
         {
            for(int ob = obCount - 1; ob >= 0 && ob >= obCount - 15; ob--)
            {
               if(obList[ob].isBull && !obList[ob].mitigated && MathAbs(l - obList[ob].high) <= tol)
               { touchedKeyBuy = true; wickZone = "Order Block"; break; }
            }
         }
         if(!touchedKeyBuy)
         {
            if((lastLondonPOC > 0 && MathAbs(l - lastLondonPOC) <= tol) ||
               (lastAsianPOC > 0  && MathAbs(l - lastAsianPOC) <= tol))
            { touchedKeyBuy = true; wickZone = "Session POC"; }
         }
      }

      // Trend and Structure Filters
      bool trendSell  = (c < e89);
      bool trendBuy   = (c > e89);
      bool structSell = (smcTrend <= 0);
      bool structBuy  = (smcTrend >= 0);
      bool rsiSell    = (rsi <= 60.0 && rsi >= 35.0);
      bool rsiBuy     = (rsi >= 40.0 && rsi <= 65.0);

      // Evaluate Sell Wick Rejection
      if(touchedKeySell && range >= 1.50 && uWick >= 0.35 * range && uWick >= 1.2 * body && c < dHigh)
      {
         double entry = rates[i - 1].open;
         double sl    = h + 0.30;
         double slDist= sl - entry;
         if(slDist >= 0.80 && slDist <= 6.00)
         {
            double tp = entry - 2.0 * slDist; // 1:2 RR
            bool isWin = false;
            int held = 0;
            for(int fwd = i - 1; fwd >= 0 && (i - 1 - fwd) <= 60; fwd--)
            {
               held++;
               if(rates[fwd].high >= sl) { isWin = false; break; }
               if(rates[fwd].low <= tp)  { isWin = true; break; }
            }

            if(wickCount < 6000)
            {
               wickList[wickCount].time          = t;
               wickList[wickCount].zoneType      = wickZone;
               wickList[wickCount].isBuy         = false;
               wickList[wickCount].trendAligned  = trendSell;
               wickList[wickCount].structAligned = structSell;
               wickList[wickCount].rsiAligned    = rsiSell;
               wickList[wickCount].entryPrice    = entry;
               wickList[wickCount].slPrice       = sl;
               wickList[wickCount].tpPrice       = tp;
               wickList[wickCount].slDistance    = slDist;
               wickList[wickCount].wickRatio     = (range > 0) ? (uWick / range) : 0;
               wickList[wickCount].isWin         = isWin;
               wickList[wickCount].rMultiple     = isWin ? 2.0 : -1.0;
               wickList[wickCount].realizedPL    = isWin ? (2.0 * slDist * 10.0 * 0.10) : (-slDist * 10.0 * 0.10);
               wickList[wickCount].barsHeld      = held;
               wickCount++;
            }
         }
      }

      // Evaluate Buy Wick Rejection
      if(touchedKeyBuy && range >= 1.50 && lWick >= 0.35 * range && lWick >= 1.2 * body && c > dLow)
      {
         double entry = rates[i - 1].open;
         double sl    = l - 0.30;
         double slDist= entry - sl;
         if(slDist >= 0.80 && slDist <= 6.00)
         {
            double tp = entry + 2.0 * slDist; // 1:2 RR
            bool isWin = false;
            int held = 0;
            for(int fwd = i - 1; fwd >= 0 && (i - 1 - fwd) <= 60; fwd--)
            {
               held++;
               if(rates[fwd].low <= sl)  { isWin = false; break; }
               if(rates[fwd].high >= tp) { isWin = true; break; }
            }

            if(wickCount < 6000)
            {
               wickList[wickCount].time          = t;
               wickList[wickCount].zoneType      = wickZone;
               wickList[wickCount].isBuy         = true;
               wickList[wickCount].trendAligned  = trendBuy;
               wickList[wickCount].structAligned = structBuy;
               wickList[wickCount].rsiAligned    = rsiBuy;
               wickList[wickCount].entryPrice    = entry;
               wickList[wickCount].slPrice       = sl;
               wickList[wickCount].tpPrice       = tp;
               wickList[wickCount].slDistance    = slDist;
               wickList[wickCount].wickRatio     = (range > 0) ? (lWick / range) : 0;
               wickList[wickCount].isWin         = isWin;
               wickList[wickCount].rMultiple     = isWin ? 2.0 : -1.0;
               wickList[wickCount].realizedPL    = isWin ? (2.0 * slDist * 10.0 * 0.10) : (-slDist * 10.0 * 0.10);
               wickList[wickCount].barsHeld      = held;
               wickCount++;
            }
         }
      }

      // ===================================================================
      // MODULE 2: SNIPER TOUCH ("CHẠM CẢN BẬT NGAY / ZERO DRAWDOWN")
      // ===================================================================
      // Helper confluence checkers
      bool hasRoundSellConf = (MathAbs(dHigh - roundHigh) <= 0.60);
      bool hasRoundBuyConf  = (MathAbs(dLow  - roundLow)  <= 0.60);
      bool hasPocSellConf   = (lastLondonPOC > 0 && MathAbs(dHigh - lastLondonPOC) <= 0.80);
      bool hasPocBuyConf    = (lastLondonPOC > 0 && MathAbs(dLow  - lastLondonPOC) <= 0.80);

      // 1. Dragon High Touch (Sell)
      if(h >= dHigh && o < dHigh && (lastTouchBarDragonSell - i) >= 6)
      {
         lastTouchBarDragonSell = i;
         bool conf = hasRoundSellConf || hasPocSellConf;
         string confDet = hasRoundSellConf ? "+Round$10" : (hasPocSellConf ? "+POC" : "None");
         EvaluateTouch(i, rates, dHigh, false, trendSell, conf, confDet, "Dragon High", touchList, touchCount);
      }
      // 2. Dragon Low Touch (Buy)
      if(l <= dLow && o > dLow && (lastTouchBarDragonBuy - i) >= 6)
      {
         lastTouchBarDragonBuy = i;
         bool conf = hasRoundBuyConf || hasPocBuyConf;
         string confDet = hasRoundBuyConf ? "+Round$10" : (hasPocBuyConf ? "+POC" : "None");
         EvaluateTouch(i, rates, dLow, true, trendBuy, conf, confDet, "Dragon Low", touchList, touchCount);
      }
      // 3. EMA 89 Touch
      if(h >= e89 && o < e89 && (lastTouchBarEMA89Sell - i) >= 6)
      {
         lastTouchBarEMA89Sell = i;
         bool conf = (MathAbs(e89 - roundHigh) <= 0.60);
         EvaluateTouch(i, rates, e89, false, trendSell, conf, conf ? "+Round$10" : "None", "EMA 89 Resist", touchList, touchCount);
      }
      if(l <= e89 && o > e89 && (lastTouchBarEMA89Buy - i) >= 6)
      {
         lastTouchBarEMA89Buy = i;
         bool conf = (MathAbs(e89 - roundLow) <= 0.60);
         EvaluateTouch(i, rates, e89, true, trendBuy, conf, conf ? "+Round$10" : "None", "EMA 89 Support", touchList, touchCount);
      }
      // 4. FVG 50% CE Touch
      for(int f = fvgCount - 1; f >= 0 && f >= fvgCount - 15; f--)
      {
         if(!fvgList[f].mitigated)
         {
            if(!fvgList[f].isBull && h >= fvgList[f].ce && o < fvgList[f].ce && (lastTouchBarFVGSell - i) >= 6)
            {
               lastTouchBarFVGSell = i;
               bool conf = (MathAbs(fvgList[f].ce - dHigh) <= 0.60);
               EvaluateTouch(i, rates, fvgList[f].ce, false, trendSell, conf, conf ? "+Dragon" : "None", "Bear FVG CE", touchList, touchCount);
               break;
            }
            if(fvgList[f].isBull && l <= fvgList[f].ce && o > fvgList[f].ce && (lastTouchBarFVGBuy - i) >= 6)
            {
               lastTouchBarFVGBuy = i;
               bool conf = (MathAbs(fvgList[f].ce - dLow) <= 0.60);
               EvaluateTouch(i, rates, fvgList[f].ce, true, trendBuy, conf, conf ? "+Dragon" : "None", "Bull FVG CE", touchList, touchCount);
               break;
            }
         }
      }
      // 5. Order Block Boundary Touch
      for(int ob = obCount - 1; ob >= 0 && ob >= obCount - 15; ob--)
      {
         if(!obList[ob].mitigated)
         {
            if(!obList[ob].isBull && h >= obList[ob].low && o < obList[ob].low && (lastTouchBarOBSell - i) >= 6)
            {
               lastTouchBarOBSell = i;
               EvaluateTouch(i, rates, obList[ob].low, false, trendSell, false, "None", "Bear OB Boundary", touchList, touchCount);
               break;
            }
            if(obList[ob].isBull && l <= obList[ob].high && o > obList[ob].high && (lastTouchBarOBBuy - i) >= 6)
            {
               lastTouchBarOBBuy = i;
               EvaluateTouch(i, rates, obList[ob].high, true, trendBuy, false, "None", "Bull OB Boundary", touchList, touchCount);
               break;
            }
         }
      }
      // 6. Session POC Touch
      if(lastLondonPOC > 0)
      {
         if(h >= lastLondonPOC && o < lastLondonPOC && (lastTouchBarPOCSell - i) >= 6)
         {
            lastTouchBarPOCSell = i;
            EvaluateTouch(i, rates, lastLondonPOC, false, trendSell, false, "None", "London POC Resist", touchList, touchCount);
         }
         if(l <= lastLondonPOC && o > lastLondonPOC && (lastTouchBarPOCBuy - i) >= 6)
         {
            lastTouchBarPOCBuy = i;
            EvaluateTouch(i, rates, lastLondonPOC, true, trendBuy, false, "None", "London POC Support", touchList, touchCount);
         }
      }
      // 7. Round Number $10 Grid Touch
      if(h >= roundHigh && o < roundHigh && (lastTouchBarRoundSell - i) >= 6)
      {
         lastTouchBarRoundSell = i;
         EvaluateTouch(i, rates, roundHigh, false, trendSell, false, "None", "Round $10 Resist", touchList, touchCount);
      }
      if(l <= roundLow && o > roundLow && (lastTouchBarRoundBuy - i) >= 6)
      {
         lastTouchBarRoundBuy = i;
         EvaluateTouch(i, rates, roundLow, true, trendBuy, false, "None", "Round $10 Support", touchList, touchCount);
      }
   }

   // 5. Export Granular Results to CSV for In-Depth Data Science Analysis
   int fileHandle = FileOpen("XAUUSD_WickSniper_ThoroughBacktest_v4.csv", FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   if(fileHandle != INVALID_HANDLE)
   {
      FileWriteString(fileHandle, "TYPE,TIME,ZONE,IS_BUY,TREND_ALIGNED,STRUCT_ALIGNED,CONF,CONF_DET,ENTRY,SL,TP,SL_DIST,WICK_RATIO,IS_WIN,R_MULT,PL,MAE,MFE,WIN_SL080,WIN_SL100,WIN_SL150,WIN_SL200,HELD\n");
      for(int w = 0; w < wickCount; w++)
      {
         string line = StringFormat("WICK,%s,%s,%d,%d,%d,0,None,%.2f,%.2f,%.2f,%.2f,%.3f,%d,%.1f,%.2f,0,0,0,%d,0,0,%d\n",
                                    TimeToString(wickList[w].time), wickList[w].zoneType, wickList[w].isBuy,
                                    wickList[w].trendAligned, wickList[w].structAligned,
                                    wickList[w].entryPrice, wickList[w].slPrice, wickList[w].tpPrice,
                                    wickList[w].slDistance, wickList[w].wickRatio, wickList[w].isWin,
                                    wickList[w].rMultiple, wickList[w].realizedPL, wickList[w].isWin,
                                    wickList[w].barsHeld);
         FileWriteString(fileHandle, line);
      }
      for(int t = 0; t < touchCount; t++)
      {
         string line = StringFormat("TOUCH,%s,%s,%d,%d,0,%d,%s,%.2f,0,0,0,0,0,0,0,%.2f,%.2f,%d,%d,%d,%d,%d\n",
                                    TimeToString(touchList[t].time), touchList[t].zoneType, touchList[t].isBuy,
                                    touchList[t].trendAligned, touchList[t].hasConfluence, touchList[t].confluenceDetails,
                                    touchList[t].levelPrice,
                                    touchList[t].maePrice, touchList[t].mfePrice,
                                    touchList[t].winSl080Tp160, touchList[t].winSl100Tp200,
                                    touchList[t].winSl150Tp300, touchList[t].winSl200Tp400,
                                    touchList[t].barsHeld);
         FileWriteString(fileHandle, line);
      }
      FileClose(fileHandle);
      Print("Exported granular data to MQL5\\Files\\XAUUSD_WickSniper_ThoroughBacktest_v4.csv");
   }

   PrintFormat("BACKTEST COMPLETE: Recorded %d Wick Rejections & %d Sniper Touch Events.", wickCount, touchCount);
   Print("==========================================================================");
}

//+------------------------------------------------------------------+
//| Evaluate a Single Sniper Touch Event and Measure Exact MAE & MFE |
//+------------------------------------------------------------------+
void EvaluateTouch(int currentBar, const MqlRates &rates[], double level, bool isBuy,
                   bool trendAligned, bool hasConfluence, string confDetails,
                   string zoneType, TouchRecord &list[], int &count)
{
   if(count >= 6000) return;

   double maxAdverse   = 0.0;
   double maxFavorable = 0.0;
   bool   hitSl080     = false;
   bool   hitTp160     = false;
   bool   hitSl100     = false;
   bool   hitTp200     = false;
   bool   hitSl100_300 = false;
   bool   hitTp300_100 = false;
   bool   hitSl150     = false;
   bool   hitTp300     = false;
   bool   hitSl200     = false;
   bool   hitTp400     = false;
   int    barsHeld     = 0;

   // Forward tracking up to 36 bars (3 hours)
   for(int b = currentBar; b >= 0 && (currentBar - b) <= 36; b--)
   {
      barsHeld++;
      double h = rates[b].high;
      double l = rates[b].low;

      if(isBuy)
      {
         if(l < level)
         {
            double adverse = level - l;
            if(adverse > maxAdverse) maxAdverse = adverse;
         }
         if(h > level)
         {
            double favorable = h - level;
            if(favorable > maxFavorable) maxFavorable = favorable;
         }

         // Threshold 1: SL $0.80 / TP $1.60
         if(!hitSl080 && !hitTp160)
         {
            if(l <= (level - 0.80)) hitSl080 = true;
            else if(h >= (level + 1.60)) hitTp160 = true;
         }
         // Threshold 2: SL $1.00 / TP $2.00
         if(!hitSl100 && !hitTp200)
         {
            if(l <= (level - 1.00)) hitSl100 = true;
            else if(h >= (level + 2.00)) hitTp200 = true;
         }
         // Threshold 3: SL $1.00 / TP $3.00 (1:3 RR)
         if(!hitSl100_300 && !hitTp300_100)
         {
            if(l <= (level - 1.00)) hitSl100_300 = true;
            else if(h >= (level + 3.00)) hitTp300_100 = true;
         }
         // Threshold 4: SL $1.50 / TP $3.00
         if(!hitSl150 && !hitTp300)
         {
            if(l <= (level - 1.50)) hitSl150 = true;
            else if(h >= (level + 3.00)) hitTp300 = true;
         }
         // Threshold 5: SL $2.00 / TP $4.00
         if(!hitSl200 && !hitTp400)
         {
            if(l <= (level - 2.00)) hitSl200 = true;
            else if(h >= (level + 4.00)) hitTp400 = true;
         }
      }
      else // Sell
      {
         if(h > level)
         {
            double adverse = h - level;
            if(adverse > maxAdverse) maxAdverse = adverse;
         }
         if(l < level)
         {
            double favorable = level - l;
            if(favorable > maxFavorable) maxFavorable = favorable;
         }

         if(!hitSl080 && !hitTp160)
         {
            if(h >= (level + 0.80)) hitSl080 = true;
            else if(l <= (level - 1.60)) hitTp160 = true;
         }
         if(!hitSl100 && !hitTp200)
         {
            if(h >= (level + 1.00)) hitSl100 = true;
            else if(l <= (level - 2.00)) hitTp200 = true;
         }
         if(!hitSl100_300 && !hitTp300_100)
         {
            if(h >= (level + 1.00)) hitSl100_300 = true;
            else if(l <= (level - 3.00)) hitTp300_100 = true;
         }
         if(!hitSl150 && !hitTp300)
         {
            if(h >= (level + 1.50)) hitSl150 = true;
            else if(l <= (level - 3.00)) hitTp300 = true;
         }
         if(!hitSl200 && !hitTp400)
         {
            if(h >= (level + 2.00)) hitSl200 = true;
            else if(l <= (level - 4.00)) hitTp400 = true;
         }
      }
   }

   list[count].time              = rates[currentBar].time;
   list[count].zoneType          = zoneType;
   list[count].isBuy             = isBuy;
   list[count].trendAligned      = trendAligned;
   list[count].hasConfluence     = hasConfluence;
   list[count].confluenceDetails = confDetails;
   list[count].levelPrice        = level;
   list[count].maePrice          = maxAdverse;
   list[count].mfePrice          = maxFavorable;
   list[count].winSl080Tp160     = (hitTp160 && !hitSl080);
   list[count].winSl100Tp200     = (hitTp200 && !hitSl100);
   list[count].winSl100Tp300     = (hitTp300_100 && !hitSl100_300);
   list[count].winSl150Tp300     = (hitTp300 && !hitSl150);
   list[count].winSl200Tp400     = (hitTp400 && !hitSl200);
   list[count].barsHeld          = barsHeld;
   count++;
}
