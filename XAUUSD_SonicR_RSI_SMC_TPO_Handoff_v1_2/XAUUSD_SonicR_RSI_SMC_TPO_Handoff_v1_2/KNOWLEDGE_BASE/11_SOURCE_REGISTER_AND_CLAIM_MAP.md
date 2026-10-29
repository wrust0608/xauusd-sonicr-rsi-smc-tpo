# 11 — SOURCE REGISTER, PROVENANCE AND CLAIM MAP

**Review date:** 2026-10-29. The agent must re-check live vendor documentation before implementation because APIs and hosted runtimes can change.

## Primary and official sources

### [S1] Sonicdeejay — original Sonic R. System thread
URL: https://www.forexfactory.com/thread/114792-sonic-r-system  
Type: Primary method-origin community source.  
Supports: the method's origin, the author's description of the classic setup, price-action waves, Dragon, support/resistance, and the warning not to treat indicators as a perfect predictor.  
Does not prove: profitability, universality, statistical win rate on XAUUSD, or the exact formulas for every project-specific adaptation.

### [S2] Traderathome discussion within Sonic R. thread
URL: https://www.forexfactory.com/thread/114792-sonic-r-system?page=1042  
Type: Method-author/community explanation.  
Supports: an explanation that the classic Sonic R. setup emphasizes a price-action wave and support/resistance, that the Dragon is used as an entry-area reference, and that the 89 EMA is not mandatory in all interpretations of the original method.  
Does not prove: every code condition used in this project.

### [S3] J. Welles Wilder Jr., *New Concepts in Technical Trading Systems* (1978)
Bibliographic reference: https://books.google.com/books?vid=ISBN0894590278  
Type: Original publication bibliographic source.  
Supports: RSI's historical origin in Wilder's technical-analysis work. Use accessible formula references below for exact formula details unless the book itself is available to the agent.

### [S4] TradingView — Relative Strength Index
URL: https://www.tradingview.com/support/solutions/43000502338-relative-strength-index-rsi/  
Type: Vendor technical documentation.  
Supports: RSI formula, close-based gains/losses and RMA/Wilder smoothing explanation.  
Caution: details of seed/warm-up can vary between platforms; verify the target library.

### [S5] TakeProfit Indie — plotting API
URL: https://takeprofit.com/docs/indie/Library-reference/package-indie-plot  
Type: Official API documentation.  
Supports: documented plot styles, decorator signatures and returned plot objects at the time reviewed.

### [S6] TakeProfit Indie — algorithms library
URL: https://takeprofit.com/docs/indie/Library-reference/package-indie-algorithms  
Type: Official API documentation.  
Supports: documented `Rsi` algorithm and moving-average algorithms including `Ma` choices.  
Caution: this does not prove numerical parity with another platform or availability in the Exness-hosted runtime.

### [S7] LuxAlgo — Smart Money Concepts [SMC] public script
URL: https://www.tradingview.com/script/CnB3fSph-Smart-Money-Concepts-SMC-LuxAlgo/  
Type: Third-party SMC implementation.  
Supports: an example feature inventory (internal/swing structure, BOS/CHoCH, order blocks, premium/discount, equal highs/lows, FVG).  
Does not define the user's original `SC_MarketStructure.ex5`.

### [S8] Quantum Algo — open source SMC indicator repository
URL: https://github.com/quantumalgo-official/smart-money-concepts-indicator  
Type: Third-party open-source implementation.  
Supports: another example of common SMC feature vocabulary and one author's implementation choices.  
Does not define a universal SMC standard or the user's binary.

### [S9] Additional published SMC indicator / implementation examples
Example: https://www.tradingview.com/script/7V7rJ3uC-TrendViz-Smart-Money-Concepts/  
Type: Third-party implementation descriptions.  
Supports: the fact that implementations expose different parameters and mitigation/confirmation options.  
Does not define the user's source logic.

### [S10] CQG — Market Profile (MP) help
URL: https://help.cqg.com/cqgic/25/Documents/marketprofilemp.htm  
Type: Platform documentation.  
Supports: TPO as a time-price opportunity representation, including that a TPO letter identifies a time when the market traded at a price.  
Does not define the user's MT5 TPO algorithm.

### [S11] TakeProfit Indie — drawing package (`BlockProfile`)
URL: https://takeprofit.com/docs/indie/Library-reference/package-indie-drawings  
Type: Official API documentation.  
Supports: documented `BlockProfile` drawing representation with row size, time interval, columns/cells, named levels, palette and clear operations in the TakeProfit Indie docs.  
Does not prove: availability or identical behavior in Exness's hosted Indie runtime; nor does it provide an automatic TPO counting algorithm.

### [S12] Exness — Custom indicators in Exness Terminal
URL: https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal  
Type: Official platform support documentation.  
Supports: Exness Terminal Web custom indicators use Indie; gives intended deployment/test steps.  
Caution: feature support and exact runtime version should be checked in the user's actual terminal.

### [S13] MetaTrader 5 MetaEditor — Compilation
URL: https://www.metatrader5.com/en/metaeditor/help/development/compile  
Type: Official platform documentation.  
Supports: EX5/EX4 are compiled executable files; the original algorithm is hidden, and debugging without source is not available in the usual source workflow.

### [S14] TakeProfit Indie — Quick start / code execution
URL: https://takeprofit.com/docs/indie/Quick-start  
Type: Official API documentation.  
Supports: `Main` is the indicator entry point; docs describe it being called for historical candles and updated for the current realtime candle.

### [S15] TakeProfit Indie — package `indie`
URL: https://takeprofit.com/docs/indie/Library-reference/package-indie  
Type: Official API documentation.  
Supports: context series/time fields, `bar_index`, `bar_count`, `is_closed_bar`, `is_history`, `is_last_bar`, `is_new_bar`, `is_realtime`, and `calc_on` API as documented.

### [S16] TakeProfit Indie — Request additional instruments
URL: https://takeprofit.com/docs/indie/Request-additional-instruments  
Type: Official API documentation.  
Supports: `@sec_context`, `Context.calc_on`, secondary timeframes and the requirement to call `calc_on` from `__init__`.  
Caution: current hosted engine support (especially lower timeframes) must be checked in Exness.

### [S17] TakeProfit Indie — changelog
URL: https://takeprofit.com/docs/indie/Changelog  
Type: Official product/version documentation.  
Supports: the changelog reports lower-timeframe `calc_on` support from Indie v5.14.0.  
Caution: the user's Exness runtime version must be checked before relying on this.

### [S18] MetaTrader 5 — Timeseries and indicator data
URLs: https://www.mql5.com/en/docs/series and https://www.mql5.com/en/docs/series/copybuffer  
Type: Official MQL5 documentation.  
Supports: MT5 series and `CopyBuffer` semantics for understanding source context if MQL5 code is provided.  
Caution: MQL5 indexing rules must not be transplanted directly into Indie code.

### [S19] TakeProfit Indie — Time Price Opportunity profiles in Indie
URL: https://takeprofit.com/docs/indie/Profile-data/TPO-profiles  
Type: Official API documentation (TakeProfit Indie native profile data).  
Supports: `sources.Tpo()` and `request_series[TpoProfile]` native data descriptor; `TpoProfile` fields: `point_of_control`, `initial_balance_high`, `initial_balance_low`, `row_size`, price rows, and block metadata (`row.block_indexes`); documents that VAH/VAL are not provided natively and must be programmatically derived from rows (e.g. 70% expansion from POC).  
Caution: proves existence in TakeProfit platform/docs; does NOT prove Exness Terminal Web hosted runtime has enabled this API (`RUNTIME_REQUIRED`). Does not match user's custom Vietnamese 3-session schedule by default (merges main, pre, post market by default).

### [S20] TakeProfit Indie — Package `indie.data`
URL: https://takeprofit.com/docs/indie/Library-reference/package-indie-data  
Type: Official API documentation.  
Supports: types and exports in `indie.data`, including `TpoProfile`, `sources.Tpo`, `request_series`.  
Caution: availability in Exness-hosted runtime remains `RUNTIME_REQUIRED`.

### [S21] TakeProfit — Guide Changelog (TPO profile feature addition)
URL: https://takeprofit.com/docs/guide/changelog  
Type: Official product/version changelog.  
Supports: records addition of native TPO profile data support in Indie (September 2026 update).  
Caution: Exness hosted engine version must be verified before relying on this feature.

## User-supplied source artifacts

### [U1] `SC_MarketStructure.ex5`
Type: Compiled MT5 indicator supplied by the user.  
Supports: only that a file by this name/format was supplied.  
Does not reveal its feature list or source algorithm.

### [U2] `TPO_Session_v1.01.zip` / `HUONG_DAN.txt`
Type: User-supplied archive with `TPO Session.ex5` and a Vietnamese user guide.  
Supports: exact contents of the guide: default row-size arithmetic, described server clock modes and named session schedule.  
Does not reveal the complete calculation algorithm or all rendered profile levels.

### [U3] Project knowledge and source archive
Files in `source_archive/` and `reference/`.  
Supports: prior project decisions, historical research, code snapshots and claimed tests; each claim still needs its original evidence class. Do not silently convert a historical report's claim into an independently verified fact.

## Claim-to-source map

| Claim | Label | Source |
|---|---|---|
| Exness Web custom indicators are Indie-based | OFFICIAL_API_DOC | S12 |
| EX5 is compiled and hides original algorithm | OFFICIAL_API_DOC | S13 |
| Sonic R. emphasizes price-action wave / S&R / Dragon; not simply a MA cross | PRIMARY_SOURCE | S1, S2 |
| RSI formula uses average gains/losses and Wilder/RMA smoothing | SECONDARY_SOURCE/VENDOR DOC | S4, verified against target library later |
| MTF `calc_on` exists in Indie docs; context data is merged | OFFICIAL_API_DOC | S15, S16 |
| `BlockProfile` is documented by TakeProfit | OFFICIAL_API_DOC | S11; `RUNTIME_REQUIRED` for Exness |
| Native `sources.Tpo()` & `TpoProfile` data API documented | OFFICIAL_API_DOC | S19, S20, S21; `RUNTIME_REQUIRED` for Exness |
| `TpoProfile` provides POC, IB high/low; VAH/VAL require manual derivation | OFFICIAL_API_DOC | S19 |
| TPO session schedule and 1.2 row size in the supplied TPO guide | USER_ARTIFACT | U2 |
| User's SMC supports BOS/CHoCH/FVG/OB | UNKNOWN | Source required; U1 insufficient |
| User's TPO supports POC/VAH/VAL/IB | UNKNOWN | U2 insufficient |
| Exact Exness runtime accepts every documented API | RUNTIME_REQUIRED | Must test actual environment |
| Indicator is profitable or predicts direction reliably | NOT ESTABLISHED | No source in this pack establishes it |
