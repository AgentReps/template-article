# md2tex — Concept Mapping (sidecar → shipped prose)

This is the realize direction of the [PROGRESSION.md](../../../../PROGRESSION.md) convention:
turn a section sidecar's **settled conceptual spine** into publishable LaTeX prose. Read that
document first for the registers, exclusive zones, and the source-of-truth flip.

`md2tex` **expands**: a compact concept in the `.md` becomes one or more polished sentences in
the `.tex`. It is the asymmetric counterpart of `tex2md` (which compresses).

## What maps (the shared spine)

Pull only the section's **settled** conceptual content from the sidecar:

- the claims/points the section makes and the **order** it makes them in;
- definitions, framings, and the named pieces of the argument;
- a concept the spine has **changed** since the prose was last written (a divergence to fix).

A point counts as "settled" when the sidecar presents it as a decision or a stable part of the
outline — not when it sits under "Open questions" or reads as a maybe.

## What does NOT map (the sidecar's exclusive zones)

Never carry these into the `.tex`:

| In the sidecar | Why it stays behind |
| --- | --- |
| Scratch, half-formed ideas, "maybe / TODO" | Not settled; the paper ships only finished claims. |
| Open questions | Unresolved by definition. |
| Rejected alternatives, "earlier draft did X, changed because Y" | Design history, not paper content. |
| Rationale ("the decision, taken with the author") | The *why*; the paper states the *what*. |
| Implementation / source-repo detail, file names, line anchors | Working notes, not prose. |
| Author-preference / style notes | Meta-instructions to the author, not content. |

When in doubt, ask — do not promote a borderline note into the paper.

## How to write the `.tex` side (house style)

The realized prose must match the project's LaTeX register (the `format-tex` house style):

- **One sentence per source line.** Break long compound sentences at major joints (`;`, a long
  `---` aside, a long subordinate clause). See the `format-tex` / TEXBR ruleset.
- **Non-breaking ties.** `programs~\cite{...}`, `Section~\ref{...}`, `Fig.~\ref{...}`.
- **Restrained em-dashes.** This project's prose limits `---`; prefer colons, commas, or a
  sentence split (the sidecar may use `---` and `->` freely; the paper does not).
- **No markdown artifacts.** No `#` headings (use `\section`/`\subsection`), no `-` bullets
  (use `itemize` only if the section genuinely needs a list), no backtick code spans, no
  markdown links. Translate, don't transliterate.
- **Match the surrounding voice.** Insert into the existing argument; don't restyle settled
  prose around your insertion.

## Surgical & additive — the editing rule

- Edit at the **concept** granularity: add the missing sentences, or rework the specific clause
  that diverged. Leave everything else byte-for-byte.
- Do not touch citations, figures/tables, math, or labels you are not specifically changing.
- Never regenerate a whole subsection from the sidecar; that destroys the author's wording and
  is exactly the clobber this convention forbids.
- Show the proposed diff and the sidecar concept each edit realizes; apply only on approval.

## Wrong-direction guard

Before writing, run the git-aware age check (working-tree dirty → last-commit time → mtime). If
the `.md` you are propagating *from* is **older** than the `.tex`, the prose has likely moved
ahead of the sidecar — say so and suggest `/tex2md`. Proceed only on confirmation.

## Worked example

**Sidecar (`introduction.md`), settled spine + exclusive zones mixed:**

```markdown
## Thesis (kept deliberately humble)
NanoEvolve is a small, didactic framework: read in an afternoon, run over a weekend.
It re-expresses the FunSearch/AlphaEvolve decomposition on the simplest substrate that runs.

## Open questions
- Do we name the LABS placeholder here or defer to the case study?   <- DO NOT carry over

## Notes
- Framing rule (author steer): never claim to advance the line of work it learns from.  <- meta, stays
```

**Realized into `introduction.tex` (house style, additive):**

```latex
We describe \emph{NanoEvolve}, a minimalist, didactic re-expression of the same loop,
reduced to the simplest substrate that still runs: a few markdown files, a handful of shell scripts, and a few coding-agent sessions.
It is meant to be read in an afternoon and run overnight on a single workstation.
```

The thesis (spine) is realized; the open question and the author-steer note stay in the
sidecar. The em-dash-free, one-sentence-per-line prose matches the section's register.

## Idempotency

Re-running `md2tex` on a section whose spine is already realized finds no missing/divergent
concepts and proposes nothing. Minor wording choices are the author's to refine; the skill does
not re-litigate already-realized prose.
