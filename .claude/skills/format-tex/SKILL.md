---
name: format-tex
description: Format a LaTeX (.tex) source file two ways, separately or together, without changing content or the compiled PDF. (1) Soft TEXBR — one sentence per source line (and a break at major clause boundaries of long sentences) for cleaner git diffs and blame. (2) Source hygiene — idempotent whitespace/structure tidy: strip trailing space, tabs to spaces, collapse blank-line runs, consistent float-body indentation, non-breaking ties (~) before \cite/\ref and after Fig./Sec./Eq., final newline. Use when the user asks to "format tex", "format latex", "semantic line breaks for latex", "one sentence per line", "tidy/clean up the latex source", "fix latex whitespace", or "make the tex diff-friendly". Reflows source line breaks and normalizes whitespace only; never touches wording, math, verbatim/listings, or aligned tabular content, and never changes the rendered output.
---

# Format LaTeX

This skill formats a `.tex` file along two independent axes. Pick whichever the user
asked for; run both when they want both. **Neither pass changes content or the compiled
PDF** — they only rearrange source line breaks and whitespace so `git diff`, `git blame`,
and merges behave.

- **Soft TEXBR** — reflow source line breaks to one sentence per line (cleaner diffs,
  unchanged render). Ruleset: [references/TEXBR.md](references/TEXBR.md).
- **Source hygiene** — idempotent whitespace/structure normalization (trailing space, tabs,
  blank-line runs, float-body indentation, non-breaking ties, final newline). Ruleset:
  [references/HYGIENE.md](references/HYGIENE.md).

Both share one discipline: **only prose outside of math is touched — never the inside of
math (`$...$`, `\[...\]`, `equation`/`align`/…), verbatim/`lstlisting`/`minted`, the aligned
interior of `tabular`/`array`, comments, or the command tokens themselves.** When applying
both, **run hygiene first, then TEXBR-reflow** (so sentence-breaking runs on cleaned text,
and ties are already glued before lines are split).

## Stability (idempotency)

Every rule here is designed so that **running the skill a second time produces essentially
no further change** — there is no state file or database; stability is a property of the
rules. Blank-line and tie normalization are exact fixed points; TEXBR breaks at meaning
boundaries that don't move once placed. Minor, judgment-call differences on a re-run are
acceptable and expected; large rewrites are a bug in how the rules were applied.

## When to use

- **TEXBR**: user mentions semantic line breaks, "one sentence per line," diff-friendly
  LaTeX, or a `.tex` file has multi-sentence paragraphs packed onto few long lines (or
  column-wrapped at ~80 chars) that pollute diffs.
- **Hygiene**: user wants the source tidied — trailing whitespace, tabs, ragged blank
  lines, missing `~` ties before citations/refs, inconsistent float indentation, no final
  newline.

Do **not** use either pass to change wording, fix grammar, restructure content, edit math,
or alter anything that changes the rendered PDF.

---

## Operation 1 — Soft TEXBR reflow

Rewrites the **source line breaks** of prose so each sentence (and each long, self-contained
clause) sits on its own line. LaTeX reflows single newlines into interword space, so the
rendered output is unchanged — the only thing that changes is the `git diff`, which becomes
one line per edited sentence instead of a whole rewrapped paragraph. This is the **soft**
variant: short phrases, asides, and tight coordinations stay inline.

### Workflow

1. **Read the full ruleset first.** Open [references/TEXBR.md](references/TEXBR.md) and
   follow it exactly — it is the source of truth for what does and does not get a break
   (abbreviations, math, citations, environments, the user's clause-boundary style).
2. **Identify what to reformat.** Apply TEXBR to prose paragraphs only. Leave untouched:
   math (inline and display), `verbatim`/`lstlisting`/`minted`/`comment`, the aligned body
   of `tabular`/`array`/`tabularx`, comment lines (`%`), preamble macro definitions, and any
   line that is a bare `\begin{...}`/`\end{...}`, `\label`, `\section`, or single command.
   `\caption{...}` and footnote/`\emph` *prose* may be reflowed (it is prose).
3. **Reformat in place** with the Edit tool, paragraph by paragraph:
   - Break after every sentence-ending `.`/`?`/`!` (respecting the abbreviation and
     decimal/version exceptions, and never on a `.` inside math or a comment).
   - In a *long* sentence, break at major internal boundaries — `;`, an em-dash `---`
     setting off a long aside, or a long subordinate clause (`because`, `although`,
     `which`, `that`…). Leave short tails (4–12 words) inline.
   - Keep a citation/ref glued to the word it follows (`programs~\cite{...}` stays as one
     unit on the sentence's line — see the tie rule in hygiene).
   - Never hard-wrap at a fixed column; never introduce a blank line inside a paragraph
     (a blank line is a `\par`).
4. **Preserve meaning and rendering.** Do not add, remove, or reword text, and do not touch
   math or commands. Word count and the compiled PDF must be identical before and after.
5. **Verify** only newline positions in prose changed (see Verification below).

### Quick reference

| Break here | Leave inline |
|---|---|
| End of a sentence (`.`/`?`/`!`) | A `.` in `e.g.`, `Fig.~3`, `Eq.~(2)`, `Dr.`, `et al.`, `0.5`, `v2`, a `\label` key, a URL |
| A `;` joining two long independent clauses | A `;` between short items |
| A long em-dash `---` aside or subordinate clause | A short aside / 4–12 word tail |
| Long list items in running prose | Short `A, B, and C` coordinations |
| **Never** inside math, verbatim, listings, or tabular cells | — |

Full rules, the user's clause-boundary style, and worked examples:
[references/TEXBR.md](references/TEXBR.md).

---

## Operation 2 — Source hygiene

Normalizes whitespace and a few structural conventions so the source is tidy and stable.
Every rule is a fixed point: re-running changes nothing. It does **not** reflow sentences
(that is TEXBR) and **never** changes the rendered PDF.

### Workflow

1. **Read the full ruleset first.** Open [references/HYGIENE.md](references/HYGIENE.md) — it
   has the exact normalizations, the scope guards, and the verification commands.
2. **Scope the edits.** Apply to prose and ordinary structure only. **Never** alter the
   interior of `verbatim`/`lstlisting`/`minted`/`comment` (whitespace there is literal), the
   aligned content of `tabular`/`array` cells, or characters inside math.
3. **Normalize, in order:**
   - Strip trailing whitespace from every line; convert leading tabs to spaces.
   - Collapse runs of **3+ blank lines to 2** (this leaves the author's 1-between-paragraphs
     and 2-before-`\subsection` gaps untouched — see the blank-line rule).
   - Indent float/list bodies consistently (2 spaces per nesting level) for `figure`,
     `table`, `itemize`/`enumerate`/`description` — but leave verbatim-like and aligned
     environments byte-for-byte.
   - Insert non-breaking ties: `word~\cite{}`, `word~\ref{}`/`\eqref{}`, and
     `Fig.~`/`Sec.~`/`Eq.~`/`Tab.~`/`Alg.~`/`Thm.~`… before a number or `\ref`.
   - Ensure the file ends with exactly one newline.
4. **Preserve content.** Only whitespace, blank-line counts, indentation, and space→tie
   changes — never a character of prose, math, or code.
5. **Verify** the diff is whitespace/tie-only and the PDF is unchanged.

### Quick reference

| Normalize | Leave alone |
|---|---|
| Trailing whitespace → removed; tabs → spaces | Interior of verbatim/listings/minted (literal) |
| 3+ blank lines → 2 (keep 1 and 2 gaps) | Aligned `tabular`/`array` cell whitespace |
| Float/list body indent → 2 spaces/level | Math content, command names |
| `word \cite` → `word~\cite`; `Fig. \ref` → `Fig.~\ref` | An existing `~`; ties inside math |
| File ends with one `\n` | The `% filename.tex` header comment |

Full normalization list, blank-line policy, tie table, and verification:
[references/HYGIENE.md](references/HYGIENE.md).

---

## Verification (both operations)

The contract is **identical rendered output**. After formatting:

1. **Diff check.** `git diff --stat` and a skim of `git diff` should show only moved
   newlines (TEXBR) and whitespace/tie changes (hygiene) — no prose, math, or command edits.
   `git diff -w` (ignore whitespace) should be **empty for hygiene** and show only
   line-break moves for TEXBR.
2. **Build check.** Recompile (`just build`) and confirm it still succeeds with no new
   warnings. The PDF should be byte-for-byte or visually identical; a non-breaking tie may
   only change where a line *could* break, never the words on the page.
3. If unsure whether a TEXBR break helps, leave the phrase inline — soft TEXBR is about
   meaningful units, not maximal splitting.
