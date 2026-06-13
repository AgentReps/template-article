# Section Progression: from sidecar scratch to shipped prose

> Not a project status log or a roadmap. This document defines how each section
> is authored across its lifecycle, using a paired `.tex` / `.md` "sidecar," and how
> concepts move between the two. The folder/file layout lives in `CLAUDE.md`.

This project separates **thinking** from **authoring** by pairing every LaTeX section file
with a same-named Markdown *sidecar*, and it treats a section as something that **progresses**
through stages rather than something written once.

## The pairing

For each section in `sections/`, there are two files:

| File         | Register / layer | Role                                                              |
| ------------ | ---------------- | ---------------------------------------------------------------- |
| `<name>.tex` | Authoring        | The polished prose that actually ships in the compiled PDF.      |
| `<name>.md`  | Thinking         | The design log: scratch, ideas, the conceptual spine, decisions. |

Example: `sections/introduction.tex` (shipped) ↔ `sections/introduction.md` (sidecar).

The sidecar is **never** `\input` by `main.tex`, so it is invisible to the LaTeX build and can
never leak into the PDF. Both files are tracked in git.

## The progression (and the source-of-truth flip)

A section does not have one fixed "source of truth." Which file *leads* changes as the work
matures — this is the central fact the tooling is built around.

```
   early                                                          late
   |  think in the .md  ──►  harmonize concepts  ──►  author into the .tex  ──► push in the .tex
   |  (scratch, ideas)       (the conceptual spine)    (/md2tex realizes)        (/tex2md feeds back)
   |
   |  .md LEADS ───────────────────────────────────────────────► .tex LEADS
```

1. **Think in the `.md` first.** Rough out purpose, key points, structure, open questions,
   and source notes before writing a single LaTeX sentence. Early on, the sidecar is ahead.
2. **Harmonize the concepts.** The sidecar settles into a coherent conceptual spine — the
   claims and the order of argument the section will make.
3. **Realize into the `.tex` (`/md2tex`).** Translate the *settled* concepts into polished,
   house-style prose. The sidecar's scratch and open questions stay behind.
4. **Push happens in the `.tex` (`/tex2md`).** Later, the argument is sharpened directly in the
   prose. When that changes a *concept* (not just wording), feed it back so the sidecar's spine
   and decision log stay honest.

The lead flips from `.md` to `.tex` over the lifecycle. Neither skill assumes a fixed
direction; each is invoked deliberately for the move you intend, and warns (via a git-aware age
check) when the file you're propagating *from* looks older than the one you're propagating
*to* — a hint that you may want the other direction.

## What lives where (exclusive zones + the shared spine)

The two files overlap only on the **conceptual spine**. Each also holds material the other must
never contain — protecting these zones is the first rule of every sync.

- **`.md`-only (never copy into the `.tex`):** scratch and half-formed ideas, rejected
  alternatives, open questions, design rationale ("the decision, taken with the author"),
  implementation/source detail, author-preference notes, and pointers/anchors back into the
  prose.
- **`.tex`-only (never overwrite from the `.md`):** the exact published wording and voice,
  citations, and the actual figure/table/math LaTeX.
- **Shared spine (the only thing that syncs):** the concepts, claims, framing, and order of
  argument.

So the two sync directions are **asymmetric — not inverses**:

- **`/md2tex` realizes** (expands): settled spine → polished prose. It *ignores* the `.md`'s
  exclusive zones and writes in the `.tex` house style (one sentence per line, `~` ties,
  restrained `---`; see the `format-tex` skill).
- **`/tex2md` distills** (compresses): an advanced argument → updated spine + decision-log
  entries (close an open question, record "changed because…"). It *never* pastes prose verbatim
  and keeps the sidecar's markdown voice (see the `format-md` skill).

## Discipline (both directions)

- **Surgical and additive.** Propose targeted edits to the follower's shared-spine content;
  never wholesale-replace, never touch its exclusive zones.
- **Ask first.** Concept propagation is interpretive and lossy. Show the proposed change and
  confirm before writing. One direction per invocation; no round-trip ping-pong.
- **Preserve each register.** `.tex` stays submission-ready prose; `.md` stays a readable
  design log.

## Sidecar skeleton

Each sidecar follows a light, consistent structure so it stays useful rather than becoming a
dumping ground:

```markdown
# <Section> — scratch

> Scratch/ideas only. The shipped prose lives in `<name>.tex`. Not part of the LaTeX build.

## Purpose
What this section must accomplish for the reader.

## Key points / outline
-

## Open questions
-

## Notes & references
-
```

As the section matures, the body grows toward a high-level conceptual explanation (the spine),
with a `## Decisions` or "resolved" trail recording why it reads the way it does.

## Tooling

- **`/md2tex`** — realize settled sidecar concepts into the shipped `.tex` prose (horizontal,
  within one section).
- **`/tex2md`** — feed concept changes made in the `.tex` back into the sidecar (horizontal).
- **`/progression`** — audit the conceptual coherence of the sidecars *across* sections
  (vertical): setup↔payoff, ordering, consistency, and branch coherence. Uses the optional
  progression map below.
- **`/format-tex`**, **`/format-md`** — keep each register's source tidy and diff-friendly.

## Progression map (optional)

By default the section order is the `\input{sections/<name>}` sequence in `main.tex`, and the
progression is read as a **linear chain**. When the document **branches** — parallel case
studies, an appendix that depends on a specific result, two studies that share a model but not
each other — declare the conceptual dependency structure here as a `parent -> child` edge list.
`/progression` reads it to build the dependency tree/DAG; omit it for a linear paper.

The default linear chain (no map needed) is just:

```
introduction -> system_model -> main_results -> numerical_experiments -> conclusion
```

A branching example (trunk feeding two parallel case studies that rejoin at the conclusion):

```
# progression-map
introduction  -> system_model
system_model  -> main_results
system_model  -> case_study        # branch A (depends on the model, not on B)
system_model  -> case_study2       # branch B (parallel to A)
main_results  -> conclusion
case_study    -> conclusion
case_study2   -> conclusion
```

Match the node names to the section file stems (`<name>.tex` / `<name>.md`). Keep the map in
sync with `main.tex`; `/progression` flags a section whose `.tex` is not `\input` as parked.

## Git

Sidecars are **tracked** — they are valuable design history, not disposable scratch.
(Throwaway experiments still belong in `scratch/` or `misc/`.)
