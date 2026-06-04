---
name: format-md
description: Format a Markdown (.md) file two ways, separately or together. (1) Soft Semantic Line Breaks (SEMBR) — one sentence per line for cleaner git diffs. (2) Pandoc-clean — strip emoji, icons, badges, raw HTML, and exotic Unicode so the file converts cleanly to PDF via pandoc. Use when the user asks to "format md", "apply semantic line breaks", "sembr this file", "one sentence per line", "make this pandoc/PDF-ready", "clean up this markdown", or "strip the emoji/icons". Reflows source lines and removes render-breaking decoration only; never changes wording, code blocks, or table data.
---

# Format Markdown

This skill formats a `.md` file along two independent axes. Pick whichever the user
asked for; run both when they want both.

- **Soft SEMBR** — reflow source line breaks to one sentence per line (cleaner diffs,
  unchanged render). Ruleset: [references/SEMBR.md](references/SEMBR.md).
- **Pandoc-clean** — strip emoji/icons/badges/raw-HTML/exotic-Unicode so the file
  converts cleanly to PDF via pandoc. Ruleset: [references/PANDOC.md](references/PANDOC.md).

Both share one discipline: **only prose, headings, list text, and table cells are
touched — never the inside of fenced code blocks or inline code.** When applying both,
**pandoc-clean first, then SEMBR-reflow** (so line-breaking runs on cleaned text).

## When to use

- **SEMBR**: user mentions SEMBR, semantic line breaks, "one sentence per line," or wants
  reviewable diffs; or a source has column-wrapped (~80 char) paragraphs that pollute diffs.
- **Pandoc-clean**: user wants a downloaded/exported `.md` to become PDF-ready, mentions
  pandoc, or asks to remove emoji, icons, badges, or "weird characters" that don't render.

Do **not** use either pass to change wording, fix grammar, or restructure content.

---

## Operation 1 — Soft SEMBR reflow

Rewrites the **source line breaks** of prose so each sentence (and each long,
self-contained clause) sits on its own line. The rendered output is unchanged — Markdown
reflows soft line breaks into spaces — so the only thing that changes is the `git diff`,
which becomes one line per edited sentence instead of a whole rewrapped paragraph. This is
the **soft** variant: fewer breaks than the original sembr.org convention; short phrases,
asides, and lists stay inline.

### Workflow

1. **Read the full ruleset first.** Open
   [references/SEMBR.md](references/SEMBR.md) and follow it exactly — it is the
   source of truth for what does and does not get a break (abbreviations,
   subordinate clauses, lists, Markdown-specific cases).
2. **Identify what to reformat.** Apply SEMBR to prose paragraphs only.
   Leave untouched: fenced code blocks, tables, YAML/TOML frontmatter, headings,
   link reference definitions, and the inside of inline code.
3. **Reformat in place** with the Edit tool, paragraph by paragraph:
   - Break after every sentence-ending `.`/`?`/`!` (respecting the abbreviation
     exceptions in the reference).
   - Break before/around *very long* subordinate clauses and parentheticals;
     leave short ones inline.
   - Break long list items one-per-line; keep short coordinations (`A, B, and C`)
     inline.
   - Never hard-wrap at a fixed column; never introduce blank lines inside a paragraph.
4. **Preserve meaning and rendering.** Do not add, remove, or reword any text.
   Word count and rendered output must be identical before and after.
5. **Verify** the rendered result is unchanged: only newline positions in prose
   should differ in the diff. If unsure whether a break helps readability, leave
   the phrase inline — soft SEMBR is about meaningful units, not maximal splitting.

### Quick reference

| Break here | Leave inline |
|---|---|
| End of a sentence | A period in `e.g.`, `Fig. 3`, `Dr. Smith`, `0.5`, a URL |
| A long subordinate clause (`because…`, `although…`) | A short 4–12 word tail |
| A long parenthetical / nonrestrictive clause | A short aside |
| Long list items (phrases/clauses) | Short `A, B, and C` lists |

Full rules, rationale, and worked examples: [references/SEMBR.md](references/SEMBR.md).

---

## Operation 2 — Pandoc-clean for PDF

Strips or normalizes material that breaks (or muddies) a `pandoc in.md -o out.pdf`
conversion: emoji and icons, decorative Unicode, badges/shields, raw HTML, and GitHub-only
syntax (alert blockquotes, anchor tags). It is a **soft** clean — remove what is decorative
or render-breaking, but **keep meaning**: translate a meaningful icon to a short text label
rather than deleting the information.

### Workflow

1. **Read the full ruleset first.** Open
   [references/PANDOC.md](references/PANDOC.md) — it has the strip/replace/relabel tables,
   the structural pandoc-compatibility rules, and the verification commands.
2. **Scope the edits.** Clean prose, headings, list text, and table cells only. **Never**
   touch the inside of fenced code blocks or inline code; leave URLs, math, and legitimately
   meaningful Unicode (accented names, real math symbols) intact.
3. **Clean, in priority order:**
   - Remove pure decoration (emoji, zero-width chars, nerd-font/PUA glyphs, box-drawing).
   - Relabel meaning-carrying icons to text (`✅ X` → `Supported: X`, `⚠️` → `Warning:`).
   - Convert GitHub-only syntax (`> [!NOTE]` → `> **Note:**`, task lists, `<a name>`).
   - Replace raw HTML (badges, `<div>`, `<details>`, `<br>`) with Markdown or remove it.
   - Normalize exotic spaces/arrows/bullets to ASCII; keep curly quotes and em/en dashes.
4. **Preserve content.** Remove decoration and noise only — never drop a sentence, a code
   sample, or table data.
5. **Verify** with `grep -nP '[^\x00-\x7F]' file.md` (review remaining non-ASCII; ignore
   hits inside code) and, if pandoc is available,
   `pandoc file.md -o /tmp/check.pdf --pdf-engine=xelatex` — the build should succeed with no
   missing-glyph boxes.

### Quick reference

| Remove / replace | Keep |
|---|---|
| Emoji & icons `✅ ⚠️ 🚀` (relabel if meaningful) | Accented names, real math symbols |
| Zero-width / nerd-font / box-drawing chars | Curly quotes `“ ”`, em/en dash `— –` |
| Badges, `<img>` shields, `<div>`, `<details>`, `<a name>` | Pipe tables, fenced code (verbatim) |
| GitHub alerts `> [!NOTE]`, decorative `━━━` rules | URLs, math `$...$`, footnotes |
| Exotic spaces, arrows `→`, bullet glyphs `•` | Standard Markdown structure |

Full rules, relabel map, structural fixes, and a worked example:
[references/PANDOC.md](references/PANDOC.md).
