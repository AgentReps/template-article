# scratch — ephemeral working area

Untracked working files live here: throwaway experiments, generated artifacts, and the
`/capture` inbox. **Everything in `scratch/` is gitignored except this `README.md`** — so the
convention ships with the repo, but the contents stay local and never enter the paper's git
history.

## Base files you may see here

- **`LEARNINGS.md`** — the `/capture` learning-flywheel inbox (ephemeral). Created on demand the
  first time you run `/capture`; not tracked, because it is your personal backlog of
  gaps/lessons, not shared paper history. Format below.
- Other tools may drop working artifacts here (e.g. generated slide decks, figure experiments);
  none of it is tracked.

## The `LEARNINGS.md` inbox

`/capture` distills a gap / lesson / question / idea into one compact blob and appends it under
**Open** without disrupting the flow. Later, `/capture review` triages the backlog and
integrates each blob into its proper home (update a skill, write a new one, amend a doc, add a
hook, save a memory, or drop it), then moves it to **Archive** with its resolution. The archive
is kept as the history of how the toolkit learned — blobs are graduated, never deleted.

It is an inbox, not a sink: a blob is a signal to process later, not a finished change. Keep
capture cheap; let review do the judgment.

**Inbox skeleton** (`/capture` creates this if it does not exist):

```markdown
# Learnings — improvement inbox

## Open
<!-- newest first; one blob per gap/lesson -->

## Archive
<!-- integrated and dropped blobs, each with a resolution line -->
```

**Entry format**

```markdown
### <short title> <!-- id: <YYYY-MM-DD>-<n> -->
- **when:** <YYYY-MM-DD> · **type:** <skill-gap|skill-idea|workflow|bug|question|preference> · **tags:** <...>
- **context:** one line on what we were doing when it surfaced.
- **lesson:** the distilled observation (1–2 lines).
- **proposed action:** the integration hint — which skill/doc/hook/memory it likely touches.
- **status:** open
```
