# 08 — XAUUSD DATA, SESSION TIME, DST AND TPO ROW SIZING

## 1. Separate the units

The following values are different concepts and must not be used interchangeably:

- **Price unit:** the displayed price difference, e.g. 1.2 in XAUUSD quote units.
- **Digits:** number of decimal places displayed.
- **Point:** platform-defined quote increment convention.
- **Tick size:** minimum price movement supported for the symbol/contract.
- **Pip:** trading convention that can differ by instrument/broker.
- **TPO row height:** chosen market-profile bin width in price units; it may be many ticks wide.

The user's manual sets `InpTickSize=0.1` and `InpTicksPerRow=12`, yielding 1.2 price units per row for its XAUUSD setup. That is a configuration assumption from the manual, not a universal property of every XAUUSD symbol. Confirm the actual symbol contract and the meaning of each parameter before translating it.

## 2. Row bucketing requires an origin rule

Even if row size is known, the row grid still needs an origin/anchor. For example, a row of width `r` may be assigned by `floor(price/r)*r`, or by flooring relative to a configurable origin. These yield different boundaries. Do not assume that `row_size` alone defines the same bins as the original indicator. Verify the grid origin, boundary inclusion (`[bottom, top)` vs closed intervals), price rounding and handling of prices at exact boundaries.

The current Indie `BlockProfile` API describes rows as a price interval `[price, price + row_size)` [S11]. That is an API drawing representation, not evidence that the original MT5 indicator uses the same row-origin rule.

## 3. Session times must be timezone-aware

A session label such as “London”, “Asian” or “New York” is not an algorithm. Use the exact local times in the supplied manual and explicitly convert them from the stated timezone to the source/target chart time. A fixed hour offset is unsafe if either the server or target session basis changes with daylight saving time.

Track these clocks independently:

1. market/session timezone;
2. broker/server timestamp basis;
3. chart candle timestamps as supplied to Indie;
4. display timezone in the chart UI;
5. Vietnam local time used by the manual.

Record actual example timestamps and their expected session assignments. A manually typed offset is not a substitute for verifying the timestamp semantics.

## 4. Boundary and DST test data

Create a fixed test table before coding. For every session open/close, include a timestamp one period before, at the boundary, and one period after. Include dates before and after each relevant US/European DST change, and the weeks when they do not align. For each row, specify the expected timezone conversion and session label from the manual. Do not simply test a random winter date and assume summer works.

The manual reports that the author's indicator has modes for automatic server clock, fixed clock, US DST and European DST. The port must not reinterpret these modes until the intended behavior is written down. The exact mode may depend on actual server configuration; test against the server in use.

## 5. History and gaps

TPO depends on which bars are available and how each time bracket is populated. Check whether a market session contains missing candles, an exchange break or a weekend gap. If the source sees only chart bars, a candle spanning a bracket boundary can contain a high/low from both sides of that boundary; how it is assigned can affect the profile. The original algorithm's decision must be reproduced or differences recorded.
