# 14 — OPEN QUESTIONS, SOURCE BLOCKERS AND REQUIRED EVIDENCE

No agent may answer an item here by guessing. Update this file only with evidence, decision owner and status.

## P0 — blocks accurate porting

1. **SMC source unavailable.** Supplied `SC_MarketStructure.ex5` is compiled MT5 output. Need `SC_MarketStructure.mq5` and every dependent `.mqh`; otherwise require a behavior specification plus parameter screenshots, representative charts and repeatable input/output observations. Exact source port is not possible from the file alone.
2. **TPO source unavailable.** `TPO_Session_v1.01.zip` includes `TPO Session.ex5` and a guide, no `.mq5/.mqh`. Need the source and dependencies, `.set` presets if used, and screenshots showing all actual outputs. If unavailable, only a behavioral reimplementation from verified examples can be considered.
3. **Destination runtime capability.** Current default remains Exness Terminal Web + Indie v5. Confirm the actual runtime exposes necessary drawing/profile features. TakeProfit docs list `BlockProfile`, but Exness support is untested.
4. **SMC feature inventory.** Exact feature list, inputs/defaults, swing length, close/wick conditions, labels/colors, state changes, mitigation/invalidation/deletion and repaint/confirmation must be identified from source or observation.
5. **TPO output and algorithm.** What the original shows (profile cells/letters/blocks, POC, VAH/VAL, IB, etc.), whether levels are actually present, counting periods, price bin origin, handling candles that span bins/boundaries, and historical persistence remain unknown.

## P1 — must resolve before final behavior freeze

6. Confirm the exact XAUUSD symbol/tick size, data source and chart display timezone in the user's current Exness setup.
7. Confirm the user's intended TPO session clock: preserve the manual exactly or adjust based on source behavior/new decision. The present handbook preserves what the manual says but does not independently assert it is correct for every server/date.
8. Review the existing two core scripts against the frozen spec and close the known Stage 4 ambiguities: pivot definition, HL/LH semantics, trigger ordering, setup cycle reset/re-arm, RSI latches, and marker offset.
9. Confirm exact target Indie runtime version and whether `calc_on` on lower timeframes (e.g. M5 logic while viewing higher chart) is available in the hosted Exness runtime.
10. Confirm acceptable default visibility/performance when four modules are loaded at once.

## Sources/assets to request from user

- `.mq5` and all `.mqh` files for SMC and TPO.
- `.set` input preset files, if any.
- Complete screenshots of each indicator's Inputs/Parameters tab.
- Representative screenshots: trending market, ranging market, structure break/change, zones created and invalidated, a completed TPO session, and at least one date near the relevant DST transition.
- Exact symbol name as shown in Exness, chart timeframe, server/display time reference and browser/runtime details.
- If source is unavailable: a versioned feature list and enough labeled examples to form a behavioral specification and test suite.

## Conditions to close blockers

- `SOURCE PORT` may be used only when source is inspectable and matched to the shipped original.
- `BEHAVIORAL REIMPLEMENTATION` requires an approved behavioral specification, sufficient input/output cases, and acceptance tests; label any remaining difference.
- A source or runtime blocker cannot be marked closed by an agent statement alone. Cite the artifact or preserve compile/screenshots/logs.
