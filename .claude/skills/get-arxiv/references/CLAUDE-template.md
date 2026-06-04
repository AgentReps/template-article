# CLAUDE.md template — local build notes for an ingested arXiv paper

Fill in the placeholders and write this as `CLAUDE.md` at the root of the
`resources/arXiv-<id>v<ver>/` folder. Keep it short and factual: it tells a future agent how
this particular paper is wired and where it deviates from the canonical `TemplateArticle/`
layout. Model it on `~/ClaudeAMP/arXiv-2402.08676v1/CLAUDE.md`.

---

```markdown
# arXiv:<id>v<ver> — Local Build Notes

## Paper Metadata
- **Title:** <full title>
- **Authors:** <authors with affiliations>
- **Venue / status:** <venue, year; or "preprint, v<ver>">
- **arXiv id:** <id>v<ver>

## Top-Level Files
- Top-level TeX: `<jobname>.tex` (kept under its original arXiv name to preserve the
  jobname/.bbl coupling).
- Bibliography: `templates/<name>.bib`, with `\bibliography{<name>}` resolved via
  `BIBINPUTS=.:templates/`. The `.bbl` file is the precompiled bibliography from the arXiv
  drop and is what the build actually uses.
- Macros: `templates/<name>.sty` (or `commands.tex`), loaded via
  `\usepackage{<name>}` / `\input{<name>}` and resolved via `TEXINPUTS=.:templates/`.
- Section content: `<section>.tex` is `\input` from `<jobname>.tex` and kept at the project
  root (treated as a section file, not a template).   <!-- omit if monolithic -->

## Local Deviations from `TemplateArticle/`
- <e.g. "Monolithic `.tex`; not split into `sections/*.tex`.">
- File names kept as `<jobname>.tex` / `<jobname>.bbl` to preserve the jobname/.bbl coupling.
- <e.g. "One loose figure (`plot_19.png`) moved into a new `figures/` directory; its
  single `\includegraphics` reference was updated."> / <"Existing `figs/` left in place.">
- The justfile does not call `bibtex`; the precompiled `.bbl` is copied into `output/`
  before each `pdflatex` pass.

## Build
```
just          # Compile <jobname>.pdf into output/
just view     # Open the PDF
just clean    # Remove output/
```
```
