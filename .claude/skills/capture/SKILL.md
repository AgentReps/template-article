---
name: capture
description: A learning-flywheel inbox. In CAPTURE mode (default), distill the recent conversation into a small structured "blob" — context, lesson, proposed action — append it to LEARNINGS.md, and ack in one line WITHOUT disrupting the current task. Use when the user says "/capture", "capture this", "log a lesson", "jot that gap", "stash this for review", "note this for later", or "remember to improve X". In REVIEW mode ("/capture review"), process the LEARNINGS.md backlog: triage each open blob, route it to its proper home (update a skill, write a new skill, amend CLAUDE.md/PROGRESSION.md, add a hook via update-config, save to memory, or drop it), apply changes ask-first, and archive the entry with its resolution. Capture is one append + one-line ack (never derails the flow); review is where all the judgment and integration happen. The inbox is the LEARNINGS.md at the repo root. See LEARNINGS.md.
---

# capture — Learning-Flywheel Inbox

A two-mode skill that turns cheap in-flow signals into durable improvements to the toolkit.

- **CAPTURE** (default) — distill what we just learned into a compact blob and append it to
  `LEARNINGS.md`. **Near-zero friction:** one append, one-line ack, back to work.
- **REVIEW** (`/capture review`) — process the backlog: triage each blob and integrate it
  (update a skill, write a new one, amend a doc, add a hook, save a memory, or drop it).

The methodology: capture collects cheap signal during normal work (an experience-replay
buffer); review is the consolidation step where signal becomes concrete changes to skills,
docs, hooks, and memory. Capture stays dumb and fast; **all judgment lives in review.**

`LEARNINGS.md` is the inbox at the repo root: a `## Open` list (new blobs) and a `## Archive`
(integrated blobs with their resolution). See [LEARNINGS.md](../../../LEARNINGS.md) for the
entry format; see [references/REVIEW.md](references/REVIEW.md) for the triage taxonomy and the
integration playbook.

## Mode selection

- `/capture` or `/capture <one-line steer>` → **CAPTURE**. Free text is a steer, not the whole
  entry — I still distill the context around it.
- `/capture review` (optionally `/capture review <tag|type|id>`) → **REVIEW**.

---

## CAPTURE mode

**The prime directive: do not disrupt the flow.** Append and acknowledge in one line; do not
start fixing the thing, do not open a discussion, do not ask follow-ups unless there is truly
nothing to capture. Then return to whatever we were doing.

### Workflow

1. **Find the lesson.** From the recent exchange (plus any one-line steer in the args), identify
   the gap / lesson / question / idea worth keeping. If the args fully state it, use them; if
   context is empty and no steer is given, ask a single short question — otherwise, infer.
2. **Distill the blob** into the entry schema (one tight entry — see LEARNINGS.md):
   - **title** — a short, specific handle.
   - **when** — today's date (`date +%Y-%m-%d`); **type** — one of `skill-gap`, `skill-idea`,
     `workflow`, `bug`, `question`, `preference`; **tags** — the skills/files/topics involved.
   - **context** — one line on what we were doing when it surfaced.
   - **lesson** — the distilled observation (1–2 lines).
   - **proposed action** — the integration hint: which skill/doc/hook/memory it likely touches.
   - **status: open**.
3. **Append.** If `LEARNINGS.md` does not exist, create it from the seed format. Add the entry at
   the **top of `## Open`** (newest first).
4. **Ack in one line** — e.g. `Captured -> LEARNINGS.md: <title>` — and stop. Resume the prior task.

Capture writes only `LEARNINGS.md`. It never edits a skill, doc, or config — that is review's job.

---

## REVIEW mode

Deliberate, ask-first, and where the loop closes. Read [references/REVIEW.md](references/REVIEW.md)
for the full taxonomy and playbook.

### Workflow

1. **Load the backlog.** Read `## Open` in `LEARNINGS.md`. If a filter arg is given
   (`<tag|type|id>`), scope to it. Group near-duplicates so one fix can resolve several.
2. **Triage.** For each blob, decide its disposition (route to a sink):
   update-skill · new-skill · doc (`CLAUDE.md`/`PROGRESSION.md`/…) · hook (via `update-config`) ·
   memory · drop. Present a compact triage table (blob → disposition → 1-line plan).
3. **Integrate, ask-first.** For each accepted item, apply the change surgically — edit the
   skill, amend the doc, invoke `update-config` for a hook, or write a memory file — showing the
   diff and confirming before writing. Skip/defer anything the user doesn't approve.
4. **Archive.** Move each resolved blob from `## Open` to `## Archive` with a resolution line
   (`integrated <date>: <what changed / where>`). Keep it — the archive is the learning history,
   not deleted. Dropped items move to archive marked `dropped: <why>`.
5. **Summarize.** Report what was integrated, what was deferred, and the remaining open count.

### Routing (sinks)

| Blob is about | Goes to |
|---|---|
| A skill missing/wrong behavior | edit that skill's `SKILL.md`/`references/*` |
| A recurring need with no skill | a new skill under `.claude/skills/` |
| A repo convention / build / structure rule | `CLAUDE.md`, `PROGRESSION.md`, or the relevant doc |
| An automated "whenever X do Y" behavior | a hook in settings via the `update-config` skill |
| A durable fact about the user/project | a memory file (`~/.claude/.../memory` + `MEMORY.md`) |
| No longer relevant / not worth doing | archive as `dropped` |

## Quick reference

| | |
|---|---|
| Inbox | `LEARNINGS.md` at repo root (`## Open` newest-first, `## Archive`) |
| Capture | distill recent context → one blob → append → **one-line ack**; never derails |
| Capture writes | `LEARNINGS.md` only — never a skill/doc/config |
| Review | triage backlog → route to a sink → apply ask-first → archive with resolution |
| Entry | title · when · type · tags · context · lesson · proposed action · status |
| Relation to memory | capture = inbox feeding many sinks; memory = one resolved sink |
| Never (capture) | start fixing, open a discussion, or block the flow |

Triage taxonomy, integration playbook, dedup, and the entry schema:
[references/REVIEW.md](references/REVIEW.md). Inbox format: [LEARNINGS.md](../../../LEARNINGS.md).
