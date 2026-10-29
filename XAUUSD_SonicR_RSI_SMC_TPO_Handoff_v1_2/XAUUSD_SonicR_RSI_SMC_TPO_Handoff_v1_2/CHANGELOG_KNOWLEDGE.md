# Knowledge-base changelog

## v1.2.3 — 2026-10-29 (Phase 0 C17 API Precision & Boundary Clarification — Release Candidate 3)
- Corrected Critical Question `C17` in `learning_records/ASSESSMENT_ANSWERS.md` and grading matrix against TakeProfit's official documentation (`https://takeprofit.com/docs/indie/Profile-data/TPO-profiles`):
  - Qualified `TpoProfile` fields: Removed undocumented `point_of_control_index` property; documented that `poc_index` must be found by scanning `rows` for the row with maximum TPO count (`len(row.block_indexes)`), updating strictly on larger counts per documented procedure.
  - Stated explicit one-sided boundary rules: at each iteration, if only the upper neighbor exists, choose upper; if only the lower neighbor exists, choose lower; if both exist, compare counts; on tie, choose closer to POC; on equal distance tie, choose upper candidate.
  - Preserved boundary geometry convention: `rows[i].price` is the lower bound; $\text{VAL} = \text{rows}[\text{low\_index}].\text{price}$; geometric upper edge of Value Area is $\text{VAH}_{\text{upper}} = \text{rows}[\text{high\_index}].\text{price} + \text{profile}.\text{row\_size}$.
- Synchronized `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` §6, `learning_records/CLAIM_LEDGER.md` (`CLM-22`, `CLM-23`), `learning_records/PROJECT_MEMORY.md` §3, and `learning_records/LEARNING_REPORT.md` §B.5 & §D.
- Recomputed all byte counts and SHA-256 hashes in `MANIFEST_CHECKSUMS.txt`.
- Rebuilt `Phase0_Deliverables_Bundle.zip` and published GitHub Release `v1.2.3-phase0`.
- Baseline preservation: All 8 reference/specification files remain 100% hash-identical. Zero indicator code created or modified.

## v1.2.2 — 2026-10-29 (Phase 0 C17 Algorithmic Correction & Release Candidate 2)
- Corrected Critical Question `C17` answer in `learning_records/ASSESSMENT_ANSWERS.md` and grading matrix to rigorously reflect TakeProfit's official single-row outward expansion algorithm from POC:
  - Guard condition: verify `len(profile.rows) > 0` before row access.
  - Step-by-step single-row selection: inspect adjacent upper (`high_index + 1`) and lower (`low_index - 1`) candidate rows; select and accumulate only the single row with strictly greater TPO count.
  - Official tie-break rule: if TPO counts are equal, choose the candidate row closer to POC; if distances to POC are also equal, choose the upper row.
  - Prohibited accumulating both adjacent rows in one step.
  - Boundary geometry convention: `rows[i].price` is the lower bound; $\text{VAL} = \text{rows}[\text{low\_index}].\text{price}$; $\text{VAH}_{\text{lower}} = \text{rows}[\text{high\_index}].\text{price}$; geometric upper edge of Value Area is $\text{VAH}_{\text{upper}} = \text{rows}[\text{high\_index}].\text{price} + \text{profile}.\text{row\_size}$.
  - Added direct official documentation link to `https://takeprofit.com/docs/indie/Profile-data/TPO-profiles`.
- Updated `learning_records/CLAIM_LEDGER.md` (`CLM-23`), `learning_records/PROJECT_MEMORY.md` §3, `learning_records/LEARNING_REPORT.md` §B.5 & §D, and `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` §6 to synchronize with this precise algorithmic specification.
- Recomputed all checksums and byte counts in `MANIFEST_CHECKSUMS.txt`.
- Rebuilt `Phase0_Deliverables_Bundle.zip` with clean forward-slash entries.
- Re-verified all 8 baseline files: 100% hash-identical to baseline. Zero indicator code created or modified.

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
