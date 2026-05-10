# Bradley-Terry Case Study — Lean Formalization

First-pass formalization of the Bradley-Terry model and Ford's MLE existence theorem,
following the specification in `bradley_terry_spec.md`.

## Status

This is the unaided first attempt. It has not been compiled. Several proofs are stubbed
with `sorry`. The point of this artifact is to be the input to the round-trip translation
and expert-validation steps of the case study.

## Build

```
lake update
lake build
```

The `lean-toolchain` is pinned to `v4.14.0`. Sync with whatever Mathlib master currently
expects before building (check `lean-toolchain` in the Mathlib4 repo).

## Files

- `BradleyTerry.lean` — single-file formalization. All definitions, lemmas, the statement
  of Ford's theorem, and the worked examples are here.

## Design choices made in this pass

These are the decisions a Lean-using agent had to make that aren't determined by the
spec, recorded for the case study trace.

1. **`StrengthAssignment` is a structure carrying the positivity proof**, rather than
   a function with positivity as a separate hypothesis. Other reasonable choices: a
   function `I → ℝ≥0` with positivity baked into the type, or a function `I → ℝ` with a
   `Positive` predicate. The structure is the most direct rendering of the prose.

2. **`comparisonProb` is total**, defined for all pairs including `i = j` (where it
   returns `1/2` trivially). The spec only intends it for distinct items. Making it
   total avoids `if`/junk-value gymnastics; the no-self-loops constraint on tournaments
   makes the semantic discrepancy invisible to the likelihood.

3. **`likelihood` iterates over all pairs**, not just distinct pairs. The diagonal contributes
   factors of `1` because `t.a i i = 0` by `no_self_loops` and `x ^ 0 = 1`. An iteration
   restricted to off-diagonal pairs would be cleaner mathematically but more annoying in
   Lean. Worth checking whether the round-trip flags this as a discrepancy.

4. **`fordCondition` is stated directly in partition form** rather than via a
   `SimpleGraph`-style strong-connectivity definition. The spec hints at this preference.
   Not pulling in `Mathlib.Combinatorics.SimpleGraph.Connectivity` keeps the development
   self-contained. Also: Mathlib's `SimpleGraph` is undirected, so using it would have
   required `Quiver` or a custom directed-graph notion; that's a real piece of friction
   the case study should note.

5. **Ford's theorem split into two**: existence and uniqueness up to scale, rather than
   one bundled theorem. Easier to use as separate hypotheses in downstream work, and the
   uniqueness statement requires the existence statement implicitly anyway.

6. **`likelihood` is `noncomputable`**, although strictly speaking real-to-natural-power
   is computable. This is defensive against Mathlib changes; can be relaxed if needed.

## Sorrys, in order of difficulty

| Location | Why sorry | Difficulty estimate |
|---|---|---|
| `ford_existence` | Stated as black box per spec | not to be filled |
| `ford_uniqueness_up_to_scale` | Stated as black box per spec | not to be filled |
| `cyclicThree_ford` | Finite case analysis over six subsets of `Fin 3` | should be fillable with `decide` or `Finset.decidableBAll` after some setup; possibly hairy |
| `totalDominance_not_ford` | Tail of a finished argument; just needs to extract `i = 1` and `j = 0` from the membership facts and finish with `simp` or `omega` | easy |

## Things to verify when actually building

These are points where the unaided agent (me) was uncertain and a `lake build` will tell.

- `import Mathlib` is the brute-force option. If it's slow, narrow to `Mathlib.Algebra.BigOperators.Basic`, `Mathlib.Data.Finset.Basic`, `Mathlib.Tactic.FieldSimp`, `Mathlib.Tactic.Linarith`, and probably others depending on what `field_simp` and `ring` need on `ℝ`.

- `comparisonProb_scale`'s `simp only` with no arguments may fail to unfold the definitions correctly; if so, add `[StrengthAssignment.scale, StrengthAssignment.comparisonProb]` or restructure.

- `field_simp` in `comparisonProb_add_swap` needs hypotheses `s.w i + s.w j ≠ 0` and `s.w j + s.w i ≠ 0` in scope. The `have hsum` and `have hsum'` lines try to provide those. If `field_simp` doesn't pick them up automatically, may need to pass `[ne_of_gt hsum, ne_of_gt hsum']` explicitly.

- `cyclicThree.no_self_loops` and `totalDominance.no_self_loops`: the `fin_cases` followed by `simp` pattern assumes the conditional definition simplifies cleanly. Should work but worth checking.

- `mem_univ` for the contradiction in `totalDominance_not_ford`: `Finset.mem_univ` may need to be qualified or use a different lemma name in the current Mathlib.

## What this artifact is for

This file is the **first-pass output of the agent**, before any human review. The case
study asks: feeding the spec to the agent, how much did the agent get right unaided?
The next steps are:

1. Round-trip this Lean back to prose using a separate agent.
2. Compare round-tripped prose to the original `bradley_terry_spec.md`.
3. Note where they diverge (this is the failure-mode data).
4. Try to actually compile (`lake build`) and record the compile-error trace.
5. Iterate with the agent on compile errors and see how many of the design choices
   above survive vs. get re-decided under pressure.
