---
name: progression
description: Audit the vertical conceptual coherence of the section sidecars (sections/*.md) across the whole document — the through-line from introduction.md to system_model.md to main_results.md and onward, including the tree/branch case. Use when the user asks to "progression", "check coherence across sections", "do the sidecars hang together", "is the conceptual arc coherent", "check the through-line", or "audit the spine across sections". Operates on the .md conceptual layer only (not the .tex prose, not a single pair). Reads the section order from main.tex's \input sequence (and an optional declared tree/DAG map in PROGRESSION.md when the document branches), builds a concept ledger per section, and checks setup<->payoff (every concept introduced is used and every concept used is introduced), topological order (no forward reference to an undefined concept), terminology/notation/framing consistency, and tree coherence (branches valid against the trunk, siblings non-contradictory). Produces a report pinned to specific sidecars, then offers surgical, ask-first fixes. Read-only until you confirm an edit. See PROGRESSION.md.
---

# progression — Audit Conceptual Coherence Across Sidecars

The `md2tex`/`tex2md` skills work **horizontally** — within one section, syncing its
`.tex` ↔ `.md` pair. This skill works **vertically**: it checks that the conceptual spine
running *across* the sidecars (`introduction.md` → `system_model.md` → `main_results.md` → …)
holds together, including when the document branches into a tree.

It operates on the `.md` layer on purpose: the sidecars hold concepts in compact, explicit
form before they are buried in prose, so incoherence is catchable earlier and more cheaply than
at the `.tex` level. If the `.md` spine is coherent and `md2tex` is faithful, the `.tex`
inherits the coherence.

It is **read-only until you confirm an edit.** It produces a report, then offers surgical,
ask-first fixes — never a silent cross-section rewrite.

Read [PROGRESSION.md](../../../PROGRESSION.md) for the convention (and the optional progression
map), and [references/CHECKS.md](references/CHECKS.md) for the exact check dimensions and the
report format.

## When to use

- After several sidecars have matured and you want to know whether they tell one coherent story.
- Before an `md2tex` pass, to catch a gap or contradiction in the spine before it reaches prose.
- When the document branches (parallel case studies, appendices) and you want each branch
  checked against the shared trunk.
- User says "progression", "check coherence/through-line/arc across sections", "do the sidecars
  hang together".

Do **not** use it to check a single `.tex`/`.md` pair (that is `md2tex`/`tex2md`), to edit prose,
or to reformat (that is `format-md`).

## Workflow

1. **Determine the structure.** Read `main.tex` for the `\input{sections/<name>}` sequence —
   that is the canonical reading order and the set of in-scope sections (each `<name>.tex` pairs
   with `<name>.md`). Then check `PROGRESSION.md` for an optional **progression map** (a
   `parent -> child` edge list); if present, use it as the dependency tree/DAG, else treat the
   sections as a linear chain in `\input` order. Note any section whose `.tex` is not `\input`
   (parked / out of scope) and any `.tex` missing its `.md` (a hole in the audit — offer to
   scaffold). An optional argument (a section name) scopes the audit to that node plus its
   ancestors and descendants; default is the whole document.
2. **Build the concept ledger.** Read each in-scope `.md` in topological order. For each, record
   what it **introduces** (defines/sets up), what it **uses** (assumes from upstream), what it
   **promises** (claims to deliver later), and what it **pays off** (delivers an earlier
   promise). Work at the concept level — ignore wording and prose style.
3. **Run the coherence checks** (full list in [references/CHECKS.md](references/CHECKS.md)):
   setup↔payoff (orphaned setups, unsupported payoffs), topological order (a concept used before
   any ancestor introduces it), consistency (a concept named/defined two ways; notation drift;
   contradictions), tree/branch coherence (each branch valid against the trunk; siblings not
   mutually contradictory; a branch-only concept not assumed by the trunk or a sibling), and
   redundancy (the same setup repeated).
4. **Report.** Open with the **inferred structure** (the order/tree the audit used) so the user
   can sanity-check it, then the findings grouped by dimension and severity, each pinned to
   `sections/<name>.md` and the related upstream/downstream section. Use the format in CHECKS.md.
5. **Offer surgical fixes.** After the report, offer ask-first, additive sidecar edits — add a
   missing setup bullet, add a forward-pointer, harmonize a term, move a setup earlier. One
   change at a time, show the diff, confirm. A coherence defect is often a judgment call about
   *which* section is wrong — surface the options rather than guessing, and respect each
   sidecar's exclusive zones (never delete scratch/open-questions/rationale).
6. **Re-runnable.** Re-running after fixes yields fewer findings; the audit is naturally
   convergent, not stateful.

## Quick reference

| | |
|---|---|
| Layer | `.md` sidecars only (the conceptual spine); vertical / cross-section |
| Order | `main.tex` `\input` sequence; tree/DAG from the optional map in `PROGRESSION.md` |
| Ledger per section | introduces · uses · promises · pays off |
| Checks | setup↔payoff · topological order · consistency · tree/branch coherence · redundancy |
| Output | inferred structure + findings pinned to sidecars, then **ask-first** surgical fixes |
| Scope | whole document (default); a section arg scopes to that node + ancestors + descendants |
| Holes | missing `.md` → offer to scaffold; parked `.tex` (not `\input`) → noted out of scope |
| Never | edit prose, check a single pair, reformat, or rewrite across sections silently |

Full check dimensions and report format: [references/CHECKS.md](references/CHECKS.md).
Convention and the progression map: [PROGRESSION.md](../../../PROGRESSION.md).
