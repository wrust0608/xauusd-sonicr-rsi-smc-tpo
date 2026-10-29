# 12 — PERSISTENT MEMORY PROTOCOL FOR THE AGENT

## 1. Do not trust conversational memory as the only repository

Agent memory can be reset, truncated, unavailable in another chat, or silently summarize important details away. The durable source of truth for this project is the versioned set of files in this handoff/repository. Do not claim that memory has been saved unless the files were actually created or updated and can be read back.

## 2. Canonical memory files

After the learning gate, maintain:

- `learning_records/PROJECT_MEMORY.md` — short source of truth: target platform, frozen scope, architecture, decisions, known facts, unknowns, current status and links to detailed files.
- `learning_records/CLAIM_LEDGER.md` — evidence-backed claims with source reference and scope.
- `learning_records/KNOWLEDGE_GAPS.md` — open questions/blockers only; close an item only with evidence.
- `learning_records/SESSION_START_CHECKLIST.md` — checklist to re-read before doing work in a new agent session.
- `CHANGELOG_KNOWLEDGE.md` — additions/corrections to the knowledge base and reason.
- `DECISION_LOG.md` — explicit decisions by the manager, date/version, reason, impact, and affected files.

Never keep the only copy of a key rule in free-form chat.

## 3. Session startup procedure

At the beginning of every session, the agent must:

1. Read `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md`.
2. Read `learning_records/PROJECT_MEMORY.md` and `SESSION_START_CHECKLIST.md`.
3. Re-read the relevant locked spec and the specific module document before working.
4. Check the current source register and outstanding unknowns.
5. State the current approved phase and whether the knowledge gate is `PENDING`, `FAILED` or `APPROVED`.
6. If the manager hasn't approved the learning gate, do not code or change indicator files.

## 4. Record discipline

Every new fact or claim must include its source/evidence label. Every new decision must be recorded in `DECISION_LOG.md` only after the manager makes/approves it. Do not modify `01_SPEC_LOCK.md` or the locked core behavior simply because a newly read general article recommends something else.

When sources conflict:

- preserve each conflicting claim and its source;
- explain which is a platform fact, historical method interpretation, user artifact, or inference;
- identify the decision needed;
- do not decide it implicitly in code.

## 5. Version integrity

Each change to the core spec, module definitions or knowledge base must update the version/changelog. Before delivery, record checksums for source and final code files. Never overwrite the user's original artifacts; retain originals in `user_inputs/` and implement against a separate working copy.

## 6. What “learned” means operationally

A passing learning gate means the agent can answer the assessment accurately with sources, explain current unknowns, and produce a memory pack that another agent can pick up without reading the entire conversation. It does not mean the agent has proven the trading logic profitable, has reconstructed EX5 source, or has compiled any indicator.
