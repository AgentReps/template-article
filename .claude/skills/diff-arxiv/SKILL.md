---
name: diff-arxiv
description: Contrast an ingested arXiv paper against the manuscript in progress and write an ANALYSIS.md into the paper's resources/ folder. Use when the user gives an arXiv id and asks to "diff arxiv", "compare this paper to our manuscript", "what can we lift from 2511.23473", "analyze 2506.13131 against our draft", or "write an ANALYSIS for a paper". Globs resources/arXiv-<id>v*/ to resolve the version; only if the paper is present does it deep-read the paper (SYNOPSIS.md, CLAUDE.md, the top-level .tex + section files) and the manuscript (main.tex + sections/*.tex), then emit ANALYSIS.md with a YAML provenance header (manuscript_commit) and four sections — Summary, Similarities, Differences, and Suggestions (bulleted, lift-into-manuscript). Re-run safe: an existing ANALYSIS.md whose manuscript_commit equals the current git HEAD is up to date and is NOT rewritten; a differing or missing commit means stale and the run offers a refresh. If the paper is absent it stops and tells the user to run get-arxiv first.
---

# Diff an Ingested arXiv Paper Against the Manuscript

## What this does

Given an arXiv id, locate the matching paper under `resources/arXiv-<id>v<ver>/`,
deep-read both the **paper** (its already-ingested LaTeX plus the `SYNOPSIS.md` /
`CLAUDE.md` reading notes) and the **manuscript in progress** (top-level `main.tex`
and `sections/*.tex`), then write `ANALYSIS.md` at the root of the paper's folder.
The analysis contrasts the paper's structure and contributions with the manuscript
and ends with a bulleted list of concrete things that could be **lifted into** the
manuscript.

This is the **deep-dive tier** of the library's three-tier navigation (triage
`CATALOG.md` → synopsis `SYNOPSIS.md` → deep dive): it starts from the synopsis and goes
into the paper's source. This skill **reads and compares**; it does not modify the manuscript,
re-fetch the paper, or re-derive its results. The paper's `SYNOPSIS.md` is a strong starting
point but is not a substitute for reading the paper's actual source.

## When to use

- The user gives an arXiv id and asks to compare/diff it against our draft.
- The user asks "what can we lift / borrow / cite from <paper>".
- The user asks for an `ANALYSIS.md` for an ingested paper.
- The paper is already ingested in `resources/` (if not, this skill redirects to `get-arxiv`).

One paper per invocation.

## Before you start

Read [references/analysis-notes.md](references/analysis-notes.md) — it has the
version-resolution rule, the presence gate, the read plan for both sides, and what
each `ANALYSIS.md` section must contain. The output is generated from
[references/ANALYSIS-template.md](references/ANALYSIS-template.md). For context on how
the paper folder is laid out, see the sibling `get-arxiv` skill; for how a reading
note reads, study an existing `resources/arXiv-*/SYNOPSIS.md`.

## Workflow

1. **Resolve the id & version.** Accept a bare (`2511.23473`) or versioned
   (`2511.23473v1`) id. Glob `resources/arXiv-<id>v*/` to find the ingested folder.
   If multiple version dirs match, pick the highest `v<ver>` and note which one you chose.

2. **Presence gate (hard stop).** If the glob matches **nothing**, STOP — write no
   files, fetch nothing — and tell the user:
   *"Paper `<id>` is not in `resources/`. Run get-arxiv first: `/get-arxiv <id>`, then
   re-run `/diff-arxiv <id>`."*

3. **Existence & staleness gate.** If `resources/arXiv-<id>v<ver>/ANALYSIS.md` already
   exists, read its YAML frontmatter and compare `manuscript_commit` to the current
   manuscript HEAD (`git rev-parse --short HEAD`):
   - **commit matches HEAD** → the analysis is current. STOP, do **not** rewrite, and
     report that an up-to-date analysis already exists.
   - **commit differs from HEAD** → the manuscript moved. Report it as stale
     (*"written against `<old>`, manuscript now at `<new>`"*); optionally name which of
     the recorded `manuscript_files` changed (`git diff --name-only <old> HEAD`). Offer a
     refresh and only continue on explicit confirmation.
   - **no frontmatter (legacy file)** → unknown basis. Report it and offer a refresh;
     only continue on explicit confirmation.
   Never overwrite an existing `ANALYSIS.md` without one of these confirmations.

4. **Deep-read the paper.** Read `SYNOPSIS.md` and `CLAUDE.md` for orientation (title,
   contributions, figure inventory, build deviations), then read the actual source:
   the top-level `.tex` named in `CLAUDE.md` / `00README.json` and its `\input` section
   files. Build a precise picture of the paper's **structure** (its section arc) and its
   **contributions** (claims, method, key numbers). Do not rely on `SYNOPSIS.md` alone.

5. **Read the manuscript.** Read top-level `main.tex` to see which `sections/*.tex` are
   actually `\input` (some may be on-disk-only and out of scope), then read those section
   files. Note the manuscript's framing, its taxonomy/related-work structure, its case
   studies, and where the paper already appears (search the prose and `references.bib`).

6. **Contrast.** Identify, with specifics:
   - **Similarities** — shared problem, method family, framing, overlapping claims or
     experiments, places the manuscript already touches this territory.
   - **Differences** — what the paper does that the manuscript does not (and vice versa):
     scope, method choices, assumptions, results, what is stripped vs. added.

7. **Write `ANALYSIS.md`** at `resources/arXiv-<id>v<ver>/ANALYSIS.md` from
   [references/ANALYSIS-template.md](references/ANALYSIS-template.md). Open with the YAML
   frontmatter: `skill: diff-arxiv`, `arxiv`, `doi`, `manuscript_commit` (capture now with
   `git rev-parse --short HEAD`), `manuscript_files` (the sections the analysis engages),
   and `generated` (today's date). Then four sections: **i. Summary** (of the arXiv paper),
   **ii. Similarities** (with the manuscript), **iii. Differences** (from the manuscript),
   **iv. Suggestions** (bulleted — what could be lifted into the manuscript). Make every
   suggestion concrete and point at a real `sections/<file>.tex` where it would land.

8. **Report.** State the path written, the resolved version dir, the captured
   `manuscript_commit`, and a one-line gist of the top 2–3 suggestions.

## Quick reference

| | |
|---|---|
| Resolve version | glob `resources/arXiv-<id>v*/`; multiple → highest `v<ver>` |
| Not present | STOP — tell user to run `/get-arxiv <id>` first; write nothing |
| Already analyzed | read `ANALYSIS.md` frontmatter: `manuscript_commit == HEAD` → STOP (current, don't rewrite); differs/missing → stale, offer refresh |
| Manuscript HEAD | `git rev-parse --short HEAD` (manuscript is tracked; `resources/` is gitignored) |
| Paper sources | `<paper>/SYNOPSIS.md` + `CLAUDE.md` for orientation, then the top-level `.tex` + its `\input` files for depth |
| Manuscript sources | top-level `main.tex` → the `\input`'d `sections/*.tex` (ignore on-disk-only files) |
| Output | `resources/arXiv-<id>v<ver>/ANALYSIS.md` (YAML header + 4 sections) |
| Header | `skill, arxiv, doi, manuscript_commit, manuscript_files, generated` |
| Sections | i. Summary · ii. Similarities · iii. Differences · iv. Suggestions (bulleted) |
| Suggestions | concrete, lift-into-manuscript, each pointed at a real `sections/<file>.tex` |
| **Never** | edit the manuscript, re-fetch/re-derive the paper, or overwrite a current/unconfirmed `ANALYSIS.md` |

Full read plan and per-section guidance: [references/analysis-notes.md](references/analysis-notes.md).
