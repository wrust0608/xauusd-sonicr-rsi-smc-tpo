# 03 — RSI TREND PULSE: FORMULAS, TIMEFRAME ROLES AND PROJECT RULES

## 1. RSI mathematics

For a close series `C[t]`, first compute `delta[t] = C[t] - C[t-1]`, `gain[t] = max(delta[t], 0)`, and `loss[t] = max(-delta[t], 0)`.

For period `n` (the project's `n=14`), Wilder's usual initialization takes the arithmetic mean of the first `n` gains and first `n` losses. Subsequent averages are recursively smoothed:

`avg_gain[t] = (avg_gain[t-1] * (n - 1) + gain[t]) / n`

`avg_loss[t] = (avg_loss[t-1] * (n - 1) + loss[t]) / n`

`RS = avg_gain / avg_loss` and `RSI = 100 - 100 / (1 + RS)`.

Edge cases (average loss zero, average gain zero, insufficient warm-up history) must be handled in the way the target library defines or in a way that is explicitly tested and approved. Different initial history lengths or seed rules can produce small differences early in the series; do not automatically call every numeric difference a code defect. Compare the target runtime's built-in RSI and the custom output on enough history to understand warm-up behavior.

The project's RSI line is RSI(14) of close. Two moving averages are computed **on the RSI series**, not on XAUUSD price: EMA(9, RSI14) and WMA(45, RSI14). This is a key semantic distinction.

## 2. Reference levels and their meaning

- 30 and 70: conventional lower/upper reference levels associated with classic RSI use.
- 40, 50 and 60: project context levels to show the pullback band and center line.
- The 45 and 55 lines are contextual centers for the project’s two pullback bands: 45 ± 5 and 55 ± 5.

These lines are contextual references, not guaranteed reversal zones and not proof of overbought/oversold or future price direction.

## 3. Locked multi-timeframe roles

### H4/H1 — directional context

The project reads RSI(14), EMA9(RSI), WMA45(RSI), WMA slope and a spread/tangle measure per timeframe. The locked starting interpretation is:

- Bullish: RSI and EMA9 above WMA45, WMA45 rising, and the three lines not compressed beyond the approved tangle limit.
- Bearish: RSI and EMA9 below WMA45, WMA45 falling, and the lines not overly compressed.
- `strict_htf=False` is the initial setting: H4 is the stricter context; H1 has a looser agreement rule unless strict mode is enabled.
- `min_slp=0.05` and `tangle_sp=2.5` are initial engineering thresholds from the snapshot, not statistically validated optimal parameters.

The numeric meaning of slope depends on how it is computed, data scale and timeframe; document the exact formula and unit. Do not compare slopes across timeframes as if they were automatically equivalent.

### M15 — waiting/pullback context

- In bullish context, the RSI pullback band is 40–50, or RSI is within the approved tolerance of WMA45(RSI).
- In bearish context, the RSI pullback band is 50–60, or RSI is within the approved tolerance of WMA45(RSI).
- `w45_tol=2.0` is the initial snapshot tolerance.
- Reaching the band means “wait/observe the pullback context”; it does not complete a price setup or create an entry instruction.

### M5 — momentum confirmation

The project snapshot looks for regular/hidden RSI-price divergence and RSI double-bottom/double-top-type exhaustion patterns, then a confirming RSI cross of EMA9(RSI) in the intended direction, using a closed M5 bar. Project settings include `d_max=24`, `db_tol=3.0`, `db_prom=4.0` in the Stage 4 snapshot; these must not be called optimal or universally correct.

The source project specification requires pivot pairing, separation rules and confirmation delay to be explicit. Divergence can be subjective unless pivot pairing is mechanical. A high/low from a price pivot must be paired using the chosen rule; the agent must not silently switch between close, wick, adjacent-bar extrema or different pivot timestamps.

## 4. Marker semantics

The RSI pane marker expresses only the defined M5 momentum-confirmation event. The overlay marker expresses a price/setup condition that includes its own price structure and approved context. They are independent layers and are not required to print on the same candle. A shared marker time is not a valid acceptance condition unless the manager explicitly changes the product definition.

## 5. Legacy conflict to keep visible

The locked project purpose excludes order/position management. Some old source material for RSI 101 describes SL, TP, staged exits and risk-reward. Those parts are not part of this product. Use RSI 101 only for the approved directional, pullback and momentum concepts; never resurrect trade-management code from legacy documentation.

## 6. Evidence and references

- Wilder’s RSI originated in *New Concepts in Technical Trading Systems* (1978); see the bibliography at [S3].
- TradingView's RSI help documents the formula and Wilder/RMA calculation: [S4].
- TakeProfit's Indie library documents `Rsi` and moving average algorithms, including EMA, RMA/SMMA and WMA: [S5], [S6].
- Project-specific 14/9/45 periods, H4/H1/M15/M5 roles and pullback bands are `PROJECT_LOCK`, based on this project's stored specification and concept history. They are not independently proven profit rules.

## 7. Divergence and double-top/bottom vocabulary

For two **confirmed and correctly paired** price/RSI swing lows (`P1, P2` and `R1, R2`):

- Regular bullish divergence: `P2 < P1` while `R2 > R1`.
- Hidden bullish divergence: `P2 > P1` while `R2 < R1`.

For two **confirmed and correctly paired** price/RSI swing highs:

- Regular bearish divergence: `P2 > P1` while `R2 < R1`.
- Hidden bearish divergence: `P2 < P1` while `R2 > R1`.

These formulas are only meaningful after the pair-selection rule is fixed. An RSI pivot may not occur on the exact candle of the price extreme. If the code pairs the nearest pivot, a window-min/max, or an adjacent-bar price extreme, these are different algorithms. The agent must report which one the code/spec uses and not change pairing without a defect/decision.

A generic RSI double bottom describes two RSI troughs with values within a tolerance and a sufficiently pronounced intervening peak; double top is the inverse. Project snapshot values include `db_tol=3.0` and `db_prom=4.0`. The exact comparison inequalities, intervening-peak calculation, allowed bar separation, pivot reuse and latch/reset rules remain source-review issues until checked against the actual snapshot and locked specification. Do not infer them from the plain English name.

## 8. Moving-average formulas — generic math vs platform output

A conventional EMA of period `n` uses `alpha = 2 / (n + 1)` and updates as `EMA[t] = alpha × x[t] + (1 - alpha) × EMA[t-1]`, subject to a seed/initialization convention. A conventional WMA of period `n` gives higher weight to more recent samples; with current sample `x[t]` receiving weight `n`, a common formula is `WMA[t] = (n*x[t] + (n-1)*x[t-1] + ... + 1*x[t-n+1]) / (n*(n+1)/2)`.

These mathematical descriptions orient the reader. For numerical parity in Indie, use the documented target algorithm or compare against it; do not hand-code a supposedly equivalent average without checking its seed, data ordering and warm-up behavior.
