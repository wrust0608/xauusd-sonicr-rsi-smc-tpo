# 01 — PROJECT MISSION, SYSTEM MODEL AND INVARIANTS

## 1. The product question

The suite exists to make hard-to-see market context easier to inspect on XAUUSD. It must help the user answer four separate questions:

1. **Where is price in its structural story?** Use SMC only for features whose exact original behavior has been verified.
2. **How has activity been distributed across session time and price?** Use the TPO/Market Profile layer according to the actual TPO indicator's verified behavior.
3. **What is the multi-timeframe momentum context?** Use the locked RSI Trend Pulse model: H4/H1 bias, M15 pullback/wait context, M5 momentum confirmation.
4. **Is the particular Sonic R.-inspired price setup present?** Use the locked price overlay and trigger definitions.

The product should improve visual context, not collapse these questions into a supposedly omniscient BUY/SELL answer. It is not a predictor with a guaranteed win rate.

## 2. The four modules

| Module | Sole role | State |
|---|---|---|
| `SonicR_Setup_Overlay` | Dragon EMA34 high/close/low, EMA89 close, optional EMA200 reference, confirmed swing references, dynamic round levels, small potential setup triangles. | Locked core, audit before changes. |
| `RSI_Trend_Pulse_Pane` | RSI14, EMA9(RSI), WMA45(RSI), fixed reference levels and MTF context, small M5 momentum-confirmation triangle. | Locked core, audit before changes. |
| `SMC_MarketStructure_Overlay` | Only structural features verified in the user's original SMC tool or explicitly defined/approved in a new specification. | Blocked by missing source/feature inventory. |
| `TPO_Session_Profile` | Session TPO distribution using verified session/time/row rules and the original tool's confirmed outputs. | Partial requirements from supplied manual; algorithm/output inventory incomplete. |

“Four modules” means four independently testable information layers, if the destination runtime supports them. It does not imply a script can read another indicator's hidden buffers, nor does it permit a new hard filter.

## 3. Unconditional non-goals

No order submission, modification or cancellation; no position tracking/management; no SL/TP, TP1/TP2, R:R, exits, exit alerts, auto trading, or BUY/SELL labels. No profitability guarantee. This boundary is stronger than any legacy source note that describes trade-management concepts: the present product is visual-only.

## 4. Marker meanings must never be merged

- Overlay triangle: a price/setup marker based on the locked Sonic R.-inspired price + MTF + trigger specification.
- RSI-pane triangle: an M5 momentum-confirmation event according to the locked RSI logic.
- These markers represent different events and do not have to print on the same bar. Do not artificially synchronize them just to make the chart look tidy.
- SMC and TPO are context layers initially. They must not become setup hard filters or suppress existing markers without a separately approved specification and regression tests.

## 5. The original line-budget rule

Each of the two core Indie scripts must be at most 128 **physical lines** (blank lines and the language header count). Count the exact final files. The 128-line rule currently applies to the two core scripts, not automatically to the two new modules. Never cram SMC or TPO into a core script solely to save a file, and never remove required behavior to hit the line cap without a decision.

## 6. Specification vs code are not the same thing

`reference/` contains Stage 4 snapshots, not verified binaries for the Exness runtime. Legacy reports discuss static review and hand simulations; those are not equivalent to a real compile, chart visual test or forward/reload non-repaint test. The reported line counts differed from the physical line counts in the extracted source; count the actual final file each time.

## 7. What “comprehensive” means here

Comprehensive does not mean adding every available trading concept. It means every included visual element has: a clear question it answers; an operational definition; source/requirement traceability; known lifecycle and invalidation behavior; known timeframe/source data; and an acceptance test. Unsupported or speculative features stay out until defined and approved.
