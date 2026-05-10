/-
# Bradley-Terry MLE Existence: Lean 4 formalization

Source spec: bradley_terry_spec.md (see project root or accompanying docs).
Reference: Ford (1957), American Mathematical Monthly 64(8P2): 28-33.

This is a first-pass formalization. Several proofs are stubbed with `sorry`.
Ford's theorem (Theorem 3.1) is stated but not proved, per the spec scope.
-/

import Mathlib

namespace BradleyTerry

open Finset

/-! ## Strength assignments and comparison probabilities -/

/-- A strength assignment on `I` is a function from `I` to the strictly positive reals.
    (Spec Definition 2.1) -/
structure StrengthAssignment (I : Type*) where
  w : I → ℝ
  pos : ∀ i, 0 < w i

namespace StrengthAssignment

variable {I : Type*}

/-- The comparison probability of `i` over `j` given strength assignment `s`.
    (Spec Definition 2.2)

    Note: this is defined for all pairs including `i = j` (where it returns `1/2`),
    even though the spec only intends it for distinct `i, j`. The likelihood definition
    below relies on the tournament's no-self-loops constraint to make this benign. -/
def comparisonProb (s : StrengthAssignment I) (i j : I) : ℝ :=
  s.w i / (s.w i + s.w j)

/-- Lemma 4.1, part 1: comparison probabilities are strictly positive. -/
lemma comparisonProb_pos (s : StrengthAssignment I) (i j : I) :
    0 < s.comparisonProb i j := by
  unfold comparisonProb
  have hi := s.pos i
  have hj := s.pos j
  exact div_pos hi (by linarith)

/-- Lemma 4.1, part 2: comparison probabilities are strictly less than one. -/
lemma comparisonProb_lt_one (s : StrengthAssignment I) (i j : I) :
    s.comparisonProb i j < 1 := by
  unfold comparisonProb
  have hi := s.pos i
  have hj := s.pos j
  have hsum : 0 < s.w i + s.w j := by linarith
  rw [div_lt_one hsum]
  linarith

/-- Lemma 4.1, part 3: complementary comparison probabilities sum to one. -/
lemma comparisonProb_add_swap (s : StrengthAssignment I) (i j : I) :
    s.comparisonProb i j + s.comparisonProb j i = 1 := by
  unfold comparisonProb
  have hi := s.pos i
  have hj := s.pos j
  have hsum : (0 : ℝ) < s.w i + s.w j := by linarith
  have hsum' : (0 : ℝ) < s.w j + s.w i := by linarith
  field_simp
  ring

/-- Scale a strength assignment by a positive constant. -/
def scale (s : StrengthAssignment I) (c : ℝ) (hc : 0 < c) : StrengthAssignment I where
  w := fun i => c * s.w i
  pos := fun i => mul_pos hc (s.pos i)

/-- Comparison probabilities are invariant under scaling. -/
lemma comparisonProb_scale (s : StrengthAssignment I) (c : ℝ) (hc : 0 < c) (i j : I) :
    (s.scale c hc).comparisonProb i j = s.comparisonProb i j := by
  unfold comparisonProb scale
  simp only
  have hne : c ≠ 0 := ne_of_gt hc
  rw [show c * s.w i + c * s.w j = c * (s.w i + s.w j) from by ring,
      mul_div_mul_left _ _ hne]

end StrengthAssignment

/-! ## Tournaments -/

/-- A tournament on `I`: an `ℕ`-valued function on `I × I` recording wins, with no self-loops.
    (Spec Definition 2.3) -/
structure Tournament (I : Type*) where
  a : I → I → ℕ
  no_self_loops : ∀ i, a i i = 0

namespace Tournament

variable {I : Type*}

/-- The likelihood of a strength assignment given a tournament.
    (Spec Definition 2.4)

    The product is over all pairs `(i, j)`, but pairs with `a i j = 0` (including all
    diagonal pairs by `no_self_loops`) contribute a factor of one. -/
noncomputable def likelihood [Fintype I] (t : Tournament I) (s : StrengthAssignment I) : ℝ :=
  ∏ i : I, ∏ j : I, (s.comparisonProb i j) ^ (t.a i j)

/-- Lemma 4.2 (scale invariance of the likelihood). -/
lemma likelihood_scale [Fintype I] (t : Tournament I) (s : StrengthAssignment I)
    (c : ℝ) (hc : 0 < c) :
    t.likelihood (s.scale c hc) = t.likelihood s := by
  unfold likelihood
  refine Finset.prod_congr rfl (fun i _ => ?_)
  refine Finset.prod_congr rfl (fun j _ => ?_)
  rw [s.comparisonProb_scale c hc i j]

/-- Ford's connectivity condition: for every nonempty proper subset of items,
    some item inside has beaten some item outside.
    (Spec Definition 2.6)

    Equivalent to strong connectivity of the comparison graph; we state it directly
    in the partition form to avoid pulling in graph theory infrastructure. -/
def fordCondition [Fintype I] [DecidableEq I] (t : Tournament I) : Prop :=
  ∀ S : Finset I, S.Nonempty → S ≠ Finset.univ →
    ∃ i ∈ S, ∃ j ∈ Sᶜ, t.a i j > 0

end Tournament

/-! ## Ford's theorem (1957) — stated as a black box -/

open Tournament

/-- Existence half of Ford's theorem (Ford 1957, Theorem 3.1 in the spec).
    Under Ford's connectivity condition, the likelihood attains its maximum. -/
theorem ford_existence {I : Type*} [Fintype I] [Nonempty I] [DecidableEq I]
    (t : Tournament I) (h : t.fordCondition) :
    ∃ s : StrengthAssignment I,
      ∀ s' : StrengthAssignment I, t.likelihood s' ≤ t.likelihood s := by
  sorry

/-- Uniqueness up to scale half of Ford's theorem (Ford 1957, Theorem 3.1 in the spec). -/
theorem ford_uniqueness_up_to_scale {I : Type*} [Fintype I] [Nonempty I] [DecidableEq I]
    (t : Tournament I) (_h : t.fordCondition) (s s' : StrengthAssignment I)
    (_hs : ∀ x : StrengthAssignment I, t.likelihood x ≤ t.likelihood s)
    (_hs' : ∀ x : StrengthAssignment I, t.likelihood x ≤ t.likelihood s') :
    ∃ c : ℝ, ∃ hc : 0 < c, s' = s.scale c hc := by
  sorry

/-! ## Examples and non-examples -/

/-! ### Example 5.1: cyclic three-item tournament -/

/-- The cyclic three-item tournament: `0 → 1 → 2 → 0`. -/
def cyclicThree : Tournament (Fin 3) where
  a i j :=
    if i = 0 ∧ j = 1 then 1
    else if i = 1 ∧ j = 2 then 1
    else if i = 2 ∧ j = 0 then 1
    else 0
  no_self_loops := by
    intro i
    fin_cases i <;> simp

theorem cyclicThree_ford : cyclicThree.fordCondition := by
  -- A finite case analysis: there are six nonempty proper subsets of `Fin 3`, and for
  -- each, the cyclic edge structure provides a winning out-edge.
  sorry

/-! ### Non-example 5.3: total dominance on two items -/

/-- The two-item tournament where `0` has beaten `1` once and `1` has no wins. -/
def totalDominance : Tournament (Fin 2) where
  a i j :=
    if i = 0 ∧ j = 1 then 1 else 0
  no_self_loops := by
    intro i
    fin_cases i <;> simp

theorem totalDominance_not_ford : ¬ totalDominance.fordCondition := by
  -- Take S = {1}: the only out-edge possibility is a(1, 0), but that is 0.
  intro h
  have hS : ({1} : Finset (Fin 2)).Nonempty := ⟨1, by simp⟩
  have hSne : ({1} : Finset (Fin 2)) ≠ Finset.univ := by
    intro heq
    have : (0 : Fin 2) ∈ ({1} : Finset (Fin 2)) := heq ▸ mem_univ 0
    simp at this
  obtain ⟨i, hi, j, hj, hij⟩ := h {1} hS hSne
  -- Now extract i = 1 and j = 0 from the membership facts, and contradict hij.
  sorry

end BradleyTerry
