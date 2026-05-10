# Round-trip translation session prompt

Paste this when starting a translation session in a fresh agent context (e.g., Gemini CLI).

**Critical:** the agent running this session must not have read `spec/bradley_terry_spec.md` or any external Bradley–Terry / Ford 1957 reference. The whole point is to test what the Lean encodes, with no peeking. Either run this in an agent context where you've never opened the spec, or explicitly instruct the agent not to open or search for it.

---

Read only `BradleyTerry.lean`. Do not open `spec/`, do not search the web for "Bradley-Terry" or "Ford 1957," and do not consult any other source about the mathematical content.

Translate the Lean development into expository prose for a mathematical audience:

- Render every definition, lemma, and theorem statement.
- Use mathematical notation freely (LaTeX-style). You are writing a paper section, not a Lean tutorial.
- Preserve scope honestly: a `sorry`-stubbed theorem becomes "stated without proof." A theorem with a real proof is reported as proved (you don't need to reproduce the proof; just say it is proved here).
- For each example or non-example, describe the structure constructed and what is proved about it.
- If something in the Lean is ambiguous or under-specified to you, note that explicitly rather than guessing what was intended.

Save the output to `roundtrips/YYYY-MM-DD-rt-vN.md` (next available `N`). Begin the file with a header noting:
- The date of the translation.
- The git SHA of `BradleyTerry.lean` translated (`git rev-parse HEAD` if the working copy is committed; otherwise note "uncommitted working copy").
- The agent and model used.

Do not write a session log entry for this session — round-trip output is itself the session artifact, and conflating the two pollutes the trace.