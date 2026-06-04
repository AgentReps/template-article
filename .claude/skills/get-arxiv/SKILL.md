---
name: get-arxiv
description: Ingest an arXiv paper's LaTeX source into the local arXiv library under resources/, reshaped into a self-contained mini-project that mirrors this repo's TemplateArticle layout (original top-level .tex kept for jobname/.bbl coupling, macros and .bib moved to templates/, figures kept in figures/, plus a tailored justfile, CLAUDE.md build notes, and a discovery SUMMARY.md). Use when the user asks to "ingest an arXiv paper", "download arXiv source", "add 2402.08676 to my library/resources", "build my local arXiv", or "write a SUMMARY for a paper". Fetches and reshapes one paper per run; keeps referenced figures and the shipped .bbl, deletes only unused figures and build cruft.
---

# Ingest an arXiv Source into the Local Library

## What this does

Given an arXiv ID (e.g. `2402.08676`), this fetches the paper's LaTeX source and
reshapes it into a **self-contained mini-`TemplateArticle`** under
`resources/arXiv-<id>v<ver>/` — so the agent can read it, build it locally, and cite
it while drafting. The result mirrors this repo's own layout: the original top-level
`.tex` at root, macros and `.bib` in `templates/`, figures in `figures/`, plus a
`justfile`, `CLAUDE.md` build notes, and a discovery `SUMMARY.md`.

This is **not** a verbatim dump. It relocates files, fixes figure paths, emits a build
harness, and writes two human/agent-facing docs. It does **not** rewrite the paper's
prose, run `bibtex`, or reconstruct a `.bib` from a `.bbl`.

## When to use

- The user wants to add a paper to the local arXiv library (`resources/`).
- The user mentions an arXiv ID and "ingest", "download source", or "local arxiv".
- The user asks for a `SUMMARY.md` / reading note for a downloaded paper.

One paper per invocation. For a batch, run the workflow once per ID.

## Before you start

Read [references/arxiv-source-notes.md](references/arxiv-source-notes.md) — it has the
download URL, the tarball→folder-name rule, the `00README.json` schema, the jobname/`.bbl`
coupling, the metadata API, and the edge cases. The three output docs are generated from
[references/CLAUDE-template.md](references/CLAUDE-template.md),
[references/SUMMARY-template.md](references/SUMMARY-template.md), and
[references/justfile.template](references/justfile.template). Study a real processed
example to match the convention exactly: `~/ClaudeAMP/arXiv-2402.08676v1/`.

## Workflow

1. **Resolve & download.** `curl -L https://arxiv.org/e-print/<id>` to a temp file.
   The canonical arXiv tarball is named `arXiv-<id>v<ver>.tar.gz` — that name (hyphen,
   with version) **is the folder name**. Create `resources/arXiv-<id>v<ver>/` and extract
   into it. Detect the payload: gzipped tar (most papers), a single gzipped `.tex`, or a
   bare PDF. **If the payload is a PDF (source withheld/withdrawn), report and stop** —
   do not leave a half-populated folder. If the target folder already exists and is
   populated, stop and ask before overwriting.

2. **Find the top-level `.tex`.** Prefer `00README.json` → the `sources[]` entry with
   `"usage": "toplevel"`. Fallback: the `.tex` that contains `\documentclass`.
   **Keep its original name** — the precompiled `.bbl` shares that jobname, so renaming
   breaks the build. Keep `00README.json` as shipped.

3. **Reshape to mirror `TemplateArticle/`.**
   - Move macros (`.sty`, `commands.tex`) and the `.bib` into `templates/`. Omit the
     directory entirely if there's nothing to relocate.
   - Keep the top-level `.tex` and its `\input`/`\include` section files at the root
     (e.g. `appendix.tex`). Split the body into section files only where it's clean to do
     so — **a monolithic `.tex` is acceptable** and gets noted as a deviation.
   - Keep the precompiled `.bbl` at the root under the matching jobname.
   - **Keep referenced figures.** Move loose root figures into `figures/` and update their
     `\includegraphics` paths to match. Leave an already-existing `figs/` directory in
     place. Delete only **unused** figures and build cruft.

4. **Emit the build harness.** Write `justfile` from
   [references/justfile.template](references/justfile.template): set the jobname; it copies
   the precompiled `.bbl` into `output/` and runs two `pdflatex` passes with
   `TEXINPUTS/BIBINPUTS/BSTINPUTS=.:templates/:` — **no `bibtex`**.

5. **Write `CLAUDE.md`** from [references/CLAUDE-template.md](references/CLAUDE-template.md):
   Paper Metadata, Top-Level Files, Local Deviations from `TemplateArticle/`, Build.

6. **Write `SUMMARY.md`** from [references/SUMMARY-template.md](references/SUMMARY-template.md).
   Pull title/authors/abstract from the arXiv Atom API
   (`http://export.arxiv.org/api/query?id_list=<id>`) for accuracy. Add the DOI
   (`10.48550/arXiv.<id>`), key contributions, technical ingredients, numerical takeaways,
   and a **Relevance to the manuscript** section with concrete "Citable as:" pointers into
   the user's `sections/*.tex`.

7. **Verify & report.** Run `just` in the new folder to confirm it compiles. List the
   produced layout and flag anomalies: no `00README.json`, monolithic source, missing
   `.bbl`, or a multi-paper tarball.

## Quick reference

| | |
|---|---|
| Source download | `https://arxiv.org/e-print/<id>` |
| Folder name | `arXiv-<id>v<ver>/` (from the tarball name — hyphen, with version) |
| Top-level `.tex` | `00README.json` → `usage:"toplevel"`; else the file with `\documentclass` |
| DOI | `10.48550/arXiv.<id>` |
| Metadata API | `http://export.arxiv.org/api/query?id_list=<id>` |
| **Keep** | original-named top-level `.tex` + `.bbl`, `\input` section files, **referenced** figures, `.sty`/macros/`.bib` (→ `templates/`), `00README.json` |
| **Delete** | unused figures, and paper build cruft (`.log .aux .out .toc .synctex* .pdf`) |
| **Never** | rename the top-level `.tex`, run `bibtex`, reconstruct `.bib` from `.bbl`, or reword prose |

Full details, schema, and edge cases: [references/arxiv-source-notes.md](references/arxiv-source-notes.md).
