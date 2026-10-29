# 04 — SMC / MARKET STRUCTURE: LEARN THE TERMS, DO NOT GUESS THE SOURCE ALGORITHM

## 1. The governing rule

“Smart Money Concepts” is a family of discretionary/algorithmic price-action vocabularies, not a single universally binding software specification. Different indicators can implement swing selection, BOS/CHoCH, order-block boundaries, FVG rules, invalidation, and display lifecycle differently. The user's `SC_MarketStructure.ex5` is compiled binary with no `.mq5/.mqh` source supplied in v1.1. Its feature inventory is therefore `UNKNOWN` until source, documentation, inputs/screenshots or reproducible behavior is supplied.

The concepts below are a **study framework and comparison checklist**. They are not a claim that every feature exists in the user's original indicator, and they are not permission to recreate a different third-party SMC indicator.

## 2. Structure primitives

### Swing/pivot high or low

An operational pivot normally needs left and right neighboring bars. Example only: a swing high at bar `k` could require its high to exceed `L` bars to the left and `R` bars to the right. The point cannot be confirmed until the `R` right-side bars exist. This creates an inherent confirmation delay. Plotting the line at bar `k` later is a historical anchor, not proof that the point was knowable at `k`.

Required controls: left/right lengths, strict vs non-strict comparisons, equal-high/low tie handling, wick vs close, minimum separation, and when a pivot becomes immutable.

### HH / HL / LH / LL

These labels compare confirmed swing highs and lows in a chosen structural scale. They do not have meaning without the swing algorithm and comparison scope. Internal and swing structure, when both used, must be identified separately; never infer an internal/swing split from generic terminology alone.

### BOS — Break of Structure

A common implementation labels a continuation break when price breaks a relevant previously confirmed swing in the direction of the existing structure. The word “break” must be operationalized: candle close beyond the level, wick excursion beyond it, or some other threshold. The break cannot use a swing that was not yet confirmed at the time unless retrospective labeling is explicitly intended.

### CHoCH — Change of Character

A common implementation uses the first material break against the prior structural direction as an early warning of a possible change. Exact trend state and “protected” swing selection vary. CHoCH does not guarantee a full reversal.

### MSS — Market Structure Shift

Some implementations use MSS for a structural break with an additional displacement/impulse criterion. The agent must not conflate BOS, CHoCH and MSS unless the source does so.

## 3. Liquidity vocabulary

### Equal highs / equal lows (EQH/EQL)

A pair or cluster of swing points within a tolerance. Tolerance can be fixed price units, tick count, points, or volatility-normalized. The indicator's actual tolerance and clustering rule must be captured.

### Liquidity sweep / raid / swing failure pattern

Often means price trades beyond a prior/equal high or low and then rejects or closes back through the level. Whether a wick beyond the level is enough, whether close-back is required, and whether the event is confirmed at close are implementation decisions, not universal facts.

## 4. Imbalance and supply/demand vocabulary

### Fair Value Gap (FVG)

A widespread three-candle convention describes a bullish gap where the low of the third candle lies above the high of the first candle, and bearish gap where the high of the third candle lies below the low of the first candle. This is only a starting convention. The source may use candle indexing differently, apply a minimum size, require displacement, merge gaps, or use body-only vs wick boundaries. Record the exact formula and boundary values.

### Order block (OB)

A common convention identifies an opposing candle/zone before a strong displacement or structural break. But implementations vary on which candle qualifies, whether the zone covers the full high-low range or only body/open-to-extreme, how many bars are searched, how overlaps are handled, and what “mitigated” or “invalidated” means. Do not claim that an OB proves institutional orders; it is an algorithmic price zone under a particular convention.

### Premium / discount / equilibrium

Usually computed relative to a defined dealing range, often using its midpoint. The selected range anchors (which swing low/high and when they lock) must be defined. A 50% midpoint cannot be interpreted consistently if the range changes without a stated lifecycle.

## 5. Required feature inventory for the user's source

For every feature that is actually found, record:

- Exact name/label from source or indicator input.
- Evidence type: source-read, manual, screenshot-observed, reproducible behavior, inference, or unknown.
- Formula and input series: OHLC, timeframe, swing lengths, tolerances, thresholds.
- Confirmation time vs visual anchor time.
- Close/wick rules, bar confirmation and repaint behavior.
- Lifecycle: creation, extension, mitigation, invalidation, deletion/retention, expiry and overlap.
- Render: color, line/box geometry, label, layering and max count.
- Parameters/defaults and dependencies.
- Test case with expected chart outcome.

Do not fill this table with every standard SMC feature by default. It is an inventory of the original indicator, not a wish list.

## 6. No inferred claims from the EX5 filename

The string `SC_MarketStructure` does not prove it contains BOS, CHoCH, FVG, OB, EQH/EQL, sweeps, or premium/discount. MetaTrader's own documentation says an EX5 is an executable compiled from source and hides the original algorithm. Without source/behavioral specification, record `UNKNOWN — source/observations required`.

## 7. Secondary sources demonstrating variation

Public SMC indicator descriptions show materially different feature sets and definitions, for example LuxAlgo's open-source SMC implementation and other implementations: [S7], [S8], [S9]. These are useful for understanding that implementations differ; they do not define the user's version and must not be copied as a substitute.
