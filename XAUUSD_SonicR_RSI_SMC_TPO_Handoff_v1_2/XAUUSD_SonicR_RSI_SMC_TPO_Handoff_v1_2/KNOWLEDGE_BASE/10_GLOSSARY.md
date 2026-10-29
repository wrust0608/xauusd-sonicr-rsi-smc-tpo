# 10 — PROJECT GLOSSARY

| Term | Meaning in this project | Key caution |
|---|---|---|
| Indie | TakeProfit's indicator scripting language used by the target Exness web custom-indicator feature | Not general-purpose Python, Pine Script or MQL5. |
| EX5 | Compiled MetaTrader 5 executable | Not the original source; do not infer logic from it. |
| Source port | Translation from inspectable `.mq5/.mqh` source to Indie | Requires source and target-runtime verification. |
| Behavioral reimplementation | A new implementation based on verified input/output behavior and specification | Must not be called a source-identical port. |
| Dragon | Project EMA34 High/Close/Low band | Historical method term; project formula is the locked build. |
| Trend Line | Project EMA89 Close reference | Original method source says it is useful, but not universally mandatory as a hard filter. |
| PA wave | Price-action wave/sequence | Must specify pivot algorithm, sequence and confirmation time. |
| RSI | Wilder-style momentum oscillator based on changes in close prices | Output depends on initialization and smoothing. |
| EMA9(RSI) | EMA of the RSI14 series, length 9 | Not EMA of XAUUSD price. |
| WMA45(RSI) | WMA of the RSI14 series, length 45 | Not WMA of XAUUSD price. |
| HTF / LTF | Higher/lower timeframe relative to the chart or trigger | State the reference timeframe explicitly. |
| MTF | Multi-timeframe calculation | Merged series alignment must be tested at candle boundaries. |
| Pivot confirmation | Time when required right-side bars make a pivot knowable | Not the same as the pivot's historical anchor. |
| Repaint | A display/calculation changes past or provisional outputs after later updates | Specify the exact behavior and test scope instead of using a vague yes/no. |
| BOS | Common SMC term: break of a selected structural level in trend | Close-vs-wick, swing source and trend state vary by implementation. |
| CHoCH | Common SMC term: first chosen structure break against the prior direction | Not proof of reversal; exact protected swing logic varies. |
| MSS | A term sometimes used for a structure shift with displacement | Definitions vary; don't merge with BOS/CHoCH by assumption. |
| FVG | Common three-candle price gap/imbalance convention | Candle indexing, wick/body, size filter and lifecycle vary. |
| OB | Order block zone according to a chosen SMC convention | Source-specific boundaries and invalidation must be preserved. |
| EQH / EQL | Equal highs / equal lows within a stated tolerance | Tolerance/clustering are algorithmic choices. |
| TPO | Time Price Opportunity; price row visited during a defined time bracket | Not volume traded at price. |
| TPO row height | Price width per profile row | Needs a grid-origin and edge-inclusion rule as well as a width. |
| Volume Profile | Distribution of volume by price | Different from TPO counts by time bracket. |
| POC | Usually the row with greatest profile count/volume, depending profile type | Not assumed to exist in the supplied TPO tool. |
| VAH / VAL | Value-area high/low under a specified value-area method | Calculation and tie rules must be known. |
| DST | Daylight saving time | Region switch dates can differ; test session conversions around them. |
| Context layer | Independent visual information used by the user to interpret price | Does not automatically filter or trigger a setup. |
| Core script | One of the two original Sonic R./RSI scripts | Each has a <=128 physical-line cap. |
