# ANALYSIS.md template — paper-vs-manuscript contrast

Fill this in and write it as `ANALYSIS.md` at the root of `resources/arXiv-<id>v<ver>/`.
The purpose is **decision-making**: a future agent (or the PI) reads this to see how the
paper relates to the manuscript in progress and what is worth lifting from it. Keep the
reading-note disclaimer when the PI is **not** an author. Make every "Suggestions" bullet
concrete and pointed at a real `sections/<file>.tex`.

The file opens with a **YAML frontmatter block** — the re-run / staleness signal. Capture
`manuscript_commit` from `git rev-parse --short HEAD` at write time (the manuscript is
tracked even though `resources/` is gitignored), and `manuscript_files` = the sections the
analysis actually engages with. A later `/diff-arxiv` run reads this block: if
`manuscript_commit` still equals `HEAD` the analysis is current and the run stops without
rewriting; if it differs (or the block is missing), the analysis is stale and the run
offers a refresh.

---

```markdown
---
skill: diff-arxiv
arxiv: <id>v<ver>
doi: 10.48550/arXiv.<id>
manuscript_commit: <short-sha at write time>
manuscript_files:
  - sections/<file>.tex
  - sections/<file>.tex
generated: <YYYY-MM-DD>
---

# Analysis — <Full Paper Title> vs. the manuscript

**arXiv:** <id>v<ver>   ·   **DOI:** 10.48550/arXiv.<id>
**Manuscript:** <main.tex title>  (compared against `main.tex` + `sections/*.tex` as of <date>)

> Note: this analysis is a reading note written for manuscript drafting.
> All technical credit belongs to the paper's authors; the PI is not an author.
<!-- drop the disclaimer if the PI is an author -->

## i. Summary

<3–8 sentences on the arXiv paper: the problem and setting, the section arc
(structure), the core contributions, the method, and the headline results/numbers.
This is the paper on its own terms — no comparison yet.>

## ii. Similarities

<Where the paper and the manuscript overlap. Be specific: shared problem or method
family, common framing, overlapping claims or experiments, and any place the
manuscript already touches this territory (name the `sections/<file>.tex`). Note if
the paper is already cited in `references.bib` / the prose.>

- <shared point 1 — and where it shows up in the manuscript>
- <shared point 2>

## iii. Differences

<What the paper does that the manuscript does not, and vice versa: scope, method
choices, assumptions, regime, results, what each strips vs. adds. Make the contrast
sharp — this is what makes the paper worth citing or distinguishing.>

- <difference 1 — paper does X; manuscript does Y / is silent>
- <difference 2>

## iv. Suggestions

<Bulleted, concrete things that could be lifted into the manuscript. Each bullet:
what to lift (a framing, a contrast, a number, a citation, a figure idea, a taxonomy
slot) and the exact `sections/<file>.tex` where it would land. Prefer specific over
generic.>

- **<file>.tex —** <what to add and why; e.g. cite as the single-small-LLM point in the taxonomy>
- **<file>.tex —** <a head-to-head number or contrast to include>
- **<file>.tex —** <a framing or distinction worth borrowing>
```
