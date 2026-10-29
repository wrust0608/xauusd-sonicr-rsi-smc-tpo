# 16 — KNOWLEDGE COVERAGE MATRIX

This matrix defines the scoped curriculum's coverage. It does not say every source-code behavior has been verified. Any `OPEN` item must remain a gap in `learning_records/KNOWLEDGE_GAPS.md`.

| Domain | Required understanding | Knowledge document | Evidence basis | Completion condition |
|---|---|---|---|---|
| Product mission and safety boundaries | User's actual goal, four independent layers, no trading automation | 01 | Project lock | Agent accurately states role and non-goals in assessment |
| Sonic R. method roots | Price-action-first, PA wave, Dragon/S&R/session context, source limitations | 02 | Primary source + project lock | Agent separates original intent from project adaptation |
| Sonic R. setup semantics | L-H-HL and H-L-LH, Dragon touch/bounce/break, swing confirmation | 02 + `01_SPEC_LOCK.md` | Project lock + code snapshot | Agent lists unresolved operational questions; does not invent them |
| RSI math | Wilder gains/losses, seed/warm-up, RSI 0–100, edge cases | 03 | Vendor/technical references | Correct formulas and caveats in assessment |
| MA-on-RSI semantics | EMA9 and WMA45 act on RSI values, not price | 03 | Project lock + API docs | Agent can identify correct input series |
| MTF logic | H4/H1 context, M15 waiting band, M5 momentum confirmation | 03 + 07 | Project lock + API docs | Correct role and closed-bar behavior explained |
| Divergence and RSI exhaustion | Regular/hidden divergence, two-pivot pairing, DB/DT prominence and tolerance | 03 + 07 | General formulas + locked snapshot values | Exact implementation remains tied to code audit and test |
| SMC feature vocabulary | Swing, HH/HL/LH/LL, BOS/CHoCH/MSS, FVG, OB, EQH/EQL, sweeps | 04 | Secondary examples + operational framework | Agent knows definitions vary and does not infer original features |
| Original SMC algorithm inventory | Exact feature names, parameters, confirmation, lifecycle/repaint | 04 + 14 | Source required | Block stays open until source or behavior evidence |
| TPO/Market Profile concepts | TPO vs volume profile, rows, periods, POC/VA/IB vocabulary | 05 | CQG docs + user manual | Agent distinguishes concepts from unknown original outputs |
| User TPO manual | Exact row size and session/server-clock statements | 05 + user input | User artifact | Agent reproduces manual's facts exactly and labels them source-derived |
| Indie APIs | Main/contexts, series, plots/drawings, MTF, BlockProfile availability limits | 06 | Official vendor docs | Agent cites sources and distinguishes API docs from runtime pass |
| MT5 source/executable boundary | EX5 vs MQ5/MQH and implications for porting | 06 + 14 | Official MetaEditor docs | Agent does not claim source recovery from EX5 |
| Causality and repaint | Pivot delay, live bars, HTF close, marker offsets, reload stability | 07 | Official runtime docs + temporal logic | Correct event-time explanation and test plan |
| Session/timezone | Server vs chart vs local time, DST boundaries, row grid origin | 08 | User manual + engineering tests | Tests define exact timestamps/expected labels |
| Evidence and QA | Static vs compile vs visual vs temporal/reload tests | 09 + inherited QA | Project QA policy | Agent never promotes one QA tier into another |
| Persistent memory | Source of truth files, session startup, decision/changelog history | 12 | Project process | All required files exist and are readable |
| Assessment and approval | Correct quiz, critical questions, manager-owned state transition | 13 + 15 | Project process | >=90% overall and 100% critical, then wait for manager |
| Open source/runtime gaps | SMC/TPO source, platform version, inputs, snapshots | 14 | Current artifacts | Agent names evidence needed for each P0/P1 gap |

## Current completion state

Knowledge base authored/reviewed for the package: **yes**.  
Agent's own study report and assessment: **not complete**.  
Agent learning gate: **PENDING**.  
Permission to write/edit indicator code: **NOT GRANTED**.
