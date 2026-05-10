# Formalization session prompt

Read `AGENTS.md` and `spec/bradley_terry_spec.md`. Then formalize the spec in Lean 4.

**Setup.** Create a minimal Lake project at the repo root: `lakefile.lean` depending on Mathlib master, and `lean-toolchain` pinned to the version Mathlib master currently expects. Create `BradleyTerry.lean` as the single library file.

**Scope.** Per spec §6: implement all definitions (2.1–2.6); prove the small lemmas (4.1 parts and 4.2) in full; state Ford's theorem (3.1) with its proof as `sorry`, with a comment indicating it follows Ford (1957); construct the four examples/non-examples (5.1–5.4) as concrete `Tournament` instances; for the examples, prove Ford's condition holds; for the non-examples, prove Ford's condition fails. Do not derive MLE non-existence from the failures of Ford's condition — out of scope.

**Build loop.** Run `lake update` once, then iterate `lake build`. After each non-trivial error, log the verbatim error before attempting a fix. Don't silently iterate through multiple fixes and report only the working one.

**Logging.** Write a session log to `log/YYYY-MM-DD-<slug>.md` following `log/TEMPLATE.md`, per the discipline in AGENTS.md §Logging. Include verbatim build outputs and the design choices you made where the spec didn't determine them.

**When you finish.** Stop. Do not generate the round-trip translation in this session — that's a separate session with a different agent that must not see the spec.