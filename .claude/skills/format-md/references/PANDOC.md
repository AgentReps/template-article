# Pandoc-Clean Markdown (for clean PDF export)

Make a Markdown file convert cleanly to PDF via pandoc (`pandoc in.md -o out.pdf`).
Downloaded `.md` files — READMEs, AI chat exports, docs — are often littered with emoji,
icons, badges, raw HTML, and exotic Unicode that either crash the LaTeX run, render as
missing-glyph boxes (□), or add visual noise without meaning. This pass strips or
normalizes that material while **preserving the actual content**.

It is a **soft** clean: remove what is decorative or breaks the render; keep anything that
carries meaning (translate a meaningful icon to a short text label rather than deleting it).

## Why pandoc → PDF is picky

- The default `--pdf-engine=pdflatex` has **no glyph** for most emoji/symbols and errors or
  drops them. `xelatex`/`lualatex` tolerate Unicode but still box-out emoji without a color
  font. Either way, decorative glyphs are a liability.
- **Raw HTML** (badges, `<div>`, `<details>`, `<img>` shields) is passed through by pandoc
  and mostly **vanishes or errors** in a LaTeX PDF.
- GitHub-flavored extras (alert blockquotes, task lists, anchor tags) are **not standard
  pandoc** and render oddly.

## Scope (same discipline as SEMBR)

Clean **prose, headings, list text, and table cells only**. **Never** alter the inside of
fenced code blocks or inline code — characters there are literal content. Leave URLs, math
(`$...$`), and legitimately meaningful Unicode (accented names like `Erdős`, `é`, `ü`;
real math symbols) intact — `xelatex`/`lualatex` handle those fine.

## Character cleanup

### Strip entirely (decorative, no semantic value)

| Category | Examples | Action |
|---|---|---|
| Emoji & pictographs | ✅ ❌ ⚠️ 🚀 📁 🔥 💡 🎯 ✨ 🎉 👍 | remove (or relabel — see below) |
| Variation selectors / ZWJ | U+FE0F, U+200D | remove |
| Zero-width spaces | U+200B / U+200C / U+FEFF (BOM) | remove |
| Nerd-font / Private Use Area | U+E000–U+F8FF glyphs | remove |
| Box-drawing / blocks | ─ │ ┌ ┐ █ ▀ (when decorative) | remove |
| Decorative separators | `━━━`, `═══`, `▬▬▬` rules | replace with `---` |

### Replace with an ASCII / text equivalent

| Character | Replace with |
|---|---|
| Non-breaking / thin / hair space (U+00A0, U+2009, U+200A) | regular space |
| Decorative bullet `•` `◦` `▪` `▶` used as a list marker | `-` |
| Arrows `→ ← ⇒ ⇐` in prose | `->` `<-` `=>` `<=` |
| Standalone check/cross `✓ ✗` | `(yes)` / `(no)`, or drop |
| Ellipsis `…` | keep (pandoc handles it) or `...` |
| Curly quotes `“ ” ‘ ’`, em/en dash `— –` | **keep** — pandoc renders these correctly. Only straighten them if you must target bare `pdflatex` without `unicode-math`. |

### Relabel meaning-carrying icons (don't just delete)

When an icon conveys status, turn it into a short text prefix; when it's pure decoration
(e.g. an emoji in a heading), drop it.

| Was | Becomes |
|---|---|
| `✅ Supports X` | `Supported: X` (or `- [x] X` in a checklist context) |
| `❌ No Windows` | `Not supported: Windows` |
| `⚠️ Don't do Y` | `Warning: don't do Y` |
| `💡 Tip: …` / `ℹ️ Note: …` | `Tip: …` / `Note: …` |
| `## 🚀 Getting Started` | `## Getting Started` |

## Structural pandoc-compatibility

- **Raw HTML → Markdown or remove.** Badges/shields (`<img src="...badge...">`),
  `<div>`/`<span>` wrappers, `<a name="anchor">` tags: delete. `<br>` → end the line with a
  blank line (paragraph) or two trailing spaces (hard break). Flatten `<details>/<summary>`
  to a normal heading + body.
- **GitHub alert blockquotes.** `> [!NOTE]` / `> [!WARNING]` / `> [!TIP]` are not pandoc
  syntax — convert to a plain blockquote with a bold lead: `> **Note:** …`.
- **Task lists.** `- [ ]` / `- [x]` render as checkbox glyphs only with `-f gfm` and a
  capable engine. For a clean PDF, prefer converting to `- ` plus a `(done)`/`(todo)` tag,
  unless the user wants real checkboxes and is converting with `-f gfm`.
- **Tables.** Keep GitHub **pipe tables**; convert any HTML `<table>` to a pipe table.
  Keep a header row + separator; pandoc needs them.
- **Headings.** One space after `#`; don't skip levels wildly (LaTeX maps `#`..`######` to
  part/section depth). Strip leading emoji so the TOC/anchors stay clean.
- **YAML front matter.** Keep it **only** if it's valid pandoc metadata
  (`title:`, `author:`, `date:`); otherwise an arbitrary block renders as a stray table —
  remove it or fold real values into pandoc metadata.
- **Images.** PDF export needs each image **resolvable at build time**. Flag remote URLs and
  missing local paths; pandoc fails the PDF if it can't fetch/find an image.
- **Code fences.** Keep the language tag (` ```python `); unknown languages are fine. Never
  edit fenced content.

## Leave alone

Code blocks and inline code (literal), math `$...$` / `$$...$$`, URLs, footnotes, real
accented letters and genuine math symbols, and ordinary Markdown structure
(headings, lists, links, emphasis, blockquotes, HRs).

## Relationship to SEMBR

Orthogonal passes. When doing both, **clean first, then SEMBR-reflow** — so the line-break
pass operates on already-cleaned text. Either pass can be run alone.

## Verify

1. Find residual non-ASCII to review (this also flags *legitimate* accents/math — review,
   don't blind-delete):
   ```
   grep -nP '[^\x00-\x7F]' file.md
   ```
   Cross-check against code blocks; ignore hits inside fenced/inline code.
2. Confirm it builds:
   ```
   pandoc file.md -o /tmp/check.pdf --pdf-engine=xelatex
   ```
   (`xelatex`/`lualatex` are the most Unicode-tolerant engines; if only `pdflatex` is
   available, be stricter about straightening quotes/dashes.)
3. Skim the PDF: no missing-glyph boxes (□), no dropped badges leaving dangling text, tables
   and lists intact.

## Example

**Before** (typical downloaded README snippet):

```
## 🚀 Quick Start

> [!WARNING]
> Don't run this in prod ⚠️

- ✅ Linux
- ✅ macOS
- ❌ Windows

See the docs → https://example.com
```

**After** (pandoc-clean):

```
## Quick Start

> **Warning:** Don't run this in prod.

- Supported: Linux
- Supported: macOS
- Not supported: Windows

See the docs -> https://example.com
```

Same information, no emoji/alert-syntax/arrows to trip up the LaTeX run.
