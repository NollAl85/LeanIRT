# AGENTS.md

Context and operating instructions for AI agents (Claude Code, Gemini CLI, etc.) working on this project.

## What this project is

This is a **case study in autoformalization**, not a Lean development. The artifact you produce — Lean code, logs, observations — is evidence in the case study. Everything you do, including mistakes, is data.

Mathematical content: Bradley–Terry MLE existence (Ford 1957), formalized in Lean 4. The source-of-truth specification is `spec/bradley_terry_spec.md`.

Case-study question: how well does an LLM agent autoformalize literature mathematics that is not yet in any formal library, when supervised by a domain expert using round-trip translation as the verification primitive?

The human collaborator is a measurement-theory expert and a Lean beginner. You handle Lean mechanics; they handle mathematical intent.

## Operating principles

- **Preserve raw trace.** A clean narrative is a worse artifact than a messy honest one. Do not smooth over errors, dead ends, or decision reversals when writing logs.
- **Flag decisions, don't bury them.** Every time the spec doesn't determine a design choice (naming, structure-vs-typeclass, bundled-vs-unbundled, which import), say so in the log with alternatives considered.
- **Round-trip is the verification primitive.** When translating Lean back to prose, do not consult the original spec or any other source.
- **Math expertise lives with the human.** Don't invent mathematical content the spec doesn't specify. If something is ambiguous, ask. Don't "fix" the spec to make formalization easier.

## File layout

```
spec/                     ← source-of-truth math spec; do not edit
BradleyTerry.lean         ← single-file formalization (current scope)
lakefile.lean
lean-toolchain
log/                      ← session logs; append-only after writing
  TEMPLATE.md
  YYYY-MM-DD-<slug>.md
roundtrips/               ← versioned Lean→prose translations
  YYYY-MM-DD-rt-vN.md
findings.md               ← running synthesis (proto-paper); editable
README.md                 ← orientation only; small, stable
AGENTS.md                 ← this file
```

## Logging discipline

After each substantive session, write a new entry under `log/` following `log/TEMPLATE.md`. Filename: `YYYY-MM-DD-<short-slug>.md`. Multiple same-day sessions get `-a`, `-b`.

Write during or immediately after the session, not from memory hours later.

**Include:**
- Literal prompts you were given.
- Verbatim build output (stdout, stderr).
- Verbatim agent outputs that mattered.
- Decisions made and rejected alternatives.
- Things that surprised you.

**Don't include:**
- Tidied summaries of what you "ended up doing."
- Justifications written after the fact.
- Anything that smooths a failure into a success.

If a session was a dead end, log it that way. Dead ends are the most informative trace data.

## Working with Lean

- Prefer idiomatic Mathlib style. When in doubt, mirror existing Mathlib files.
- Imports: start with `import Mathlib` for first-pass simplicity. Narrow only if compile time hurts.
- `sorry` is fine when proof is out of scope or unclear. Don't use it to dodge tractable work.
- On `lake build` failure: report the error verbatim before attempting fixes. Try one fix; log whether it worked. If not, log the second attempt too. Don't silently iterate five times and report only the working version.
- Don't invent Mathlib lemma names. If unsure between `Finset.mem_univ` and `Finset.mem_univ_iff`, log the uncertainty, try one, and let the error tell you.

## Round-trip protocol

When asked to translate Lean → prose:

1. Receive only the Lean file. Do not request or consult the spec or any other source.
2. Translate every definition, lemma, and theorem statement into expository prose for a mathematical audience.
3. Use math notation freely.
4. State scope honestly. A `sorry`'d theorem becomes "stated without proof," not "proved."
5. Save to `roundtrips/YYYY-MM-DD-rt-vN.md` with a header noting which `BradleyTerry.lean` revision it was generated from (`git rev-parse HEAD` if available).

The human will diff the round-trip against the spec. Discrepancies are the case-study data, not embarrassments to fix.

## When you don't know something

Ask, or log "uncertain" and pick a reasonable default with alternatives noted. Don't silently guess.

## What not to do

- Don't edit `spec/bradley_terry_spec.md` to make formalization easier.
- Don't delete or rewrite log entries after the fact.
- Don't "clean up" round-trip outputs to match the spec better.
- Don't add scope (extra theorems, extra examples) without asking.
- Don't assume `findings.md` is raw trace; it's the human's synthesis layer.

## Current state

See `findings.md` for an up-to-date summary. At project start: single-file formalization with 2 design-relevant `sorry`s and 2 black-box `sorry`s (Ford's theorem itself). First-build attempt not yet done.