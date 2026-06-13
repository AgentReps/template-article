# tex2md — Concept Mapping (shipped prose → sidecar)

This is the distill direction of the [PROGRESSION.md](../../../../PROGRESSION.md) convention:
capture the **conceptual changes** made directly in a section's LaTeX prose and record them in
the Markdown sidecar's design log. Read that document first for the registers, exclusive zones,
and the source-of-truth flip.

`tex2md` **compresses**: a paragraph of polished prose becomes a compact concept entry in the
`.md`. It is the asymmetric counterpart of `md2tex` (which expands). Round-tripping is not
lossless and is not meant to be — each file keeps its own register and exclusive content.

## What maps (conceptual changes only)

Carry into the sidecar only changes to the **shared spine**:

- a **new** claim, framing, or named piece of the argument that the prose now makes;
- a **reordered** argument (the section's beats changed sequence);
- a **dropped** point the prose no longer makes (record it as a decision, don't silently lose it);
- an **open question the prose has answered** (move it to resolved, with the answer);
- a sharpened **framing** that changes the concept, not just the words.

## What does NOT map (pure prose changes)

Do not touch the sidecar for:

| Change in the `.tex` | Why it does not propagate |
| --- | --- |
| Reworded sentence, same concept | Wording is the `.tex`'s exclusive zone. |
| Tightened phrasing, voice, rhythm | Style, not concept. |
| Citation added/moved, `~` ties, float placement | Mechanics, not argument. |
| `format-tex` reflow (one-sentence-per-line) | Whitespace, not content. |

If the only change is *how* something is said, there is nothing to sync.

## How to write the `.md` side (sidecar voice)

The distilled entry must match the sidecar register (the `format-md` SEMBR style):

- **Conceptual and compact.** A bullet or two per change, not a paragraph of prose.
- **Never paste `.tex` sentences verbatim.** Restate the concept in note form. Pasting prose
  turns the design log into a stale second copy of the paper.
- **SEMBR markdown.** One sentence per line; `-` bullets; the sidecar may use `->`, `---`, and
  abbreviations freely (it is not the paper).
- **Land it in the right place.** Update the matching spine bullet; add a `## Decisions`
  (or "resolved") entry for *why* it changed; move answered items out of `## Open questions`.

## Additive — protect the thinking layer

- `tex2md` **appends and updates**; it does not prune. Leave scratch, rationale,
  rejected-alternative notes, and source detail intact even if the prose has moved past them —
  that history is the sidecar's reason to exist.
- Never overwrite an open question with an unrelated answer; only close the one the prose
  actually resolved.
- Show the proposed diff and the prose change each entry records; apply only on approval.

## Wrong-direction guard

Before writing, run the git-aware age check (working-tree dirty → last-commit time → mtime). If
the `.tex` you are propagating *from* is **older** than the `.md`, the sidecar has likely moved
ahead of the prose — say so and suggest `/md2tex`. Proceed only on confirmation.

## Worked example

**A late edit sharpened `architecture.tex`** — the digest, once grouped with the rubric judge
as a "stateless model call," is now described as needing file access:

```latex
its core is just model reasoning, but as it actually runs it reads the branch logs and
rewrites the shared hint files, so it too needs file access rather than a bare endpoint.
```

**Distilled into `architecture.md` (sidecar voice, additive):**

```markdown
## Who does what (three-way split)
- Cross-pollination digest: now classed as **local agent** (needs file access), NOT a
  stateless call.

## Decisions
- Moved the digest out of the "stateless model call" row: it does real filesystem I/O
  (reads branch logs, rewrites frontier.md / next-direction.md). Earlier draft lumped it
  with the judge fallback; corrected.
```

The concept (digest reclassified) and the decision (why) are recorded; the polished sentence is
**not** pasted in; the section's scratch and open questions are untouched.

## Idempotency

Re-running `tex2md` after the sidecar already reflects the prose's concepts finds no delta and
proposes nothing. Pure wording changes never trigger an edit, so a `format-tex` pass on the
`.tex` does not make the sidecar look stale in content terms.
