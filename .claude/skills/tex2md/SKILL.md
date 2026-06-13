---
name: tex2md
description: Distill concept changes made in a section's shipped LaTeX prose (sections/<name>.tex) back into its Markdown sidecar (sections/<name>.md), keeping the design log honest. Use late in the lifecycle, when the argument was sharpened directly in the .tex and the user asks to "tex2md", "propagate the tex back to the sidecar", "update the sidecar from the section", "sync the .md to the .tex", or "feed the prose changes back". This is concept propagation, NOT a mechanical tex->md conversion: it captures only conceptual changes (new/reordered/dropped claims, sharpened framing), updates the sidecar's spine and decision log, closes resolved open questions, and NEVER pastes polished prose verbatim into the .md. Writes in the sidecar's markdown voice (SEMBR; see format-md). Surgical and additive — proposes targeted edits to the .md, protects its scratch/open-questions/rationale, and confirms a shown diff before writing. Runs a git-aware age check and warns if the .tex looks older than the .md (you may want /md2tex instead). One section pair per run; pass --all to sweep every pair and report drift. See PROGRESSION.md.
---

# tex2md — Feed Prose Concepts Back into the Sidecar

Propagate **conceptual changes** made in a section's LaTeX prose (`sections/<name>.tex`) back
into its Markdown sidecar (`sections/<name>.md`). This is the **late-lifecycle** move: the
`.tex` now leads, the argument was pushed directly in the prose, and the sidecar's design log
needs to catch up so it stays a truthful record.

It is **concept distillation, not conversion.** Do not run pandoc; do not dump prose into the
sidecar. Read what *changed conceptually* in the `.tex` and record it in the sidecar's own
voice — spine updates, decision entries, resolved open questions.

Read [PROGRESSION.md](../../../PROGRESSION.md) for the convention (registers, exclusive zones,
the source-of-truth flip) and [references/MAPPING.md](references/MAPPING.md) for exactly what
maps, what is protected, and the worked example. The output must follow `format-md` SEMBR style.

## When to use

- The argument was sharpened, reordered, added to, or trimmed directly in the `.tex`, and the
  sidecar no longer reflects it.
- An open question in the `.md` was effectively resolved by how the prose turned out.
- User says "tex2md", "update the sidecar", "feed the prose back", "sync the .md".

Do **not** use it to copy prose verbatim into the sidecar, to mirror the `.tex` structure
1:1, to strip the sidecar's scratch/rationale, or to reformat the `.md` (that is `format-md`).

## Workflow

1. **Resolve the pair.** From the section name or the active/opened file, locate
   `sections/<name>.tex` and `sections/<name>.md`. If the `.md` is missing, offer to scaffold
   one from the skeleton in `PROGRESSION.md` and bootstrap its spine from the prose. With
   `--all`, iterate every `sections/*.{tex,md}` pair: report drift and age, then drill in.
2. **Git-aware age / direction check.** Determine which file changed more recently using
   working-tree dirty state (`git status --short -- <files>`), then last-commit time
   (`git log -1 --format=%ci -- <file>`), with filesystem mtime as fallback. If the **source**
   `.tex` looks **older** than the destination `.md`, surface it — "the sidecar is newer than
   the prose; you may want `/md2tex`" — and ask before proceeding.
3. **Find the conceptual delta.** Compare the `.tex`'s current argument against the sidecar's
   spine. Identify *new* claims/framings in the prose, *reordered* beats, *dropped* points, and
   *open questions the prose has answered*. Ignore pure wording/style changes — only concepts
   propagate (see MAPPING.md).
4. **Propose surgical sidecar edits in its own voice.** For each conceptual change: update the
   relevant spine bullet, add a short `## Decisions` / resolved entry ("changed because…",
   "dropped X in favor of Y"), or move an answered item out of "Open questions." Write in the
   sidecar's markdown register — SEMBR, concise, conceptual — **never** the paper's sentences
   pasted in.
5. **Protect the sidecar's exclusive zones.** Do not delete or overwrite scratch, rationale,
   rejected-alternative notes, or source detail. `tex2md` is additive: it appends/updates the
   log, it does not prune the thinking layer.
6. **Show the diff and confirm.** Present the proposed `.md` changes (and the prose change each
   one records). Apply only what the user approves.
7. **Verify.** The sidecar still reads as a design log (not a prose copy); no `.tex` wording was
   pasted verbatim; scratch/open-questions/rationale are intact; the `.tex` is untouched.

## Quick reference

| | |
|---|---|
| Direction | `.tex` (lead) → `.md` (follower); late lifecycle |
| Captures | conceptual changes only: new/reordered/dropped claims, sharpened framing, resolved questions |
| Ignores in `.tex` | pure wording/voice/style changes, citation/float/math mechanics |
| Writes | sidecar-voice markdown (see `format-md` SEMBR): spine updates, decision entries |
| Protects in `.md` | scratch, open questions, rejected ideas, rationale, source detail |
| Mode | surgical & additive; show diff; **ask before writing**; never paste prose verbatim |
| Wrong-direction guard | git-aware age check; if `.tex` older than `.md`, suggest `/md2tex` |
| Scope | one pair (default); `--all` sweeps and reports drift |
| Never | run pandoc/convert, copy prose into the sidecar, prune the thinking layer, reformat |

Full mapping rules, exclusive-zone table, and worked example:
[references/MAPPING.md](references/MAPPING.md). Convention: [PROGRESSION.md](../../../PROGRESSION.md).
