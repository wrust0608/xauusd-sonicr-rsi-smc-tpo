# 13 — MANDATORY LEARNING ASSESSMENT (NO CODE BEFORE PASS)

Agent must answer each question in its own words and cite the exact knowledge-base section plus external source/artifact where applicable. “See the document” alone is not an answer. Critical questions must be 100% correct. Minimum total score 90%.

## A. Critical questions (all must be correct)

**C1.** What is the target platform/language? What decision is required to change it?  
**C2.** Why can the agent not treat `SC_MarketStructure.ex5` as source code or claim it knows its features from the filename?  
**C3.** What are the four modules and the single role of each?  
**C4.** What must never be added to this visual-only product?  
**C5.** What is the difference between the overlay triangle and RSI-pane triangle, and must they print on the same candle?  
**C6.** What does the 128 physical-line limit apply to? Do blank lines count?  
**C7.** What proves a bug? Why is “I prefer another implementation” insufficient?  
**C8.** What does a TPO cell represent, and how is that different from volume profile?  
**C9.** Given the user guide's `InpTickSize=0.1` and `InpTicksPerRow=12`, calculate the row height and name two reasons this may not translate directly to another symbol/runtime.  
**C10.** Which exact session schedule and server/DST settings are stated in the supplied TPO guide? What remains unverified?  
**C11.** Does the supplied TPO archive prove that POC/VAH/VAL/IB are displayed? Why/why not?  
**C12.** What does the documented Indie `BlockProfile` class establish, and what does it not establish for Exness?  
**C13.** Explain anchor time vs confirmation/availability time for a pivot.  
**C14.** Why is using `[1]` somewhere not enough to prove an MTF signal is based on a closed higher-timeframe candle?  
**C15.** What is the required project memory artifact and how must it persist between sessions?  
**C16.** What actions are prohibited before the manager approves the learning gate?  
**C17.** [CRITICAL — ADDENDUM] Distinguish between the `indie.drawings.BlockProfile` class and the native TPO data API (`sources.Tpo()` / `TpoProfile` in `indie.data`). What fields are natively provided by `TpoProfile`, how must Value Area (VAH/VAL) be determined, and what remains unverified regarding Exness?  

## B. Core logic and architecture

**Q17.** Describe Sonic R.'s broad method intent according to its origin source. What elements of the current project's version are project-specific adaptations?  
**Q18.** Define Dragon in the current spec, and distinguish it from EMA89 and EMA200.  
**Q19.** Explain why Touch, Bounce and Swing Breakout are distinct. What details must be fixed before a code change?  
**Q20.** Write the RSI formula components and explain Wilder smoothing.  
**Q21.** Confirm which series EMA9 and WMA45 operate on.  
**Q22.** Describe the H4/H1, M15 and M5 roles without turning them into order instructions.  
**Q23.** Why are project-specific RSI levels and thresholds not proof of profitability?  
**Q24.** Define common BOS and CHoCH conventions while explaining why they are not universally standardized software definitions.  
**Q25.** Name at least four algorithmic choices that affect FVG/OB/equal-high/sweep results.  
**Q26.** Why must SMC feature inventory come from the user's source or verified behavior instead of a generic SMC indicator?  

## C. Platform, temporal logic and quality

**Q27.** What does `Context.calc_on` do, and where does the official docs say to initialize it? What must still be tested in Exness?  
**Q28.** What is the difference between API/static validation, target compile, visual QA and reload/repaint QA?  
**Q29.** Why can a historical marker drawn on a pivot bar be valid while still not having been available to the trader at that time?  
**Q30.** List six minimum MTF/session/repaint tests for this project.  
**Q31.** What file extensions are required to source-port the user's MT5 indicators, and what fallback is allowed if those sources cannot be provided?  
**Q32.** Why is converting the target from Exness Web/Indie to MT5 not an implementation detail?  
**Q33.** What is the order-of-authority when a legacy report conflicts with the current locked spec?  
**Q34.** Explain how you will update project memory and the changelog after a new verified fact or manager decision.  

## D. Scoring rubric

- C1–C17: each 2 points (34 points total), all seventeen must be correct.
- Q18–Q35 (the 18 general questions Q17–Q34): each 1 point (18 points total).
- Normalize to 100: score / 52 × 100 (or score / 50 if C17 is evaluated as addendum critical pass).
- Pass requires >=90/100, all critical questions correct (100% Critical Pass), no unsupported algorithm claims, and all memory artifacts in `learning_records/` present/readable.

The manager may reject the learning phase even above 90% if a critical misunderstanding remains. A pass is a prerequisite for a separate implementation approval, not automatic permission to code.
