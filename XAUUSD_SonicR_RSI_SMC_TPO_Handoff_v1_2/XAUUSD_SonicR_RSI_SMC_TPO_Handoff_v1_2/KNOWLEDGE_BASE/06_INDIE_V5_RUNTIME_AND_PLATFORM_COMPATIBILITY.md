# 06 — INDIE V5, EXNESS RUNTIME AND PLATFORM COMPATIBILITY

## 1. Target platform is an architectural constraint

The current project assumes **Exness Terminal Web custom indicators using TakeProfit Indie v5**. Exness describes custom indicators in its web terminal as being written in Indie [S12]. The `.ex5` files supplied by the user are MetaTrader executable indicators, not Indie source. MetaEditor documentation describes EX5 as the compiled output of an MQ5/MQH-based development process and states that the executable hides the original algorithm; without source it cannot be debugged in the usual source-level manner [S13].

Therefore:

- EX5 cannot be pasted as Indie source.
- The agent must not claim to have extracted or restored the exact internal algorithm from EX5.
- To port faithfully, obtain `.mq5/.mqh`; otherwise create a documented behavioral reimplementation from input/output evidence and label it as such, not an exact source port.
- Changing the target to MT5 desktop is a product decision, not a coding convenience. It would also require a separate plan for the two Indie core scripts.

## 2. Indie execution concepts to understand

The current official Indie docs describe a `Main` entry point executed per chart candle and updated as the current realtime candle changes [S14]. The context exposes OHLC series, bar index/count, time and state flags including `is_closed_bar`, `is_history`, `is_last_bar`, `is_new_bar` and `is_realtime` [S15]. The exact semantics must be checked against the version available in Exness, not assumed solely from the generic documentation.

In the documented model, the oldest received candle starts at bar index zero; `[0]` normally refers to the current/latest item in a series, `[1]` the prior item, etc. But an index used inside an HTF secondary context refers to that secondary context's series, not automatically to the same offset on the chart's primary series. Be explicit about which context owns each series.

Core Indie architecture terms:

- `@indicator(...)` declares the indicator and presentation options.
- `Main` or a `MainContext` subclass is the primary entry point.
- `@param.*` declares user inputs.
- `@plot.*`, `@level`, `@band` declare series-based output and references.
- Drawing objects use `self.chart.draw(...)` and `self.chart.erase(...)` to add/update/remove objects. Drawing lifecycle and duplicate object handling must be designed, not improvised.
- `@sec_context` plus `Context.calc_on(...)` requests additional instrument/timeframe contexts. The docs say `calc_on` must be called from the context's `__init__` [S16].

Do not assume Indie is identical to general-purpose CPython, Pine Script, MQL5, or an arbitrary Python library. Only use APIs and syntax documented for the target version.

## 3. API facts currently supported by docs

As of the documentation reviewed for this handoff:

- The Indie plot library documents line/marker plotting and plot objects [S5].
- The context library documents `calc_on`, secondary contexts, and a `lookahead` argument whose specific behavior must be understood from the relevant page before use [S16].
- The package docs list `Rsi` and `Ma` algorithms; the moving-average options documented for `Ma` include EMA, SMA, SMMA (RMA), RMA, VWMA and WMA [S6].
- The drawings docs list chart objects, labels, line segments, rectangles, and `BlockProfile` with price rows/time columns [S11].
- The data package (`indie.data`) documents native TPO profiles via `sources.Tpo()` and `TpoProfile`, exposing `point_of_control`, `initial_balance_high/low`, and price rows, while VAH/VAL require manual expansion logic [S19, S20].
- The Indie changelog reports lower-timeframe `calc_on` support starting in v5.14.0 [S17] and native TPO profile data support added in the September 2026 update [S21]. Verify the actual version exposed by Exness before relying on these capabilities.

These are API-documentation facts, not a completed compile test. A platform may expose a subset/version of the hosted engine or differ in realtime behavior.

## 4. Required compatibility checks after the learning gate

Use an isolated, minimal compatibility smoke-test only when explicitly authorized:

1. Can Exness compile a minimal Indie v5 custom indicator on the current account/browser?
2. Does the current runtime accept the exact drawing/plot class required for the specific feature (especially `BlockProfile` if chosen)?
3. Is the requested MTF timeframe supported, and does its `calc_on` output align as expected on M5/M15/H1/H4?
4. Are `is_closed_bar` and realtime updates behaving as assumed around candle closes?
5. Does a marker with the intended offset plot on the intended bar without accidental double shifting?
6. Does a drawing update replace the prior drawing, or does it duplicate? Does `clear`/`erase` work as specified?
7. Are row price boundaries and timestamps interpreted in the units expected by the chart?

Record the actual runtime/browser/account environment and screenshots/compile output. Do not count static code review or Python syntax checking as Indie compilation.

## 5. Physical line limit is a project constraint, not a language feature

Each of the two original core scripts must be <=128 physical lines. The cap includes blanks and the language header. New SMC/TPO modules are separate and not yet subject to that core limit unless the manager sets an additional cap. If a module needs more code, preserve clarity and split it rather than smuggling logic into the core scripts.

## 6. Key official sources

See [S12]–[S17] in `11_SOURCE_REGISTER_AND_CLAIM_MAP.md` for Exness and TakeProfit docs. The main MetaTrader source format fact is documented by MetaEditor [S13].
