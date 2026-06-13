---
name: md2tex
description: Realize settled concepts from a section's Markdown sidecar (sections/<name>.md) into its shipped LaTeX prose (sections/<name>.tex). Use when the sidecar's ideas have harmonized and the user asks to "md2tex", "propagate the sidecar to the tex", "realize these concepts in the section", "write up the sidecar", or "push the .md into the .tex". This is concept propagation, NOT a mechanical md->tex conversion: it pulls only from the sidecar's settled conceptual spine, ignores its scratch/open-questions/rationale, and writes house-style LaTeX prose (one sentence per line, ~ ties; see format-tex). Surgical and additive — proposes targeted edits to the .tex, protects existing wording, and confirms a shown diff before writing. Runs a git-aware age check and warns if the .md looks older than the .tex (you may want /tex2md instead). One section pair per run; pass --all to sweep every pair and report drift. See PROGRESSION.md.
---

# md2tex — Realize Sidecar Concepts into Shipped Prose

Propagate the **settled concepts** of a section's Markdown sidecar (`sections/<name>.md`) into
its LaTeX prose (`sections/<name>.tex`). This is the **early-to-mid lifecycle** move: the
sidecar is ahead, its ideas have harmonized, and you want them realized as publishable prose.

It is **concept propagation, not conversion.** Do not run pandoc; do not transliterate markdown
to LaTeX. Read the sidecar's conceptual spine, decide what the `.tex` is missing or where it
diverges, and write that as prose in the project's house style.

Read [PROGRESSION.md](../../../PROGRESSION.md) for the convention (registers, exclusive zones,
the source-of-truth flip) and [references/MAPPING.md](references/MAPPING.md) for exactly what
maps, what is protected, and the worked example. The output prose must follow `format-tex`
house style.

## When to use

- The sidecar's ideas are settled and you want them written up in the `.tex`.
- A concept exists in the `.md` but is missing from, or contradicted by, the `.tex`.
- User says "md2tex", "realize the sidecar", "write up these concepts", "push the .md to .tex".

Do **not** use it to copy scratch, open questions, or rationale into the paper, to invent
content the sidecar hasn't settled, or to reformat the `.tex` (that is `format-tex`).

## Workflow

1. **Resolve the pair.** From the section name or the active/opened file, locate
   `sections/<name>.tex` and `sections/<name>.md`. If the `.md` is missing, stop and point to
   `PROGRESSION.md` (offer to scaffold a sidecar from the skeleton). With `--all`, iterate every
   `sections/*.{tex,md}` pair: report each pair's drift and age, then drill in on confirmation.
2. **Git-aware age / direction check.** Determine which file changed more recently using:
   working-tree dirty state first (`git status --short -- <files>`), then last-commit time
   (`git log -1 --format=%ci -- <file>`), with filesystem mtime as fallback. If the **source**
   `.md` looks **older** than the destination `.tex`, surface it plainly — "the prose is newer
   than the sidecar; you may want `/tex2md`" — and ask before proceeding.
3. **Read both, build the concept delta.** Read the `.md` and extract its **settled
   conceptual spine** (ignore scratch, open questions, rejected alternatives, rationale, source
   detail, author notes — see MAPPING.md). Read the `.tex` and identify, concept by concept:
   *missing* (in the spine, absent from prose), *divergent* (prose says something the spine
   has since changed), and *already-present* (leave alone).
4. **Propose surgical edits.** For each missing/divergent concept, draft a targeted insertion
   or edit to the `.tex` — new sentences or a reworked clause at the right place — in house
   style (one sentence per source line, `~` ties before `\cite`/`\ref`, restrained `---`).
   **Additive and surgical:** do not rewrite settled prose, do not touch citations/floats/math
   you aren't changing, preserve the author's voice.
5. **Show the diff and confirm.** Present the proposed `.tex` changes (and note which sidecar
   concepts they realize). Apply only what the user approves.
6. **Offer the loopback note.** If realizing a concept resolved an open question in the `.md`,
   offer to mark it resolved (that small `.md` edit is the one exception to one-direction-only,
   and only on confirmation).
7. **Verify.** `just build` still succeeds; the diff is additive prose in house style; no
   scratch/rationale leaked into the `.tex`.

## Quick reference

| | |
|---|---|
| Direction | `.md` (lead) → `.tex` (follower); early-to-mid lifecycle |
| Pulls from | the sidecar's **settled conceptual spine** only |
| Ignores in `.md` | scratch, open questions, rejected ideas, rationale, source detail, anchors |
| Writes | house-style LaTeX prose (see `format-tex`): one sentence/line, `~` ties, restrained `---` |
| Protects in `.tex` | existing settled wording/voice, citations, floats, math |
| Mode | surgical & additive; show diff; **ask before writing** |
| Wrong-direction guard | git-aware age check; if `.md` older than `.tex`, suggest `/tex2md` |
| Scope | one pair (default); `--all` sweeps and reports drift |
| Never | run pandoc/convert, copy scratch into the paper, invent unsettled content, reformat |

Full mapping rules, exclusive-zone table, and worked example:
[references/MAPPING.md](references/MAPPING.md). Convention: [PROGRESSION.md](../../../PROGRESSION.md).
