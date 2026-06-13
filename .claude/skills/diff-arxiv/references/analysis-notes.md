# diff-arxiv — analysis notes

How to produce a useful `ANALYSIS.md` that contrasts an ingested arXiv paper with the
manuscript in progress.

## Resolve the id & version

- Accept a bare id (`2511.23473`) or a versioned id (`2511.23473v1`).
- Glob `resources/arXiv-<id>v*/` to find the ingested folder. The canonical folder name is
  `arXiv-<id>v<ver>/` (hyphen, with version) — set by the `get-arxiv` skill.
- If multiple version dirs match, pick the **highest** `v<ver>` and say which one you used.

## Presence gate (hard stop)

If the glob matches **nothing**: STOP. Create no files, fetch nothing. Tell the user the
paper is not in `resources/` and to run `/get-arxiv <id>` first, then re-run `/diff-arxiv <id>`.
This skill never downloads — ingestion is `get-arxiv`'s job.

## Existence & staleness gate

If `resources/arXiv-<id>v<ver>/ANALYSIS.md` already exists, decide whether to re-run from
its YAML frontmatter rather than blindly overwriting. The header records `manuscript_commit`
— the manuscript HEAD the analysis was written against. `resources/` is gitignored, but the
manuscript (`main.tex`, `sections/*.tex`) **is** tracked, so the commit is a real reference.

Capture the current manuscript HEAD with `git rev-parse --short HEAD` and compare:

- **`manuscript_commit` == HEAD** → the manuscript has not moved since the analysis. STOP,
  do **not** rewrite, and report that an up-to-date analysis already exists.
- **`manuscript_commit` != HEAD** → the manuscript moved. The analysis is stale. Report it
  (*"written against `<old>`, manuscript now at `<new>`"*), and — helpfully — run
  `git diff --name-only <old> HEAD -- sections main.tex` to see whether any of the recorded
  `manuscript_files` actually changed. Offer a refresh; continue only on explicit confirmation.
- **no frontmatter (legacy file, pre-header)** → unknown basis. Report it and offer a
  refresh; continue only on explicit confirmation.

Never overwrite an existing `ANALYSIS.md` without one of these confirmations. A refresh
regenerates the whole file (new header + new body) against the current manuscript.

## Read plan — the paper side

Orient first, then go deep. Do not write the analysis off `SYNOPSIS.md` alone.

1. `resources/arXiv-<id>v<ver>/SYNOPSIS.md` — the existing reading note: problem, key
   contributions, numerical takeaways, and an existing "Relevance to the manuscript" section.
   This is your scaffold and your fastest path to the gist.
2. `resources/arXiv-<id>v<ver>/CLAUDE.md` — which file is the top-level `.tex`, where the
   section files live (`contents/`, `sections/`, or monolithic), the figure inventory, and
   build deviations. Tells you what to read next.
3. The actual source: the top-level `.tex` named in `CLAUDE.md` / `00README.json`, and its
   `\input`/`\include` section files. Read enough to state the paper's **section arc**
   (structure) and pin its **contributions** (claims, method, the key numbers) precisely.
   If the source is monolithic (one big `.tex`), read it directly.

## Read plan — the manuscript side

1. Top-level `main.tex` — which `sections/*.tex` are actually `\input`. Some section files
   exist on disk but are **not** wired in (e.g. an appendix dropped for a magazine pass);
   those are out of scope for the contrast. Only compare against what ships.
2. The `\input`'d `sections/*.tex` — the manuscript's framing, its related-work taxonomy,
   its case studies, its claims.
3. Check whether the paper is **already present**: grep `references.bib` for the arXiv id /
   author / title, and skim the prose for an existing `\cite`. If it is already cited, the
   analysis should focus on whether it is used to full effect.

## Contrast — what to extract

- **Similarities.** Shared problem or setting, same method family, common framing,
  overlapping claims or experiments, and every place the manuscript already touches this
  territory. Name the `sections/<file>.tex`.
- **Differences.** What the paper does that the manuscript does not, and the reverse:
  scope, method choices, assumptions/regime, results, what each one strips vs. adds. Sharp
  contrasts are what make a paper citable (or worth distinguishing from).

## Writing ANALYSIS.md

- Write to `resources/arXiv-<id>v<ver>/ANALYSIS.md` from `ANALYSIS-template.md`.
- **Open with the YAML frontmatter** — this is what makes a future run re-entrant:
  `skill: diff-arxiv`, `arxiv: <id>v<ver>`, `doi: 10.48550/arXiv.<id>`,
  `manuscript_commit: <git rev-parse --short HEAD>`, `manuscript_files:` (the sections the
  analysis engages — its Similarities/Differences/Suggestions targets), and
  `generated: <today>`. Capture the commit at write time, not earlier.
- Four sections, in order: **i. Summary**, **ii. Similarities**, **iii. Differences**,
  **iv. Suggestions**.
- **Summary** is the paper on its own terms — no comparison.
- **Suggestions** is the payoff: bulleted, concrete, lift-into-manuscript. Each bullet says
  what to lift (a framing, a contrast, a head-to-head number, a citation, a taxonomy slot, a
  figure idea) and the exact `sections/<file>.tex` where it lands. Prefer specific over
  generic — "cite in `related_approaches.tex` as the single-small-LLM AlphaEvolve descendant"
  beats "could be cited somewhere".
- Keep the reading-note disclaimer unless the PI is an author.
- If `ANALYSIS.md` already exists, ask before overwriting.

## Report

State the path written, the resolved version dir, the captured `manuscript_commit`, and a
one-line gist of the top 2–3 suggestions so the user can act without opening the file.
