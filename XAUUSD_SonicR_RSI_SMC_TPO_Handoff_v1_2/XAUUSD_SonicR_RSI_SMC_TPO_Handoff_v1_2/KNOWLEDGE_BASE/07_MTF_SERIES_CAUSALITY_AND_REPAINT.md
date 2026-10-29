# 07 — MULTI-TIMEFRAME SERIES, CAUSALITY, PIVOT LAG AND REPAINTING

## 1. Define the event time, not only the drawing location

For every signal-like visual element, record three times separately:

1. **Anchor time:** the historical candle/price where the feature is drawn.
2. **Confirmation time:** when enough information exists to confirm it.
3. **Availability time:** the earliest time the user could have known the confirmed event in live operation.

This distinction is critical for pivots, swings, divergence and market structure. If a swing pivot at bar `k` requires `R` bars to its right, the pivot is not confirmed until those right-side bars close. A line drawn back at `k` after confirmation is an intentional retrospective annotation, but a backtest must not claim that the event was available at `k`.

## 2. Closed candles vs live candle

The current candle can change as new quotes arrive; its high, low, close and derived indicators can change before close. If a marker must be based on a closed bar, the condition must explicitly be evaluated with closed-bar inputs and must be checked in the actual hosted runtime. “Uses `[1]` somewhere” is not a proof that the entire decision uses closed data.

For any marker, inspect the full chain:

- data series/context;
- index used for every input;
- confirmation condition;
- returned value;
- `plot.Marker`/plot offset;
- time/bar to which that output is attached.

Using the prior value and applying `offset=-1` may move a marker one additional bar depending on the plot's time association. Never guess; test with a deliberately recognizable event and inspect the displayed candle.

## 3. Multi-timeframe alignment (H4/H1/M15/M5)

`Context.calc_on` can merge values from a secondary timeframe into the primary chart's timescale according to the documented framework [S16]. The mapped series value on M5 is not automatically “the previous H1 candle” just because index `[1]` is used somewhere. Index semantics belong to the context in which the series is calculated.

For each H4/H1/M15 condition, define whether to use:

- the current in-progress HTF candle (more responsive, can change before close), or
- the last fully closed HTF candle (delayed but stable at that bar close).

The current project requires closed-bar confirmation for M5 triggers and expects H4/H1 bias to be based on confirmed HTF candles. The final mapping must be tested at the exact H4/H1/M15 boundary. Do not infer HTF candle closure from primary timeframe index alone.

## 4. What “non-repainting” should mean in this project

Avoid a binary claim unless a precise test scope is defined. Use more precise labels:

- `INTRABAR_STABLE`: the element does not change within the active candle under the tested condition.
- `CONFIRMED_EVENT_STABLE`: once its defined confirmation event has occurred, the event does not move/change under ordinary subsequent updates.
- `RELOAD_STABLE`: after reload/recalculation, the past outputs match the previously observed confirmed outputs.
- `PIVOT_BACKFILL`: a label is drawn at an earlier pivot anchor only after later bars confirm it; the anchor is retrospective, not a signal timestamp.
- `UNKNOWN`: not tested or exact source semantics remain unknown.

A script can be non-repainting for a particular closed-bar event while still drawing a confirmed pivot retroactively at the pivot candle. State the distinction.

## 5. Required MTF/repaint test matrix

At minimum test:

- M5 event exactly before, at and after an M15 close.
- M15 event exactly before, at and after an H1 close.
- H1 event exactly before, at and after an H4 close.
- A marker condition forming and failing within the live bar before final close.
- A pivot that is later superseded/invalidated or was never confirmed.
- Fresh chart load vs reload/F5 vs scrolling back in history.
- Missing bars/weekend gaps and the first few bars after a session opening.
- M5 marker offset with `value[0]`, `value[1]`, and plot offset separately diagnosed; do not change final implementation until expected behavior is documented.

Capture the outputs with bar timestamps and screenshots/logs. “It appears stable” without before/after evidence is not a pass.

## 6. MQL5 reference material is explanatory only for MT5

MetaTrader docs explain its own series orientation and `CopyBuffer` semantics [S18], but MQL5 series-buffer details must not be transplanted blindly into Indie. Use the actual target platform's official docs for the implementation. These MQL5 sources are relevant to understanding the source indicator's environment if/when `.mq5/.mqh` is provided.
