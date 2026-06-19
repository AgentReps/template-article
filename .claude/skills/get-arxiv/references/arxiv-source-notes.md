# arXiv Source Notes

Reference detail for the `format-arxiv-source` skill. Ground-truth examples of a finished
ingest live in `~/ClaudeAMP/arXiv-*/` (e.g. `arXiv-2402.08676v1/`, `arXiv-2412.01511v2/`).

## Downloading the source

- **e-print endpoint:** `https://arxiv.org/e-print/<id>` — returns the original submission
  bundle. Use `curl -L` (it redirects) with a descriptive User-Agent. Be polite: one
  request per paper, no rapid loops.
- `<id>` may be given with or without a version (`2402.08676` vs `2402.08676v1`). If no
  version is supplied, arXiv serves the latest; capture the resolved version from the
  download (see folder name below).
- **Old-style IDs** exist (`hep-th/9901001`). The e-print URL still works; the folder name
  keeps the archive prefix.

### Tarball name → folder name (important)

The canonical download is named `arXiv-<id>v<ver>.tar.gz` (hyphen, version included).
**That base name is the destination folder name.** So `2402.08676v1` →
`resources/arXiv-2402.08676v1/`. Note this uses a **hyphen** (`arXiv-`), not the dot form
(`arXiv.`) used inside the DOI.

### Payload shapes (detect before extracting)

Inspect with `file` / magic bytes:

1. **gzipped tar** — the common case. Extract with `tar xzf` into the folder.
2. **single gzipped `.tex`** — a one-file paper. `gunzip` it and name it sensibly
   (`main.tex` if no better hint).
3. **bare PDF** — the author withheld source, or it was withdrawn. **Stop and report;**
   there is nothing to reshape. Do not create a half-populated folder.

## `00README.json` (arXiv manifest)

When present, this is the authoritative way to find the entry point:

```json
{
  "sources": [
    { "usage": "toplevel", "filename": "main_arxiv_final.tex" },
    { "usage": "ignore",   "filename": "gmac.bib" }
  ],
  "spec_version": 1,
  "texlive_version": "2025",
  "process": { "compiler": "pdflatex" }
}
```

- `usage: "toplevel"` → the file to compile (the jobname).
- `usage: "ignore"` → arXiv ignores it at build time (often the `.bib`, since a `.bbl` is
  shipped); keep it anyway — relocate the `.bib` into `templates/`.
- `process.compiler` tells you `pdflatex` vs `lualatex`/`xelatex`; the justfile template
  assumes `pdflatex` — adjust if the manifest says otherwise.
- Keep `00README.json` in the folder as shipped.

If there is no manifest, the top-level `.tex` is the one containing `\documentclass`.

## The jobname ↔ `.bbl` coupling (do not break this)

arXiv ships a **precompiled `.bbl`** instead of running BibTeX. `pdflatex` reads
`<jobname>.bbl`, so the `.bbl` base name must equal the top-level `.tex` base name.
Therefore:

- **Never rename the top-level `.tex`.** Keep `isit24.tex` as `isit24.tex` so `isit24.bbl`
  resolves.
- **Never run `bibtex`** in the build — the `.bbl` is authoritative.
- **Never reconstruct a `.bib` from the `.bbl`.** Keep whatever bibliography shipped, as-is.
  (The `.bib`, if present, is moved to `templates/` for reference, but the build uses the
  `.bbl`.)

## Target layout (mini-`TemplateArticle`)

```
resources/arXiv-<id>v<ver>/
├── <jobname>.tex          # original-named top-level file (has \documentclass)
├── <jobname>.bbl          # precompiled bibliography, matching jobname
├── <section>.tex ...      # \input section files kept at root (e.g. appendix.tex)
├── 00README.json          # arXiv manifest, as shipped (if any)
├── templates/             # macros (.sty, commands.tex) + .bib  — omit if nothing to move
├── figures/  (or figs/)   # LaTeX-native referenced figures (.tex/.tikz/.pgf); loose ones moved here, paths fixed
├── output/                # build dir (created by justfile)
├── justfile               # bbl-copy build, no bibtex
├── CLAUDE.md              # local build notes
└── SYNOPSIS.md            # discovery reading note
```

### Keep vs delete

- **Keep:** every `.tex`, the `.bbl`, `.sty`/macro files, the `.bib`, `00README.json`, and
  every **LaTeX-native** figure that is actually `\input`/`\includegraphics`'d
  (`.tex`/`.tikz`/`.pgf`, plus any `.dat`/`.csv` they consume).
- **Delete:** figures that nothing references, **every non-LaTeX-native figure binary**
  (`.pdf`/`.png`/`.jpg`/`.jpeg`/`.eps`/`.svg`) — its `\includegraphics` call site gets
  the figure-omission transform below — and paper build cruft (`.log .aux .out .toc
  .synctex.gz`, and any stray compiled `.pdf` of the paper itself).
- **Relocate:** `.sty`/macros + `.bib` → `templates/`; loose root LaTeX-native figures
  → `figures/` (then fix their `\input`/`\includegraphics` paths). Leave an existing
  `figs/` where it is.

## Figure omission transform (non-LaTeX-native graphics)

Tarballs heavy in binary figures (EPS/PDF/PNG/JPG/JPEG/SVG) burn ingest effort on paths
the reading agent will never look at. Rule: **keep the figure float, comment out the
`\includegraphics`, drop in a placeholder box, delete the binary.** The compiled PDF
still shows a labelled float, body `\ref{fig:foo}` cross-references still resolve, and
the folder stays free of orphan binaries.

### Resolving each call site

Walk every `.tex` in the ingest (top-level + `\input`/`\include` children). For each
`\includegraphics[opts]{path}`:

1. Resolve `path` against the unpacked tarball, honoring any `\graphicspath{...}`. If
   no extension was written, probe in order: `.tex`, `.tikz`, `.pgf`, then `.pdf`,
   `.png`, `.jpg`, `.jpeg`, `.eps`, `.svg`.
2. **LaTeX-native target** (`.tex`/`.tikz`/`.pgf`): keep, relocate into `figures/`,
   rewrite the path. Today's behavior.
3. **Non-LaTeX-native target** (`.pdf`/`.png`/`.jpg`/`.jpeg`/`.eps`/`.svg`, or path
   unresolvable but the written extension is in that set): apply the transform below
   and delete the file from the ingest.
4. **Truly unresolvable** (no extension, no probe hits): treat as non-native,
   transform, and note the orphan reference in `CLAUDE.md` deviations.

### The transform

Touch only the `\includegraphics` line. Leave `\begin{figure}`, `\caption`, `\label`,
and any surrounding code untouched.

```latex
\begin{figure}[t]
  \centering
  % get-arxiv: omitted figure <original-path-as-written>
  % \includegraphics[width=.8\linewidth]{foo.pdf}
  \fbox{\parbox{.5\linewidth}{\centering\textsf{[figure omitted in arXiv ingest]}}}
  \caption{The system block diagram.}
  \label{fig:system}
\end{figure}
```

The `% get-arxiv: omitted figure <path>` line is the audit marker — one per omission,
grep-able later with `grep -rn "get-arxiv: omitted" resources/arXiv-<id>v<ver>/`.

Inside subfigure environments (`\subfloat`, `subcaption`'s `\begin{subfigure}`), the
same per-call-site transform applies — the placeholder box just slots in where the
`\includegraphics` was.

### Counting & reporting

Total omissions go into the per-paper `CLAUDE.md` under "Local Deviations" as
`- Figures omitted: <N> non-LaTeX-native graphics commented out (grep "get-arxiv:
omitted" to list).` Drop the line when `<N>` is zero.

## Metadata for `SYNOPSIS.md` / `CLAUDE.md`

- **arXiv Atom API:** `http://export.arxiv.org/api/query?id_list=<id>` → returns an Atom
  feed with `<title>`, `<author><name>`, `<summary>` (abstract), and often `<arxiv:doi>` /
  `<arxiv:journal_ref>`. Use it for accurate title/authors/abstract rather than scraping
  the `.tex`.
- **DOI:** every arXiv paper has `10.48550/arXiv.<id>` (dot form, no `v<ver>` needed for the
  versionless DOI; versioned DOIs append `v<ver>`).

## Edge cases & how to handle them

- **No `00README.json`** → find `\documentclass`; note it in `CLAUDE.md` deviations.
- **Monolithic `.tex`** (no `\input` tree, possibly hundreds of KB) → leave it as one file;
  do not force a split. Record "not split into sections/*.tex" as a deviation.
- **Missing `.bbl`** but a `.bib` is present → the paper expects a BibTeX run. Prefer the
  shipped `.bbl` when it exists; if truly absent, note it and let the justfile fall back to a
  `bibtex` pass (deviation from the no-bibtex norm).
- **Multi-paper / multi-`\documentclass` tarball** → identify the intended top-level from
  the manifest; flag the extras in the report.
- **Loose unused source** (e.g. a stray `trash.tex` not `\input` anywhere) → leave it at the
  root rather than deleting; note it. (See `~/ClaudeAMP/arXiv-2402.08676v1/trash.tex`.)
- **`\graphicspath` already set** → leave the directive in place; the per-call-site
  resolution in the figure-omission transform already honors it. Don't move LaTeX-native
  figures out from under it without rewriting the path.
- **Subfigure macros** (`\subfloat`, `subcaption`'s `\begin{subfigure}`) → same
  per-call-site transform; the placeholder box slots in where the `\includegraphics`
  was, and the surrounding subfigure envelope plus its caption/label are preserved.
- **`\input`'d wrapper that itself does `\includegraphics`** (e.g. `\input{figures/foo}`
  where `foo.tex` calls `\includegraphics{foo.pdf}`) → recurse: keep the wrapper (it's
  LaTeX-native), but apply the transform to its inner `\includegraphics`. The wrapper
  stays, only the binary asset goes away.
