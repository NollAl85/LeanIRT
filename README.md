# Bradley–Terry Case Study

Lean 4 formalization of Bradley–Terry MLE existence (Ford 1957), conducted as a case study in LLM-assisted autoformalization of literature mathematics not yet present in formal libraries.

## Build

```
lake update
lake build
```

The toolchain is pinned in `lean-toolchain`. Sync with the version Mathlib master expects before building.

## Files

| Path | Purpose |
|---|---|
| `BradleyTerry.lean` | Single-file formalization (current scope) |
| `lakefile.lean`, `lean-toolchain` | Lake project configuration |
| `spec/bradley_terry_spec.md` | Source-of-truth mathematical specification |
| `AGENTS.md` | Operating instructions for AI agents |
| `log/` | Dated session traces (raw, append-only) |
| `roundtrips/` | Versioned Lean→prose translations |
| `prompts/` | Versioned prompts for agent sessions |
| `findings.md` | Running synthesis (proto-paper) |

## Where to start

- Agent? Read `AGENTS.md`.
- Person new to the project? Read `findings.md` for current state.
- Working on the math? `spec/bradley_terry_spec.md` is canonical.
- Wondering what's been done? Browse `log/` chronologically.