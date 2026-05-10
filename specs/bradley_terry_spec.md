# The Bradley–Terry Model and Ford's Existence Theorem

A specification for autoformalization in Lean 4.

This document defines the Bradley–Terry paired-comparison model, states Ford's (1957) MLE existence and uniqueness theorem, and lists examples and non-examples. It serves as the source-of-truth prose specification for a Lean formalization. The Lean formalization is expected to introduce types and predicates that match these definitions, prove the listed small lemmas, and state (but not prove) Ford's theorem.

---

## 1. Setup

We work with a finite, nonempty set of items $I$. Items represent the entities being compared (players, products, options).

We use $\mathbb{R}_{>0}$ for the strictly positive reals and $\mathbb{N}$ for the natural numbers including zero.

---

## 2. Definitions

### Definition 2.1 (Strength assignment)

A *strength assignment* on $I$ is a function $w : I \to \mathbb{R}_{>0}$.

### Definition 2.2 (Comparison probability)

Given a strength assignment $w$ on $I$, the *comparison probability* of $i$ over $j$ for distinct items $i, j \in I$ is

$$p_w(i, j) \;:=\; \frac{w(i)}{w(i) + w(j)}.$$

### Definition 2.3 (Tournament)

A *tournament* on $I$ is a function $a : I \times I \to \mathbb{N}$ satisfying $a(i, i) = 0$ for all $i \in I$.

The value $a(i, j)$ is interpreted as the number of times $i$ has been observed to beat $j$ in pairwise comparisons.

### Definition 2.4 (Likelihood)

Given a tournament $a$ on $I$, the *likelihood* of a strength assignment $w$ is

$$L_a(w) \;:=\; \prod_{(i, j) \in I \times I,\; i \neq j} p_w(i, j)^{\,a(i, j)} \;=\; \prod_{i \neq j} \left( \frac{w(i)}{w(i) + w(j)} \right)^{a(i, j)}.$$

(Here $0^0 = 1$ by convention; pairs with $a(i, j) = 0$ contribute a factor of $1$.)

### Definition 2.5 (Comparison graph)

The *comparison graph* of a tournament $a$ on $I$ is the directed graph $G_a$ on vertex set $I$ with a directed edge $i \to j$ whenever $a(i, j) > 0$.

### Definition 2.6 (Ford's connectivity condition)

A tournament $a$ on $I$ *satisfies Ford's condition* if, for every nonempty proper subset $S \subsetneq I$, there exist $i \in S$ and $j \in I \setminus S$ with $a(i, j) > 0$.

**Remark.** Applying the condition to both $S$ and its complement $I \setminus S$ shows that Ford's condition is equivalent to the comparison graph $G_a$ being strongly connected: every vertex is reachable from every other vertex along a directed path.

---

## 3. Main theorem

### Theorem 3.1 (Ford 1957)

Let $I$ be a finite nonempty set and let $a$ be a tournament on $I$ that satisfies Ford's condition. Then:

1. **Existence.** The likelihood function $L_a : \mathbb{R}_{>0}^I \to \mathbb{R}$ attains its maximum: there exists $\hat w$ with $L_a(\hat w) \geq L_a(w)$ for all strength assignments $w$.

2. **Uniqueness up to scale.** If $\hat w$ and $\hat w'$ are both maximizers, then there exists $c > 0$ such that $\hat w'(i) = c \cdot \hat w(i)$ for all $i \in I$.

The proof uses convex analysis on $\theta_i := \log w_i$ and a compactness argument; see Ford (1957) or Hunter (2004) for modern treatments. **For the purposes of this formalization, Theorem 3.1 is to be stated but not proved.** It is treated as a black box.

---

## 4. Small lemmas (to be proved)

### Lemma 4.1 (Probability normalization)

For any strength assignment $w$ on $I$ and any distinct $i, j \in I$:

1. $p_w(i, j) \in (0, 1)$;
2. $p_w(i, j) + p_w(j, i) = 1$.

### Lemma 4.2 (Scale invariance of the likelihood)

For any tournament $a$ on $I$, any strength assignment $w$, and any constant $c > 0$, define $cw$ by $(cw)(i) := c \cdot w(i)$. Then

$$L_a(cw) \;=\; L_a(w).$$

*Proof sketch (informal).* For each pair $(i, j)$ with $i \neq j$:
$p_{cw}(i, j) = \frac{cw(i)}{cw(i) + cw(j)} = \frac{w(i)}{w(i) + w(j)} = p_w(i, j)$. The result follows by taking the product over all pairs.

This lemma is the "easy half" that explains why uniqueness in Theorem 3.1 is only up to scale.

---

## 5. Examples and non-examples

### Example 5.1 (Cyclic three-item tournament)

Let $I = \{1, 2, 3\}$ and define $a$ by $a(1, 2) = a(2, 3) = a(3, 1) = 1$ and $a(i, j) = 0$ for all other $(i, j)$. The comparison graph is the directed cycle $1 \to 2 \to 3 \to 1$, which is strongly connected. **Ford's condition holds.** By Theorem 3.1 the MLE exists; by symmetry under the cyclic permutation $1 \mapsto 2 \mapsto 3 \mapsto 1$, the MLE satisfies $\hat w(1) = \hat w(2) = \hat w(3)$.

### Example 5.2 (Symmetric two-item tournament)

Let $I = \{1, 2\}$ and define $a(1, 2) = a(2, 1) = 1$. The comparison graph has both edges $1 \to 2$ and $2 \to 1$ and is strongly connected. **Ford's condition holds.** The MLE satisfies $\hat w(1) = \hat w(2)$ (any maximizer assigns equal strengths up to scalar).

### Non-example 5.3 (Total dominance)

Let $I = \{1, 2\}$ and define $a(1, 2) = 1$, $a(2, 1) = 0$. The comparison graph has only the edge $1 \to 2$. Taking $S = \{2\}$, there is no edge from $S$ to $I \setminus S$. **Ford's condition fails.** The likelihood $L_a(w) = w(1) / (w(1) + w(2))$ is strictly increasing in $w(1)/w(2)$ and bounded above by $1$ but never attains it; the MLE does not exist.

### Non-example 5.4 (Disconnected groups)

Let $I = \{1, 2, 3, 4\}$ and define $a(1, 2) = a(2, 1) = a(3, 4) = a(4, 3) = 1$ and all other $a(i, j) = 0$. The comparison graph consists of two disjoint two-cycles. Taking $S = \{1, 2\}$, there is no edge from $S$ to $I \setminus S$. **Ford's condition fails.** The likelihood factors as
$L_a(w) = L_{a_{12}}(w(1), w(2)) \cdot L_{a_{34}}(w(3), w(4))$,
and the relative scale between $\{w(1), w(2)\}$ and $\{w(3), w(4)\}$ is unconstrained; the maximizer is not unique up to a single overall scalar.

---

## 6. Scope of formalization

The Lean development should produce, in roughly this order:

1. A type or structure for `Tournament I` carrying the function $a$ and the no-self-loops constraint.
2. The definitions of `StrengthAssignment`, `comparisonProb`, `likelihood`, `comparisonGraph`, and `FordCondition`.
3. The two small lemmas (Lemma 4.1 and Lemma 4.2) with full proofs.
4. The statement of Theorem 3.1, with the proof replaced by `sorry` or stated as an axiom, with a comment indicating it follows Ford (1957).
5. The four examples and non-examples (5.1–5.4) constructed as concrete instances, with proofs that Ford's condition does or does not hold for each.

For the non-examples (5.3, 5.4), a verification that Ford's condition fails is sufficient; deriving the non-existence of the MLE from this is out of scope for the first pass.

For the examples (5.1, 5.2), constructing the concrete tournament and proving Ford's condition holds is sufficient; computing or characterizing the actual MLE is out of scope.

---

## 7. References

- Ford, L. R. (1957). Solution of a ranking problem from binary comparisons. *American Mathematical Monthly*, 64(8P2), 28–33.
- Hunter, D. R. (2004). MM algorithms for generalized Bradley–Terry models. *Annals of Statistics*, 32(1), 384–406.