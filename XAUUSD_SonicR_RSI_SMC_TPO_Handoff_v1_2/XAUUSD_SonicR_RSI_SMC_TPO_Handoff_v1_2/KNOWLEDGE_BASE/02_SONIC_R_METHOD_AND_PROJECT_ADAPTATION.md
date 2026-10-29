# 02 — SONIC R.: METHOD ROOTS, PROJECT ADAPTATION AND UNRESOLVED SEMANTICS

## 1. Source status

The method-origin source identified in the prior research is Sonicdeejay's original **Sonic R. System** thread on Forex Factory. The first post describes Sonic R. as a 15-minute swing system developed to avoid relying blindly on moving-average crossovers and discusses price waves, support/resistance, the Dragon, the Trend Line, and the later PVSRA analysis. A later explanation by traderathome states that the classic setup focuses on a price-action wave launching away from support/resistance, with the Dragon used as an entry-area guide; the 89 EMA trend line is useful but not mandatory in the original method. See sources [S1] and [S2] in the source register.

This is a community-authored method source, not an exchange specification or scientific proof of profitability. It is appropriate for method intent and terminology, not for proving statistical performance.

## 2. Method intent vs this project's frozen implementation

The source method's broad intent is price-action-first: inspect a wave/structure, context such as support/resistance and session, and the Dragon as a reference area. Do not turn Sonic R. into a blind “EMA cross = entry” system. The original forum also distinguishes PVSRA as analysis/context from the entry method.

The current project specification operationalizes and extends this method for a visual-only indicator as follows:

- Dragon: EMA(34) of High, Close, Low.
- Trend reference: EMA(89) of Close.
- EMA(200): optional extra context; not a mandatory part of the original system and disabled as a hard filter by default.
- Round-number levels: dynamic values based on `rnd_step`, default 10.0 for the current XAUUSD setup.
- Recent swing highs/lows: displayed as references only; do not label every swing as a validated support/resistance zone.
- Potential bullish wave: L → H → HL; bearish mirror: H → L → LH.
- Touch, Bounce and Swing Breakout are distinct concepts, not synonyms.

The list above is **PROJECT_LOCK** for this build, but not a claim that every detail is a universal or exact formula from the original historical Sonic R. method.

## 3. Terms that must stay separate

- **Dragon touch:** a specified price interaction with the Dragon band. A touch alone is not a completed setup.
- **Bounce:** a specified rejection/recovery pattern after a touch. The exact close/open/wick formula must match the current approved spec and code; do not redefine it opportunistically.
- **Swing breakout:** a specified close crossing a relevant structural level. Decide whether the condition is close-only or wick-inclusive from the approved specification.
- **Price wave:** a sequence of swing points in the required order. The pivot confirmation delay and wave lifecycle must be made explicit.
- **Bias/context:** broader direction and nearby reference levels; context is not the same as a trigger.

The Stage 4 snapshot uses `trig_mode=0` for Bounce and `trig_mode=1` for Swing Breakout. This is a project-code fact to verify against the final file, not permission to change the definitions.

## 4. Operational definitions the agent must learn and audit

For every swing, wave and setup event, record:

1. Which exact bar is the pivot anchor?
2. How many bars to the left and right are required to confirm it?
3. At what event time does the code first know the pivot? Do not confuse the anchor timestamp with the confirmation timestamp.
4. Does structure use wick (`high`/`low`) or close?
5. What constitutes a valid sequence L-H-HL or H-L-LH, including minimum/maximum separation and whether points may be reused?
6. When does a candidate wave become active, invalidated or expired?
7. What event re-arms the next setup cycle?
8. Does a trigger evaluate only when a bar is closed?
9. Which precise chart bar receives the marker, accounting for both series indexing and plot offset?
10. Is a historical marker placed retrospectively after pivot confirmation? If so, it must not be described as a signal that was available at the anchor bar.

These questions are a study and audit checklist; the agent must not answer from intuition when the current locked spec or actual source is ambiguous.

## 5. What not to infer

- Do not conclude the original method requires EMA89 as a hard trend filter; the source explanation indicates it is not mandatory in the original method, though the user's specific build uses it as a reference/condition according to the locked spec.
- Do not add PVSRA/volume logic because it appears in the historical method source. It is not currently an approved module.
- Do not add entry orders, stop-loss, profit targets or exit handling because original trading guides discuss them. The user's current indicator is visual-only.
- Do not claim the Dragon or Sonic R. rules are profitable or statistically validated for XAUUSD because they appear in a trading forum.

## 6. Required source

[S1] Sonicdeejay, “Sonic R. System”, Forex Factory: https://www.forexfactory.com/thread/114792-sonic-r-system  
[S2] Traderathome explanation, “Sonic R. System”, later page in the same origin thread: https://www.forexfactory.com/thread/114792-sonic-r-system?page=1042

The original thread is large and evolves over time. When citing a specific rule, state which post/page and what it supports; do not treat every forum reply as an official rule.
