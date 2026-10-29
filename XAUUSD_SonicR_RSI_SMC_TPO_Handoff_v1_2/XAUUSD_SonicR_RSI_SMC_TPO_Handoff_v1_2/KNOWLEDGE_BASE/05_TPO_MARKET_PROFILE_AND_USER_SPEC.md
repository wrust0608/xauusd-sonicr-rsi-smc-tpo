# 05 — TPO / MARKET PROFILE: THEORY, ORIGINAL USER MANUAL AND LIMITS

## 1. What TPO measures

TPO means **Time Price Opportunity**. In a conventional TPO/Market Profile display, a time bracket is represented at each price row the market traded during that bracket. A cell therefore records that a price area was visited during a time slice; it is not, by itself, the traded volume at that price. A volume profile aggregates volume by price and is a different data model. A platform can render both types of distribution, but their counts and interpretations must not be mixed.

CQG's Market Profile documentation says a TPO distribution is constructed of TPOs and that each TPO letter identifies a time when the market traded at the price indicated on the vertical axis [S10]. This supports the general idea only; it does not specify the algorithm in the user's TPO Session indicator.

## 2. Terms frequently seen in Market Profile — not assumed outputs of the user's indicator

- **TPO row size:** the price height represented by one profile row.
- **TPO period/bracket:** the interval of time that defines one column/opportunity grouping.
- **POC:** point of control, commonly the row with the greatest TPO count in a TPO profile. Tie-breaking rules can vary.
- **Value Area / VAH / VAL:** a profile region and its high/low boundaries under a chosen value-area percentage and expansion algorithm. Exact calculations and tie rules must be specified.
- **Initial Balance (IB):** range formed over a defined initial part of a session; the time interval is configurable by market/session convention.
- **Single prints / poor highs-lows / excess:** profile-specific structures with multiple definitions and thresholds.

These are vocabulary to understand if encountered. The supplied `TPO Session.ex5` + manual do not by themselves prove which of these outputs it calculates or displays. Keep them `UNKNOWN` until observed or source-confirmed.

## 3. Exact facts from the user's supplied `HUONG_DAN.txt`

The file inside `TPO_Session_v1.01.zip` says:

- Product: “TPO Session v1.01 — Market Profile / TPO theo phiên cho MetaTrader 5.”
- Recommended chart: XAUUSD, M30.
- For XAUUSD, the stated defaults are `InpTickSize = 0.1` and `InpTicksPerRow = 12`, so one row equals `1.2` price units (`0.1 × 12`).
- Setting `InpTickSize = 0` is described as using the symbol tick size, after which `InpTicksPerRow` may be adjusted; alternatively one can set `InpRowHeight` directly.
- `InpServerClock` default is described as automatic. The guide says server UTC+0 (example: Exness) needs no manual shift, while UTC+2 winter / UTC+3 summer servers should use automatic US DST adjustment; other modes include fixed clock, US changeover and European changeover.
- `InpTimeShiftHours` is described as Vietnam time minus server time in winter; the example for UTC+2/UTC+3 is 5 hours.
- Session schedule as written in Vietnam time:
  - **S1 A:** 06:00–14:59 in winter; 06:00–13:59 in summer.
  - **S2 Au:** 15:00–19:59 in winter; 14:00–18:59 in summer.
  - **S3 My:** 20:00–05:59 in winter; 19:00–05:59 in summer.
- Version notes say v1.01 added automatic server clock and corrected a one-hour summer-time offset for Au/My.

These are `USER_ARTIFACT` facts about what the guide states, not independent proof the algorithm is correct for every current broker/server or that the user's live chart uses those settings.

## 4. Core arithmetic and data questions to resolve

The manual's XAUUSD example implies `row_height = 0.1 × 12 = 1.2`. Before porting, determine whether the actual instrument tick size/contract point on the target matches the guide assumption. Do not confuse symbol `tick size`, display digits, point size, pip convention and a profile row. They are not necessarily identical.

The following details are still unknown without source or observation:

- What bar/time resolution is used to determine whether a row was visited during a TPO period?
- If one candle spans multiple rows, are all rows it intersects counted, only close-derived rows, or something else?
- How are bar timestamps assigned to periods and sessions?
- How are missing bars, weekends, maintenance pauses and session gaps handled?
- Is each TPO-period/row counted once, or can multiple candles within a period create duplicate counts?
- What exactly is drawn for each session and whether historical sessions persist.
- What algorithm creates any POC/VAH/VAL/IB level if the indicator has them.
- How the profile is refreshed, invalidated or rebuilt on history reload.

A correct-looking profile on one static chart does not answer all these questions.

## 5. Session and DST policy

The supplied guide contains a session schedule and modes for server clock changes. A port must explicitly identify its timezone basis and convert timestamps to it. Do not assume a fixed offset suffices across DST transitions. Do not equate the PC clock, chart display clock, server clock and Vietnam local time without verifying each one.

Test at least:

- Each session open and close, the bar immediately before and after it.
- Every pair of adjacent session boundaries.
- Both US and European DST transition periods, including the weeks when the two regions switch on different dates.
- A Sunday/opening gap or weekend boundary where relevant.
- Reload and historical scroll across session changes.
- A date on each side of a switch where the configured server mode changes the local session clock.

The test oracle must specify the expected timestamp and session label, not merely “looks about right”.

## 6. TPO in Indie: Drawing primitive vs Native profile data API

TakeProfit Indie documentation describes two distinct mechanisms related to TPO profiles:

1. **Drawing object — `indie.drawings.BlockProfile` [S11]:**
   A visual rendering primitive providing a grid of price rows against time columns. Documented fields include `row_size`, `time_from`, `time_to`; methods include `add_column`, `add_cell`, `add_level`, `set_palette`, `clear`, `is_empty`. This is a tool to draw blocks/cells onto the chart; it does not compute TPO distribution or identify POC.

2. **Native profile data API — `sources.Tpo()` and `TpoProfile` (`indie.data`) [S19, S20, S21]:**
   Documented in TakeProfit Indie (added in the September 2026 update). It allows requesting structured TPO profile series using `request_series[TpoProfile](source=sources.Tpo(...), time_frame=...)`.
   - **Available fields on `TpoProfile`:** `point_of_control`, `initial_balance_high`, `initial_balance_low`, `row_size`, price rows, and block metadata (`row.block_indexes`, `len(row.block_indexes)`).
   - **Configuration options on `sources.Tpo()`:** `block_size` (e.g. 30m), `row_size_ticks`, and session grouping. By default, it merges main session, pre-market, and post-market into a single daily profile.
   - **Crucial limitation regarding VAH / VAL:** The raw `TpoProfile` object does **NOT** provide pre-calculated `value_area_high` (VAH), `value_area_low` (VAL), or a value-area ratio. The TakeProfit documentation explicitly explains that VAH and VAL must be programmatically derived by expanding outward from `point_of_control`, comparing neighboring price rows and accumulating TPO counts until reaching the desired threshold (typically 70%).

**Crucial Platform Boundary (TakeProfit vs Exness):**
Both `BlockProfile` and `sources.Tpo()` are documented in TakeProfit's upstream documentation. However, Exness Terminal Web operates an embedded, hosted Indie runtime. Whether Exness has enabled either `BlockProfile` or `indie.data.sources.Tpo()` is strictly `RUNTIME_REQUIRED` and requires a separate isolated smoke test once authorized by the manager.

Furthermore, native `sources.Tpo()` does not automatically substitute the user's specific indicator: its default session grouping does not match the user's custom Vietnamese 3-session schedule (S1 Asia, S2 Europe, S3 US overnight), nor does it guarantee the user's exact XAUUSD row binning and boundary assignment. Do not replace the user's specified indicator behavior solely because a native platform API exists.

## 7. TPO feature policy for this project

Initial goal: replicate only output proved to exist in the user's original TPO, with its documented row/session/time settings. Do not add POC, VAH/VAL, IB, single prints, volume delta, volume profile, alerts or trade filters unless the original source proves those outputs or the manager approves a new feature spec.
