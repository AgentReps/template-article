# LaTeX Source Hygiene (idempotent whitespace & structure)

Make a `.tex` file tidy and stable without changing a character of content or the rendered
PDF. Every rule below is a **fixed point**: applying it to an already-clean file changes
nothing, so the pass is safe to run repeatedly. This is the LaTeX sibling of `format-md`'s
pandoc-clean pass — but where pandoc-clean removes render-breaking decoration, hygiene only
normalizes source whitespace and a couple of typographic ties.

## Scope (same discipline as TEXBR)

Apply to prose and ordinary document structure only. **Never** alter:

- the interior of `verbatim`, `lstlisting`, `minted`, `comment`, or `\verb|...|` — every
  space and newline there is literal output;
- the aligned content of `tabular`/`array`/`tabularx` cells (laid out by hand for
  readability);
- characters inside math (`$...$`, `\[...\]`, `equation`/`align`/…);
- the command tokens themselves (names, braces, optional args).

Leave `.bib` files and `templates/preamble.tex`'s hand-aligned macro tables to their own
conventions unless the user asks for them specifically.

## Normalizations (apply in this order)

1. **Trailing whitespace.** Remove spaces/tabs at end of every line. (Skip verbatim-like
   interiors.)
2. **Tabs to spaces.** Convert leading tabs to spaces. The project indents with **2 spaces**
   per level. Do not retab inside verbatim/aligned environments.
3. **Blank-line runs.** Collapse any run of **3 or more** blank lines to **2**. Do **not**
   touch runs of 1 or 2 — the house style uses one blank line between paragraphs and two
   blank lines before a `\subsection`/`\paragraph`, and both must survive untouched. (This is
   what keeps the pass idempotent and low-churn on existing files.)
4. **Float / list body indentation.** Indent the body of `figure`, `table`, `table*`,
   `itemize`, `enumerate`, and `description` by 2 spaces per nesting level; the `\begin{...}`
   and `\end{...}` lines sit at the enclosing level. Example:

   ```latex
   \begin{figure}[t]
     \centering
     \input{figures/architecture_loop}
     \caption{...}
     \label{fig:architecture_loop}
   \end{figure}
   ```

   **Do not** re-indent the interior of `tabular`/`array`/`tabularx`, math environments, or
   verbatim-like environments — their internal alignment is content. Computing indent purely
   from `\begin`/`\end` nesting makes this a fixed point.
5. **Non-breaking ties (`~`).** Replace the single space with a `~` in these patterns (an
   existing `~` is already correct — leave it):
   - a word immediately before a citation or reference macro:
     `solution \cite{...}` → `solution~\cite{...}`; same for `\ref`, `\eqref`, `\pageref`,
     `\cref`/`\Cref`;
   - a cross-reference abbreviation before a number or `\ref`:
     `Fig. \ref{...}` → `Fig.~\ref{...}`; same for `Sec.`, `Eq.`, `Tab.`, `Alg.`, `Ch.`,
     `Thm.`, `Lem.`, `Def.`, `Prop.`, `Cor.`, `App.`, `Eqs.`, `Figs.`
   Only touch a *single* normal space; never insert a tie inside math, inside a comment, or
   across a line break that TEXBR placed.
6. **Final newline.** Ensure the file ends with exactly one `\n` (no missing newline, no
   trailing blank lines).

## Optional (flag, do not force)

These match the project's style but are judgment calls; mention them rather than rewriting
silently unless the user asked for a full tidy:

- A `% filename.tex` header comment as the first line of each section file.
- One `\begin{...}`/`\end{...}` per line (don't split inline `$...$` or short macros).
- A single space after a sentence period in source (LaTeX ignores the difference; TEXBR's
  one-sentence-per-line makes it moot anyway).

## Leave alone

Wording, math, command names and arguments, verbatim/listing/minted interiors, aligned
tabular cells, `.bib` entries, and any `~` already in place. Hygiene never adds, removes, or
reorders content.

## Relationship to TEXBR

Orthogonal passes. When doing both, **run hygiene first, then TEXBR** — ties are glued and
whitespace is clean before sentences are split, so line-breaking operates on tidy source.
Either pass can be run alone.

## Verify

1. Confirm the diff is whitespace/tie-only:
   ```
   git diff -w
   ```
   For a hygiene-only run this should be **empty** (all changes are whitespace) except for
   the inserted `~` ties — review those lines specifically.
2. Confirm it still builds with no new warnings:
   ```
   just build
   ```
3. Skim the PDF (or compare page count / a visual diff): identical. A `~` tie only changes
   where a line *may* break, never the words on the page.

## Idempotency

Trailing-space removal, tab conversion, the 3+→2 blank-line cap, nesting-based indentation,
already-present ties, and the single final newline are all exact fixed points: a second run
finds nothing to change.
