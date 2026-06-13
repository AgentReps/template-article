# progression — Coherence Checks & Report Format

This is the audit ruleset for the vertical (cross-section) coherence of the `.md` sidecars,
following the [PROGRESSION.md](../../../../PROGRESSION.md) convention. Read that first for the
registers and the optional progression map.

The mental model: the sidecars' concepts form a **dependency DAG**, and the reading order (the
`main.tex` `\input` sequence, refined by the optional map) should be a valid **topological
order** of that DAG. Most defects are a node that depends on something not yet introduced, or a
setup that never pays off.

## The concept ledger

For each in-scope `<name>.md`, read the conceptual spine (not the prose) and record four sets:

- **introduces** — concepts, definitions, notation, framings this section establishes.
- **uses** — concepts it relies on or assumes from upstream.
- **promises** — things it says will come later ("we return to this in…", "shown in the case
  study", an explicit claim it defers).
- **pays off** — earlier promises this section delivers.

Match concepts by meaning, not by string: the same idea under two names is *one* ledger entry
(and a consistency finding — see below).

## Check dimensions

### 1. Setup ↔ payoff (Chekhov's gun)
- **Orphaned setup** — introduced or promised, never used or delivered downstream. Either it
  should pay off, or the setup is dead weight.
- **Unsupported payoff** — a section uses or delivers a concept that no upstream section
  introduces. The setup is missing or sits too late.

### 2. Topological order
- **Forward reference** — a concept is used before any ancestor (tree) / earlier section
  (linear) introduces it. The reading order violates the dependency. Fix by moving the setup
  earlier or adding it where it's first needed.
- **Cycle** — A depends on B and B on A across sections. Real circular dependence is a design
  smell; report it and the two sections involved.

### 3. Consistency
- **Aliasing** — one concept under two names/notations in different sections. Pick one; flag the
  others.
- **Notation drift** — the same symbol used for different things, or different symbols for the
  same thing, across sections.
- **Contradiction** — two sections assert incompatible things about the same concept (a value, a
  direction, an assumption).
- **Definition drift** — a concept defined one way upstream, silently redefined downstream.

### 4. Tree / branch coherence (when the map branches)
- **Branch vs. trunk** — every concept a branch *uses* must be introduced in the shared trunk
  (a common ancestor) or within the branch itself, never borrowed from a sibling branch.
- **Sibling contradiction** — parallel branches must not assert incompatible things about a
  shared trunk concept.
- **Leaked branch concept** — a concept introduced only in one branch must not be assumed by the
  trunk or a sibling (it isn't on their path).
- **Convergence node** — when branches rejoin (e.g. a shared conclusion), the join must not
  depend on a concept that exists in only some of the incoming branches.

### 5. Redundancy (minor)
- **Repeated setup** — the same concept introduced from scratch in multiple sections. Usually
  one canonical introduction plus a back-reference is cleaner. Low severity.

## Severity

- **blocker** — a forward reference, unsupported payoff, contradiction, or branch-vs-trunk gap:
  the story does not hold as ordered.
- **warn** — orphaned setup, aliasing, notation/definition drift: coherent but fraying.
- **note** — redundancy, a stylistic through-line suggestion: optional polish.

## Report format

```markdown
# Progression coherence report

## Inferred structure
<the order / tree the audit used — e.g. introduction -> system_model -> {main_results, case_study} -> conclusion>
<note any parked sections (.tex not \input) and any .tex missing a .md>

## Findings

### Blockers
- [forward-ref] `main_results.md` uses <concept> before it is introduced
  (no ancestor establishes it; `system_model.md` is the natural home). -> add the setup there.

### Warnings
- [aliasing] <concept> is called "X" in `system_model.md` and "Y" in `case_study.md`. -> pick one.

### Notes
- [redundancy] <concept> is set up in both `introduction.md` and `system_model.md`. -> keep one.

## Suggested fixes (ask-first)
- <surgical, additive sidecar edit>, pinned to the file it lands in.
```

Lead with the inferred structure so the user can catch a wrong edge before reading findings.
Pin every finding to a `sections/<name>.md` (and the related upstream/downstream section).

## Fix discipline

- Surgical and additive; one change at a time; show the diff; confirm before writing.
- A defect is often ambiguous about *which* section is wrong (move the setup earlier, or remove
  the downstream use?) — surface the options, don't guess.
- Respect each sidecar's exclusive zones: never delete scratch, open questions, or rationale to
  "clean up." Coherence fixes add or adjust spine content; they don't prune the thinking layer.
- Stay on the `.md` layer. If a fix implies prose work, note it as a follow-up `md2tex`, don't
  touch the `.tex` here.

## Convergence

The audit is naturally convergent: re-running after applying fixes surfaces fewer findings.
There is no state to track — each run re-derives the ledger from the current sidecars.
