# 09 — TEST EVIDENCE, CHANGE CONTROL AND ACCEPTANCE

## 1. Five separate quality states

Report these states separately; do not compress them into “done”.

1. **CODE REVIEWED:** logic has been read and traced to the specification.
2. **STATIC API CHECKED:** call signatures and APIs cross-checked against current official docs.
3. **COMPILED ON EXNESS:** actual exact file compiled in Exness Terminal Web and visible compiler/result evidence saved.
4. **VISUAL QA PASSED:** indicator applied to the target XAUUSD chart and all required elements are placed/rendered correctly, with screenshots.
5. **REPAINT/RELOAD TEST PASSED:** specified confirmed outputs were observed before/after live bar close and reload, with evidence.

A hand calculation, Python syntax check, offline simulation or generic Indie API lookup cannot establish states 3–5.

## 2. Change classification

Every finding must be one of:

- `CONFIRMED DEFECT`: a reproducible violation of an approved requirement, with exact code/source location and expected vs actual behavior.
- `SPECIFICATION MISMATCH`: current implementation and locked spec differ; describe both and wait for approval if behavior changes.
- `DESIGN CHOICE`: multiple valid definitions; no patch until the manager chooses.
- `TEST REQUIRED`: insufficient runtime evidence to conclude.
- `NOT A DEFECT`: the suspected issue does not violate a requirement or is supported by evidence as intended.
- `SOURCE BLOCKER`: algorithm cannot be responsibly reproduced without source/behavioral documentation.

The agent may not re-label a design preference as a defect. It may not change multiple unrelated behaviors in one patch merely because that is easier to code.

## 3. Evidence format per finding

Record:

`Issue ID | requirement | source/code file + line/function | evidence class | reproducible input/context | expected behavior | actual behavior | smallest proposed fix | test before/after | affected line count/module | risk/side effects | manager decision`.

For visual features, attach dated screenshots. For temporal behavior, record bar timestamps, timeframe, symbol, browser/runtime, inputs, live/reload state and expected/actual result.

## 4. Test layers

- **L0 — Knowledge/spec:** does the requirement have an operational definition and source label?
- **L1 — Static/source audit:** can every calculation and state transition be traced to code/API?
- **L2 — Compile/runtime:** exact indicator builds in the target runtime and returns without errors.
- **L3 — Visual:** plot location, color, levels, profiles, labels, object lifecycle and clutter are right.
- **L4 — Temporal consistency:** closed-bar, MTF boundaries, pivot delay, reload stability and DST/session boundaries pass.
- **L5 — Regression:** core indicators retain their old intended outputs while SMC/TPO modules are enabled/disabled independently.

No later layer is implied by passing an earlier layer.

## 5. Regression cases specifically required here

- Bullish and bearish symmetry for price wave/trigger conditions.
- Trend vs range/chop; false breakout; pullback fails to hold Dragon.
- Touch without bounce; bounce without swing break; break without prior touch where allowed/forbidden by spec.
- Confirmed pivot vs candidate unconfirmed pivot; boundary values and equal highs/lows.
- Divergence and double-bottom/top with same-bar ties, near-ties, overlapping pivots and different price/RSI pivot separation.
- M5/M15/H1/H4 close boundaries and reload.
- TPO session boundaries, DST changes, exact row edges, missing bars and symbol tick-size variation.
- SMC lifecycle, zone overlap, wick vs close break/mitigation and pivot confirmation lag for features that are actually present.
- Independent toggling of all four modules; no SMC/TPO feature is allowed to mutate the two core scripts' logic.

## 6. Approval sequence

1. Complete learning gate.
2. Submit learning report, memory files and assessment answers.
3. Manager approves learning gate.
4. Audit existing core snapshots and source availability; no edits yet.
5. Deliver a minimal patch/port plan and test matrix.
6. Manager approves plan and target platform.
7. Implement an isolated module or one justified patch at a time.
8. Run and report all applicable test levels.
9. Freeze the approved version, store checksums and update project memory.

A new feature, target runtime change, altered marker semantics or any new setup filter needs explicit approval and a requirements update before code changes.
