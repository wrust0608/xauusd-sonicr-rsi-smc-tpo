# XAUUSD Sonic R. + RSI Trend Pulse + SMC + TPO — Handoff v1.2

## This version changes the workflow, not the indicator code

V1.2 introduces a mandatory Phase 0 learning gate before any implementation or code audit/patching. The package contains a project-scoped knowledge base, current source register, knowledge-gap ledger, quiz, persistent memory protocol and empty learning records for the agent to complete.

**Current state: `LEARNING GATE = PENDING`; implementation permission is not granted.** The files under `learning_records/` explicitly distinguish starter memory from a completed agent study. Do not interpret their existence as proof that an agent has learned the material.

## Start here

1. `00_BAT_DAU_TAI_DAY.md`
2. `PROMPT_GIAO_AGENT.md`
3. `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md`
4. Read every knowledge-base chapter `01` through `15` in order.
5. Read inherited locked specifications, issue registers, QA docs, reference scripts and source archive.
6. Complete all six required learning records and pass `KNOWLEDGE_BASE/13_LEARNING_ASSESSMENT.md`.
7. Stop and await manager approval. Do not audit or change code before approval.

## Scope remains the same

Four independent visual layers: Sonic R. setup overlay, RSI Trend Pulse pane, verified SMC features, verified TPO profile. Keep the two original core scripts independent and <=128 physical lines each. No order/position management, SL/TP, TP1/TP2, exit logic, R:R, BUY/SELL labels or automated trading. SMC/TPO are context only in the initial integration; they do not hard-filter the original setup marker.

## Critical source limits

- `SC_MarketStructure.ex5` and `TPO Session.ex5` are compiled MT5 files, not Indie source.
- The supplied TPO guide supports specific session/time/row-size statements but does not inventory all outputs or reveal the full algorithm.
- TakeProfit docs list a `BlockProfile` drawing class, but its availability in Exness's hosted Indie runtime must be checked separately; it is not a TPO calculation engine by itself.
- Existing Stage 4 Indie snapshots are references only; no claim of Exness compile, visual QA or reload/repaint pass is made.

## Folder map

- `KNOWLEDGE_BASE/` — learning curriculum, evidence map, source register and assessment.
- `learning_records/` — agent must create actual durable learning report and memory; currently `PENDING`.
- `reference/` — two Stage 4 core script snapshots.
- `source_archive/` — reports and prior-stage history.
- `user_inputs/` — user-provided binary/input artifacts plus checksums/manual.
- Root `DECISION_LOG.md` / `CHANGELOG_KNOWLEDGE.md` — approved decisions and changes to project knowledge.
