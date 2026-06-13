# SUMMARY.md template — discovery reading note

Fill this in and write it as `SUMMARY.md` at the root of `resources/arXiv-<id>v<ver>/`.
The purpose is **discovery**: a future agent (or the PI) reads this to decide whether and how
the paper is relevant to the manuscript in progress. Pull title/authors/abstract from the
arXiv Atom API (`http://export.arxiv.org/api/query?id_list=<id>`) for accuracy. Model the
tone and depth on `~/ClaudeAMP/arXiv-2402.08676v1/SUMMARY.md`.

Keep the reading-note disclaimer when the PI is **not** an author. Make the
"Relevance to the manuscript" section concrete — point at real `sections/*.tex` files.

Open the file with a **YAML frontmatter block** — a lightweight provenance header for
consistency with `diff-arxiv`'s `ANALYSIS.md`. It is paper-only: `skill: get-arxiv`,
`arxiv: <id>v<ver>`, `doi: 10.48550/arXiv.<id>`, and `generated: <today>`. It carries **no**
`manuscript_commit` — a summary describes the (immutable) paper, so it cannot go stale
against the manuscript the way an analysis does.

---

```markdown
---
skill: get-arxiv
arxiv: <id>v<ver>
doi: 10.48550/arXiv.<id>
generated: <YYYY-MM-DD>
---

# <Full Paper Title>

**Authors:** <Name (affiliation), Name (affiliation), ...>
**Venue / status:** <venue, year; or preprint>
**arXiv:** <id>v<ver>   ·   **DOI:** 10.48550/arXiv.<id>

> Note: this summary is a reading note written for manuscript drafting.
> All technical credit belongs to the authors above; the PI is not an author.
<!-- drop the disclaimer if the PI is an author -->

## Problem and setting
<What problem, in what regime/assumptions. 2–5 sentences. Name the setting precisely.>

## Key contributions
- <contribution 1>
- <contribution 2>
- <contribution 3>

## Technical ingredients
- **<aspect, e.g. Algorithm / Model>.** <detail relevant to our work>
- **<aspect, e.g. Method / Proof technique>.** <detail>
- **<aspect, e.g. Assumptions / Regime>.** <detail>

## Numerical / experimental takeaways
<What the experiments show and how convincingly; the regime they cover.>

## Relevance to the manuscript
- <How it connects to our work; which result/section it bears on.>
- **Citable as:** in `sections/<file>.tex` <where and for what claim>;
  in `sections/<file>.tex` <as the tool/result we extend or contrast>.

## Open questions / limitations
- <limitation or open direction noted by the authors or evident to us>
- <another>
```
