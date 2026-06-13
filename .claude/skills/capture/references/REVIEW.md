# capture — Review Taxonomy & Integration Playbook

This is the REVIEW half of the `/capture` flywheel: turn the `scratch/LEARNINGS.md` backlog into
durable changes to the toolkit. Read the inbox format in
[scratch/README.md](../../../../scratch/README.md) first.

Capture is cheap and dumb on purpose; **all the judgment is here.** Review is deliberate,
ask-first, and surgical — it edits skills, docs, config, and memory, so it follows the same
posture as `md2tex`/`tex2md`/`progression`: show the change, confirm, then write.

## The entry schema (what a blob looks like)

```markdown
### <short title> <!-- id: 2026-06-13-1 -->
- **when:** 2026-06-13 · **type:** skill-gap · **tags:** format-tex, ties
- **context:** formatting a .tex; the hygiene pass tied \cite/\ref but not \eqref.
- **lesson:** the non-breaking-tie rule should also cover \eqref and \cref.
- **proposed action:** extend format-tex HYGIENE.md tie list.
- **status:** open
```

`type` is one of: `skill-gap` (a skill should do X but doesn't), `skill-idea` (a new skill),
`workflow` (a convention/process), `bug` (something is wrong), `question` (open, needs a
decision), `preference` (how the user wants things done).

## Triage — route each blob to a sink

Decide one disposition per blob. Group near-duplicates first so a single change resolves several.

| Disposition | When | What review does |
|---|---|---|
| **update-skill** | an existing skill is missing or wrong behavior | edit that skill's `SKILL.md` / `references/*` |
| **new-skill** | a recurring need no skill covers | scaffold a new skill under `.claude/skills/` |
| **doc** | a repo convention, build, structure, or notation rule | amend `CLAUDE.md`, `PROGRESSION.md`, or the relevant doc |
| **hook** | an automated "whenever X, do Y" behavior | use the `update-config` skill to add a settings hook |
| **memory** | a durable fact about the user or project | write a memory file (`~/.claude/.../memory` + `MEMORY.md`) |
| **drop** | stale, out of scope, or not worth doing | archive marked `dropped: <why>` |

Present the triage as a compact table — `id → disposition → one-line plan` — before touching
anything, so the user can redirect a routing call.

## Integration playbook (per disposition)

- **update-skill / new-skill** — make the smallest change that fixes the lesson. Update the
  `description` frontmatter if triggers changed; keep the house structure (SKILL.md + `references/`).
  Re-read the edited skill's quick-reference table to confirm it still matches.
- **doc** — surgical edit at the right place; don't restructure the doc around one lesson.
- **hook** — delegate to `update-config` (hooks are harness-executed; memory/preferences cannot
  fulfill a "whenever X" automation). Capture the trigger and action precisely.
- **memory** — only for durable, non-derivable facts; follow the memory rules (one fact per
  file, frontmatter, `MEMORY.md` pointer). Don't duplicate what the repo already records.
- **drop** — still archive it with the reason; a recorded "won't do" prevents re-capturing it.

## Dedup & convergence

- Before integrating, fold blobs that describe the same gap into one; integrate once; archive
  all the duplicates pointing at the same resolution.
- Review is convergent: archived blobs never reappear in `## Open`, and a `dropped` record stops
  the same lesson from re-entering the backlog. Re-running review with nothing open is a no-op.

## Archiving

Move each resolved blob from `## Open` to `## Archive`, appending a resolution line:

```markdown
### <short title> <!-- id: 2026-06-13-1 -->
- **when:** 2026-06-13 · **type:** skill-gap · **tags:** format-tex, ties
- **lesson:** the non-breaking-tie rule should also cover \eqref and \cref.
- **status:** integrated 2026-06-20 — added \eqref/\cref to format-tex HYGIENE.md tie list.
```

Keep the lesson line; the archive is the history of how the toolkit learned. Never delete a
blob — graduate it.

## Scope discipline

- Review changes the toolkit (skills/docs/config/memory); it does **not** touch paper content
  (`sections/*`, `figures/*`) unless a blob is explicitly about fixing a specific section, in
  which case prefer the dedicated skill (`md2tex`/`tex2md`/`format-tex`).
- One sink per blob; if a lesson implies two changes (e.g. a skill edit *and* a hook), split it
  into two archived resolutions so each is traceable.
