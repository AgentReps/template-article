# Semantic Line Breaks (TEXBR) for LaTeX Sources

**One sentence per line.**
For a long sentence, break the source at the boundaries of meaning,
not at a fixed column.
The rendered output is unchanged —
LaTeX collapses a single newline inside a paragraph to interword space —
so what changes is the *diff*, not the PDF.

This mirrors the `format-md` SEMBR pass, adapted to LaTeX: the same one-sentence-per-line
goal, plus LaTeX-specific guards (math, citations, environments, comments).

## Why

- **Reviewable diffs.** Editing one sentence touches one line, so `git diff` and PR review
  highlight the actual change instead of a whole rewrapped paragraph.
- **Stable blame.** `git blame` points to the author of a *sentence*, not a wrapped fragment.
- **Better merges.** Co-authors editing different sentences in the same paragraph do not
  conflict.
- **Lower cognitive load.** Each line is a self-contained unit you can move, cut, or rephrase.

## House style (observed)

This project already writes prose one sentence per line and breaks long compound sentences
at their major joints. Match that:

- One independent sentence per line.
- A long sentence built from several long clauses joined by **semicolons** gets one clause
  per line (e.g. a list of methods each with its own citation).
- A long aside set off by an em-dash `---` goes on its own line; a short one stays inline.
- Citations and cross-references stay glued to their word: `programs~\cite{...}`,
  `Section~\ref{sec:...}`, `Fig.~\ref{fig:...}` — never split a `~` tie across a line break.

## Rules

1. **Break after every sentence.**
   A period, question mark, or exclamation mark that *ends a sentence* — **not** every period.
   Do **not** break after a period that is part of:
   - a LaTeX cross-reference abbreviation (`Fig.~3`, `Sec.~2`, `Eq.~(4)`, `Tab.~1`, `Alg.~2`,
     `Thm.~1`, `App.~A`),
   - a Latin abbreviation (`e.g.`, `i.e.`, `etc.`, `cf.`, `vs.`, `et al.`),
   - an initial or honorific (`C. E. Shannon`, `Dr. Smith`, `Prof. Chen`),
   - a decimal, version, or unit (`0.5`, `v2`, `4\times4`, `No.~7`),
   - anything inside math or a `\label{...}`/`\ref{...}`/`\cite{...}` argument, a filename,
     or a URL.

   Break when the next non-space character begins a new sentence (typically a capital letter
   starting a new independent clause). After `\@.` or an end-of-sentence inside `\emph{...}.`,
   treat it as a normal sentence end.
2. **Break a long sentence at its major internal joints.**
   - At a **semicolon** `;` that joins two long independent clauses — one clause per line.
   - Around a long **em-dash** `---` aside or a long subordinate clause introduced by
     *because, although, while, if, when, since, which, that, whereas*.
   - Leave **short** clauses, tails, and asides (roughly 4–12 words) on the same line — a
     tight phrase reads better inline than dangling alone.
3. **Break long list items in running prose** one per line; keep short coordinations
   (`A, B, and C`) inline.
4. **Do not hard-wrap at a column width.** No 80-column fill.
5. **Do not add or remove blank lines inside a paragraph.** A blank line is a `\par` — it
   changes the render. (Blank-line *counts between* paragraphs are handled by hygiene, not
   here.)
6. **Keep ties intact.** Never let a line break fall on a `~` (e.g. do not end a line with
   `Section~` and start the next with `\ref{...}`). The whole `word~\macro{...}` unit rides
   on the sentence's line.

**Overall aim:** the source should still read naturally for a human. If a break would split a
short, tight phrase and hurt readability, don't insert it — TEXBR is about meaningful units,
not maximal fragmentation. Minor judgment differences between runs are fine.

## Scope — never reflow these

- **Math.** Inline `$...$`, `\(...\)`; display `\[...\]`, `$$...$$`,
  `equation`/`align`/`gather`/`multline`/`eqnarray` (and starred forms). A `.` or `;` inside
  math is not a sentence boundary. Leave the body exactly as written.
- **Verbatim-like.** `verbatim`, `lstlisting`, `minted`, `comment`, and `\verb|...|` — the
  whitespace and line breaks there are literal output.
- **Tabular content.** The aligned interior of `tabular`/`array`/`tabularx` (cells separated
  by `&`, rows by `\\`) is laid out for readability; never reflow it.
- **Comments.** A line starting with `%` (or text after an unescaped `%`) is a comment — do
  not reflow it and do not treat its periods as sentence breaks. Keep the `% filename.tex`
  header line.
- **Structural lines.** A line that is a bare `\begin{...}`, `\end{...}`, `\section{...}`,
  `\subsection{...}`, `\label{...}`, `\item`, or a single self-contained command stays on its
  own line.

`\caption{...}`, footnotes, and emphasized prose **are** prose — reflow the sentences inside
them, keeping each continuation line at the paragraph's indentation.

## Example

### Before (paragraph packed onto few long lines):

```latex
The model suggests a new candidate, an automated evaluator scores it, the good candidates are retained while others are discarded, and the cycle repeats. The crucial point is that the model does not decide what counts as progress; a verifier does. Simulated annealing answers with a cooling schedule~\cite{kirkpatrick1983optimization}; genetic algorithms answer with a population under mutation and selection~\cite{holland1975adaptation}; island models keep semi-isolated subpopulations~\cite{tanese1989distributed}.
```

A one-word edit anywhere rewraps the rest of the paragraph, polluting the diff.

### After (TEXBR):

```latex
The model suggests a new candidate, an automated evaluator scores it, the good candidates are retained while others are discarded, and the cycle repeats.
The crucial point is that the model does not decide what counts as progress; a verifier does.
Simulated annealing answers with a cooling schedule~\cite{kirkpatrick1983optimization};
genetic algorithms answer with a population under mutation and selection~\cite{holland1975adaptation};
island models keep semi-isolated subpopulations~\cite{tanese1989distributed}.
```

Same compiled PDF. Note what TEXBR does *not* do:

- It does **not** break the short coordination `retained while others are discarded, and the
  cycle repeats` — those clauses are part of one flowing sentence (rule 2, short tails inline).
- It **does** put each semicolon-joined method on its own line, because each clause is long
  and carries its own citation (rule 2).
- It keeps every `~\cite{...}` glued to its clause (rule 6).

A targeted edit — e.g. changing one method's description — now touches exactly one line.

## Idempotency

Re-running TEXBR on already-broken prose is a near-fixed-point: sentence ends and major
clause joints do not move, so the second pass finds nothing to split. The only allowed drift
is a borderline short-vs-long clause judged differently — acceptable and minor.

## Cross-references

- `format-md` → `references/SEMBR.md` — the Markdown sibling of this pass.
- This document favors fewer line breaks than maximal sentence-splitting, matching the
  project's house style.
