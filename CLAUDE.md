# Canonical Academic Article Template

## Paper Metadata
- Title: (set in `main.tex`)
- Authors: (set in `main.tex`)
- Target venue: IEEE Transactions (journal mode by default)
- Document class: IEEEtran (journal); conference variant in `conf2026/`

## Folder Hierarchy
```
TemplateArticle/
├── main.tex                     # Top-level composer: inputs header, sections, footer
├── references.bib               # Project bibliography
├── justfile                     # Build: just / just view / just clean
├── PROGRESSION.md               # Section authoring: .tex/.md sidecar pairing + sync
├── .gitignore
│
├── templates/                   # Shared LaTeX infrastructure
│   ├── preamble.tex             # Full macro library
│   ├── header.tex               # \documentclass + \input preamble + \begin{document}
│   ├── footer.tex               # \bibliographystyle + \bibliography + \end{document}
│   ├── IEEEtran.cls             # IEEE document class
│   ├── IEEEabrv.bib             # IEEE abbreviations
│   └── IEEEbib.bst              # IEEE bibliography style
│
├── sections/                    # One .tex (shipped) + .md (sidecar) per section
│   ├── abstract.tex             #   abstract.md, introduction.md, ... pair with each .tex
│   ├── introduction.tex         #   .md = thinking layer (never \input; see PROGRESSION.md)
│   ├── system_model.tex
│   ├── main_results.tex
│   ├── numerical_experiments.tex
│   ├── conclusion.tex
│   └── appendix_proofs.tex
│
├── figures/                     # TikZ/PGFPlots .tex files and .dat data
│   ├── sample_line_plot.tex     # Sample: semilog-y performance plot
│   └── sample_bar_chart.tex     # Sample: grouped bar chart
├── output/                      # Compiled PDF + build artifacts
│
├── conf2026/                    # Conference proceedings (self-contained)
│   ├── main.tex, justfile, references.bib
│   ├── sections/, figures/, output/
│
├── conf2026_slides/             # Beamer slides
│   ├── main.tex, justfile
│   ├── figures/, output/
│
├── resources/                   # Local arXiv library (gitignored except CATALOG.md);
│                                #   CATALOG.md = triage layer, `just resources` lists what's on disk
├── scratch/                     # Ephemeral working area (gitignored except README.md);
│                                #   /capture writes scratch/LEARNINGS.md here
└── misc/                        # Scratch files, drafts
```

## Build Instructions
```bash
just          # Compile main.pdf to output/
just view     # Open the PDF
just clean    # Remove build artifacts
```
Conference and slides have their own justfiles in their directories.

## Notation Conventions (from preamble.tex)

### Math alphabet shortcuts
- `\mb{X}` = bold, `\mbb{X}` = blackboard, `\mc{X}` = calligraphic
- `\ms{X}` = sans-serif, `\msc{X}` = script, `\mf{X}` = fraktur

### Letter-family macros
- **Bold lowercase**: `\av` .. `\zv` (e.g., `\xv` = **x**)
- **Bold uppercase**: `\Av` .. `\Zv` (e.g., `\Xv` = **X**)
- **Bold+underlined uppercase**: `\Avu` .. `\Zvu`
- **Underlined lowercase**: `\au` .. `\zu`
- **Underlined uppercase**: `\Au` .. `\Zu`
- **Blackboard bold**: `\Ab` .. `\Zb` (e.g., `\Rb` = R)
- **Calligraphic**: `\cA` .. `\cZ`
- **Zapf Chancery**: `\pza` .. `\pzz`
- **Bold Greek**: `\alphav` .. `\zetav`, `\Gammav` .. `\Omegav`

### Core operators
- `\expt` = E (expectation), `\indicator{...}` = 1{...}
- `\abs{...}`, `\norm{...}`, `\argmin`, `\argmax`
- `\snr`, `\defeq` (triangleq), `\coleq` (:=)
- `\Pe` (error probability), `\indep` (independence)

### Author notes
- `\anote{text}` or `\anote[NAME: ]{text}` for inline comments (red)

## Figure Conventions
- Standard dimensions: **7cm wide x 5.5cm tall** (IEEE single-column width; height informed by golden ratio)
- Place TikZ/PGFPlots source in `figures/` as `.tex` files
- Data files for plots go in `figures/` as `.dat` files
- Input figures via `\input{figures/figure_name}` inside a `\begin{figure}` environment
- Two sample figures are included as starting points:
  - `sample_line_plot.tex` — semilog-y axis (MSE vs SNR), solid colored lines with marks, dashed gray reference
  - `sample_bar_chart.tex` — grouped bar chart (runtime vs configuration), filled bars with legend
- Color palette (defined in preamble): `mycolor1` (red), `mycolor2` (blue), `mycolor3` (green), `mycolor4` (orange), `mycolor5` (blue alt), `mycolor6` (magenta)
- Line width: 1.2--1.5pt for data, 1.2pt dashed for theoretical/reference curves
- Marks: `o` (circle), `triangle`, `square`, `diamond`, `asterisk`; size 1.4--3pt
- Grid: `grid=both`, major opacity 0.5, minor opacity 0.25
- Legend: corner-anchored, white fill, black border, `\footnotesize`, rounded corners

## Section File Conventions
- One file per section in `sections/`
- Each file starts with `\section{...}\label{sec:...}`
- Appendix sections go after `\appendices` in `main.tex`

## Section Authoring (Sidecars)
- Each `sections/<name>.tex` (shipped prose) is paired with a same-named `sections/<name>.md`
  *sidecar* (the thinking layer: scratch, ideas, the conceptual spine, decisions).
- The sidecar is **never** `\input` — invisible to the build, never in the PDF. Both are tracked.
- A section **progresses**: think in the `.md` first, realize settled concepts into the `.tex`,
  and late in the game feed prose-driven concept changes back to the `.md`. The lead flips from
  `.md` to `.tex` over the lifecycle.
- Tooling: `/md2tex` realizes settled sidecar concepts into the `.tex`; `/tex2md` feeds concept
  changes from the `.tex` back into the sidecar; `/progression` audits conceptual coherence
  *across* the sidecars (the through-line / tree); `/format-tex` and `/format-md` keep each
  register tidy. The sync and audit skills are surgical, additive, and ask before writing.
- Full convention and the concept-mapping rules: [`PROGRESSION.md`](PROGRESSION.md).

## Continuous Improvement
- `/capture` logs a gap/lesson/idea mid-session into `scratch/LEARNINGS.md` as a small blob —
  one append, one-line ack, no disruption to the current task. The inbox is ephemeral
  (gitignored); the scratch area and entry format are documented in
  [`scratch/README.md`](scratch/README.md).
- `/capture review` later triages that backlog and integrates each blob into its home (update a
  skill, write a new one, amend a doc, add a hook, save a memory, or drop it), then archives it.
