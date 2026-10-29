# Knowledge-base changelog

## v1.2.1 — 2026-10-29 (Phase 0 Addendum — Native TPO API & Deliverables Alignment)
- Added official primary sources `[S19]` (TakeProfit TPO Profiles docs), `[S20]` (`indie.data` package docs), and `[S21]` (TakeProfit Changelog Sep 2026) to `KNOWLEDGE_BASE/11_SOURCE_REGISTER_AND_CLAIM_MAP.md`.
- Updated `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` §6 and `KNOWLEDGE_BASE/06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` §3 to distinguish `BlockProfile` (drawing primitive) from `sources.Tpo()` / `TpoProfile` (structured data API), documenting native fields (POC, IB, row_size), manual Value Area (VAH/VAL) derivation (outward expansion to 70%), default session grouping mismatch vs user's S1/S2/S3 schedule, and Exness `RUNTIME_REQUIRED` boundary.
- Registered claims `CLM-21` to `CLM-24` in `learning_records/CLAIM_LEDGER.md`.
- Expanded `GAP-03` in `learning_records/KNOWLEDGE_GAPS.md` to cover native TPO API and session mapping.
- Added Critical Question `C17` in `KNOWLEDGE_BASE/13_LEARNING_ASSESSMENT.md` and completed full answer and grading matrix in `learning_records/ASSESSMENT_ANSWERS.md` (17 Critical C1–C17, 18 General Q17–Q34, 52/52 raw score, normalized 100/100).
- Overhauled `learning_records/README.md` from placeholder to completed deliverables inventory and included it in manifest.
- Synchronized `learning_records/PROJECT_MEMORY.md` and `learning_records/LEARNING_REPORT.md`.
- Rebuilt `Phase0_Deliverables_Bundle.zip` with all 9 deliverables and updated `MANIFEST_CHECKSUMS.txt`.
- Discipline confirmed: Zero indicator code created or modified; all reference snapshots and locked specs remain 100% hash-identical.

## v1.2.0 — 2026-10-29 (Phase 0 Study & Memory Completion)
- Completed exhaustive study of all 16 Knowledge Base documents, locked specifications (`01_SPEC_LOCK.md`, `06_SMC_TPO_INTEGRATION_SPEC.md`), platform gate (`07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md`), issue register (`02_ISSUE_REGISTER.md`), QA plans (`03_QA_ACCEPTANCE.md`, `09_SMC_TPO_QA_ACCEPTANCE.md`), reference snapshots and historical source archives.
- Verified official documentation URLs via live research ([S10] CQG TPO, [S11] TakeProfit BlockProfile, [S12] Exness Indie, [S13] MetaEditor EX5 compilation, [S15]/[S16] Indie secondary context, [S17] Indie changelog).
- Populated and verified all 6 persistent memory records under `learning_records/`:
  - `CLAIM_LEDGER.md`: 20 categorized claims with precise scope and evidence labels.
  - `KNOWLEDGE_GAPS.md`: 5 P0 blockers and 5 P1 technical gaps.
  - `ASSESSMENT_ANSWERS.md`: Complete answers to 34 assessment questions (16 critical C1–C16, 10 core logic Q17–Q26, 8 platform/QA Q27–Q34).
  - `PROJECT_MEMORY.md`: Canonical state of truth and core invariants.
  - `SESSION_START_CHECKLIST.md`: 7-step pre-flight checklist for all future agent sessions.
  - `LEARNING_REPORT.md`: Comprehensive study report and discipline confirmation.
- Learning gate status: `PENDING` (Submitted for manager evaluation). No indicator code modified or created.

## v1.2.0 — 2026-10-29 (Initial Curriculum Lock)
- Added mandatory pre-implementation learning gate and 15-part scoped knowledge base.
- Separated project locks, historical method context, general conventions, official API facts, user artifacts, inference and runtime-required claims.
- Added detailed Sonic R., RSI, SMC, TPO, Indie, MTF/causality, session/timezone and test-evidence study documents.
- Added persistent memory protocol and an assessment with critical questions.
- Recorded current `BlockProfile` API documentation as a possibility to test, not proof of Exness runtime support.
- Updated the primary agent prompt to prohibit code changes until learning is assessed and manager-approved.

## Rule
Add future knowledge changes with date, affected file, evidence/source, reason and whether a manager decision was required.
