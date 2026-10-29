# KNOWLEDGE BASE — INDEX, STUDY ORDER AND MANDATORY LEARNING GATE

**Project:** XAUUSD visual-analysis indicator suite — Sonic R. + RSI Trend Pulse + SMC + TPO  
**Knowledge-base version:** 1.2.0  
**Status:** Required pre-implementation study; no permission to write or modify indicator code.  
**Target assumption:** Exness Terminal Web / TakeProfit Indie v5, unless the manager explicitly changes it.

## Why this folder exists

The agent must not begin implementing, rewriting, optimizing, or “cleaning up” any indicator until it has studied the scoped knowledge, distinguished source-backed facts from conventions and unknowns, stored the resulting project memory in files, and passed the learning gate. A statement such as “I have learned it” is not evidence. The agent must show a traceable learning report and pass the assessment.

This is a project-scoped knowledge curriculum, not a claim that every possible concept in technical analysis has been covered. “Complete” means complete enough to understand the project’s locked goals, its four analytical layers, the target runtime, the source limitations, and the specific test obligations. Anything not supported must remain UNKNOWN rather than be filled with a plausible guess.

## Read in this order

1. `01_PROJECT_MISSION_AND_INVARIANTS.md` — purpose, boundaries and authority order.
2. `02_SONIC_R_METHOD_AND_PROJECT_ADAPTATION.md` — method roots vs this project’s formalized version.
3. `03_RSI_TREND_PULSE_AND_FORMULAS.md` — RSI math, MA-on-RSI and H4/H1/M15/M5 roles.
4. `04_SMC_CONCEPTS_AND_DEFINITION_CONTROL.md` — structural vocabulary and why each feature needs an explicit algorithm.
5. `05_TPO_MARKET_PROFILE_AND_USER_TPO_SPEC.md` — profile theory and exact facts from the supplied TPO manual.
6. `06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` — platform boundaries and APIs to verify.
7. `07_MTF_SERIES_CAUSALITY_AND_REPAINT.md` — time-series indexing, confirmed bars, pivots and MTF alignment.
8. `08_SYMBOL_SESSIONS_TIMEZONES_AND_ROW_HEIGHT.md` — XAUUSD, server time, sessions and DST test plan.
9. `09_TEST_EVIDENCE_AND_CHANGE_CONTROL.md` — test tiers, failure evidence and change gates.
10. `10_GLOSSARY.md` — terms used across the project.
11. `11_SOURCE_REGISTER_AND_CLAIM_MAP.md` — provenance and evidence strength.
12. `12_PERSISTENT_MEMORY_PROTOCOL.md` — how knowledge must persist between agent sessions.
13. `13_LEARNING_ASSESSMENT.md` — mandatory exam and pass thresholds.
14. `14_OPEN_QUESTIONS_AND_SOURCE_BLOCKERS.md` — what is not yet known and what is needed to proceed.
15. `15_LEARNING_REPORT_TEMPLATE.md` — report template.
16. `16_KNOWLEDGE_COVERAGE_MATRIX.md` — coverage checklist for the entire scoped curriculum.

Then read the inherited project files: `01_SPEC_LOCK.md`, `06_SMC_TPO_INTEGRATION_SPEC.md`, `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md`, `02_ISSUE_REGISTER.md`, `03_QA_ACCEPTANCE.md`, `09_SMC_TPO_QA_ACCEPTANCE.md`, both `.indie` files in `reference/`, and all files in `source_archive/`. Treat historical stage reports as evidence of project history, not as proof that all their claims were runtime-verified.

## Evidence labels — mandatory in every learning report

- `PROJECT_LOCK`: a decision explicitly frozen in this project's current specification.
- `PRIMARY_SOURCE`: facts directly supported by a primary/origin source or official platform docs.
- `OFFICIAL_API_DOC`: function signatures or behaviors documented by the target/platform vendor.
- `SECONDARY_SOURCE`: educational or third-party material; useful, not normative.
- `USER_ARTIFACT`: facts in the user-supplied source, preset, screenshot or manual.
- `INFERENCE`: reasoned implication, not directly stated by a source.
- `DESIGN_CHOICE`: one of several possible operational definitions; requires approval if it affects behavior.
- `RUNTIME_REQUIRED`: only live compile/chart testing can establish it.
- `UNKNOWN`: not yet supported by evidence.

A source may support a narrow fact without supporting a broader conclusion. For example, API docs may show that Indie has a drawing class named `BlockProfile`; that does not prove the same feature works in the Exness-hosted runtime, nor that the class calculates TPO counts for us.

## Mandatory output of the learning phase

Agent must create these files under `learning_records/` before any code change:

1. `LEARNING_REPORT.md` — completed source-by-source study log, accurate summaries and source citations.
2. `CLAIM_LEDGER.md` — important claim, evidence label, source URL/file and exact scope of what it proves.
3. `KNOWLEDGE_GAPS.md` — every unresolved issue, why it matters and what evidence closes it.
4. `ASSESSMENT_ANSWERS.md` — answers to all questions in `13_LEARNING_ASSESSMENT.md`, citing the relevant file/source.
5. `PROJECT_MEMORY.md` — concise canonical memory, version, core invariants, current platform gate, decisions, and open blockers.
6. `SESSION_START_CHECKLIST.md` — a short checklist the agent will reread at the beginning of every later session.

Do not generate indicator code during this phase, including “prototype” or throwaway code, unless the manager explicitly authorizes a separate, non-production API smoke-test task. A smoke test, if later authorized, must be isolated and must not alter either locked core script.

## Pass/fail gate

The manager reviews the learning records. Minimum threshold:

- At least 90% overall on the assessment.
- 100% correct on all critical questions (marked `CRITICAL`).
- No critical source/target confusion; no inference presented as confirmed fact.
- The agent correctly explains why EX5 cannot be treated as Indie source and why the actual SMC/TPO algorithms remain unknown without source or observable behavior.
- The agent accurately distinguishes TPO from volume profile, a pivot’s confirmation time from its visual anchor, a closed HTF bar from an in-progress HTF bar, and a setup marker from an RSI momentum marker.
- Agent has produced persistent memory files, not merely claimed that conversational memory was updated.

Failing any critical item means the gate fails even if the numerical score is high. On failure, the agent studies the cited sections again and resubmits corrections. No source changes or implementation work begin until the manager marks the gate `APPROVED`.

## Authority order when sources conflict

1. Latest explicit user decision, recorded in the project decision log.
2. Current locked project spec (`01_SPEC_LOCK.md`) and approved extension spec (`06_SMC_TPO_INTEGRATION_SPEC.md`).
3. Actual user-supplied source code / official settings / behavior reproduced from the original indicator.
4. Current official API documentation for the actual runtime being used.
5. Primary method-origin sources (e.g. Sonic R. origin thread) for the method’s intended philosophy.
6. Secondary educational explanations.
7. Agent inference.

If two authorities conflict, do not quietly harmonize them. Record the conflict and ask for a manager decision when it changes product behavior. Historical reports do not outrank the latest lock. The EX5 binary alone does not expose the logic inside it.
