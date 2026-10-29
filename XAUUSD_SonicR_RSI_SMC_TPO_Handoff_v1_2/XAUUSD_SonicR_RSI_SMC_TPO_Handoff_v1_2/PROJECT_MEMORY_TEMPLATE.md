# PROJECT MEMORY — XAUUSD INDICATOR SUITE

**Version:** 1.2.0 template  
**State:** LEARNING GATE PENDING  
**Do not treat this template as evidence the agent has completed the learning phase.**

## Mission
Visual-only XAUUSD context using four independent layers: Sonic R.-inspired price setup, RSI Trend Pulse MTF momentum, user SMC structure features once verified, and user TPO session profile once verified.

## Target
Default assumption is Exness Terminal Web + TakeProfit Indie v5. Any target change requires explicit manager approval.

## Immutable boundaries
- No order/position management, SL/TP, TP1/TP2, exit logic/alerts, R:R, BUY/SELL labels or automated trading.
- Two original core scripts retain their roles and each stays <=128 physical lines.
- Overlay setup marker and RSI momentum marker are separate events.
- SMC/TPO begin as independent context layers, not hard filters.
- No code before the learning gate is passed and separately approved.

## Source status
- `SC_MarketStructure.ex5`: compiled MT5 file; no source/feature inventory confirmed.
- `TPO_Session_v1.01.zip`: EX5 plus `HUONG_DAN.txt`; row and session facts described in guide; full algorithm/output unknown.
- Indie API docs list `BlockProfile`; exact availability in Exness runtime is untested.
- Stage 4 core `.indie` files are reference snapshots, not proven compiled/runtime-passed artifacts.

## Current phase
PHASE 0 — STUDY + TRACEABLE MEMORY. No indicator code edits or prototypes without explicit separate permission.

## Knowledge sources of truth
- `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md`
- `01_SPEC_LOCK.md`
- `06_SMC_TPO_INTEGRATION_SPEC.md`
- `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md`
- `KNOWLEDGE_BASE/11_SOURCE_REGISTER_AND_CLAIM_MAP.md`

## Open blockers
- Need SMC `.mq5/.mqh`, parameter inputs and representative charts, or approved behavior spec.
- Need TPO `.mq5/.mqh`, presets/screenshots/output inventory, or approved behavior spec.
- Need actual Exness runtime compatibility tests after approval.
- Need audit of Stage 4 ambiguities and MTF/marker/reload behavior after learning gate.

## Decision log
No new target or logic decisions recorded by this template. Add only decisions explicitly approved by the manager.
