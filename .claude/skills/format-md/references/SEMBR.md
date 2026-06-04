# Semantic Line Breaks (SEMBR) for Markdown Sources

**One sentence per line.**
For very long line, break source lines at the boundaries of meaning,
not at a fixed column.
Rendered output is unchanged —
pandoc (like LaTeX and most Markdown renderers) reflows paragraphs —
so what changes is the *diff*,
not the PDF.

## Why

- **Reviewable diffs.** Editing one sentence touches one line,
  so `git diff` and PR review highlight the actual change.
- **Stable blame.** `git blame` points to the author of a *sentence*,
  not a wrapped fragment.
- **Better merges.** Co-authors editing different sentences in the same paragraph do not conflict.
- **Lower cognitive load when rewriting.** Each line is a self-contained unit you can move, delete, or rephrase.

## Rules

1. **Break after every sentence.**
   Period, question mark, exclamation mark that ends a sentence —
   **not** every period.
   Do **not** break after a period that is part of:
   - an initial in a personal name (`Eric J. Smith`, `C. E. Shannon`),
   - an honorific or title (`Dr. Smith`, `Prof. Chen`, `Mr.`, `Mrs.`, `Ms.`),
   - a Latin abbreviation (`e.g.`, `i.e.`, `etc.`, `cf.`, `vs.`),
   - a unit, ordinal, or versioned name (`Fig. 3`, `Sec. 2`, `vol. 4`, `No. 7`, `U.S.`, `Ph.D.`),
   - a decimal number (`0.5`), a URL, a filename, a citation key.

   Break when the next character (after whitespace) begins a new sentence —
   typically a capital letter starting a new independent clause.
2. **Break before a very long subordinate clause**
   introduced by *because, although, while, if, when, since, which, that*.
   Leave short subordinate clauses inline —
   a 4–12 word tail reads better on the same line than dangling on its own.
3. **Break around very long parentheticals** and nonrestrictive relative clauses.
   Short asides (a handful of words) stay inline.
4. **Break a list only when items are very long.**
   `A, B, and C` with short items stays on one line.
   Break to one-item-per-line when items are phrases or long clauses.
5. **Do not hard-wrap at a column width.** No 80-column fill.
6. **Do not leave blank lines inside a paragraph.**
   Blank lines are paragraph breaks in Markdown, same as in LaTeX.

**Overall aim:** the source should still read naturally for a human.
If a line-break would split a short, tight phrase and hurt readability, don't insert it —
SEMBR is about meaningful units, not maximal fragmentation.

## Markdown-specific notes

- **Soft line breaks inside a paragraph are spaces.**
  Pandoc (and CommonMark) treat a single newline inside a paragraph as whitespace,
  so SEMBR line breaks do not appear in the rendered output.
  To force a visible line break, end the line with two trailing spaces or a backslash.
- **Lists** are sensitive to blank lines.
  A blank line between items turns a tight list into a loose one
  (extra vertical space in the render).
  Keep SEMBR breaks *inside* a list item,
  not *between* items,
  unless you actually want a loose list.
- **Tables and fenced code** are not reflowed.
  SEMBR applies only to prose paragraphs;
  leave tables and code blocks formatted for direct readability.

## Example

### Not SEMBR (column-wrapped at ~80 chars):

```
A useful evaluation note states the question in the first sentence, describes
the method in terms a non-specialist can follow, and closes with a recommendation
that is specific, owned, and time-bounded — vague next steps ("we should look
into this") are the leading cause of notes that get read and then ignored.
```

A one-word edit anywhere in this paragraph rewraps every subsequent line,
polluting the diff.

### SEMBR:

```
A useful evaluation note states the question in the first sentence,
describes the method in terms a non-specialist can follow,
and closes with a recommendation that is specific, owned, and time-bounded —
vague next steps ("we should look into this") are the leading cause of notes that get read and then ignored.
```

Same rendered PDF.
Note what the SEMBR version does *not* do:

- It does **not** break the short coordination `specific, owned, and time-bounded` into one line per item —
  the items are short and read fine inline (rule 4).
- It does **not** break the short parenthetical `("we should look into this")` onto its own line (rule 3).
- It **does** break between the three independent clauses joined by commas,
  because each is long and each conveys a distinct idea (rule 2).

A targeted edit — e.g., changing `get read and then ignored` to `sit on a shared drive untouched` — touches exactly one line.

## Cross-references

- sembr.org — the original convention.
- This document favors few linebreaks than the original convenstion.