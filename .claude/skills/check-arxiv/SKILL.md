---
name: check-arxiv
description: Scan arXiv for recent, relevant papers NOT yet in the local library and suggest a ranked shortlist — discovery, never auto-download. Use when the user says "check-arxiv", "check arxiv for new papers", "what's new on arxiv", "any papers I should read", "find relevant papers not in my library", or "scan arxiv for <topic>". Reads a tracked watch profile (resources/WATCH.md: categories, keywords, authors — seeded from CATALOG tags + the manuscript), queries the arXiv API for recent matches since a stored watermark, excludes everything already in resources/ or already ingested/dismissed in a local ledger, ranks the rest by genuine relevance to the manuscript, and prints top-N with a get-arxiv command to ingest. Memory is incremental: a date watermark bounds the query window and a seen/dismissed ledger (scratch/check-arxiv-state.md, gitignored) stops it re-pitching papers you already triaged. Suggest-only — it updates its own state but downloads nothing and edits no paper. Needs network access to export.arxiv.org. See resources/WATCH.md and references/QUERY.md.
---

# check-arxiv — Suggest Relevant New arXiv Papers

Discover papers you don't know about yet. This is the **recall→precision** complement to
`get-arxiv` (which ingests a paper you already chose) and `diff-arxiv` (which compares an
ingested paper to the manuscript):

- **Recall** — the arXiv API does a broad query (categories + keywords + authors, since a stored
  date watermark).
- **Precision** — you (the agent) read the abstracts, drop what's already in the library, rank
  the rest by genuine relevance to the manuscript, and explain *why* each matters.

The closure: **`CATALOG.md` is what you have, `WATCH.md` is what you want, and `check-arxiv`
surfaces "want − have."** It **suggests only** — every run ends in a ranked shortlist with
`get-arxiv <id>` to ingest the ones you choose. It downloads nothing and edits no paper; it only
updates its own watermark + ledger.

Read [resources/WATCH.md](../../../resources/WATCH.md) for the profile and
[references/QUERY.md](references/QUERY.md) for the arXiv query construction, exclusion/ranking
rules, and the state-file schemas.

> **Network:** this needs egress to `export.arxiv.org` (the arXiv API), which is not in the
> default sandbox allowlist — it runs when invoked with network access, like `get-arxiv`.

## When to use

- The user wants to know what's new and relevant on arXiv that isn't already ingested.
- Periodic literature monitoring (schedulable via `/schedule` or `/loop`; the memory makes each
  run incremental).
- `/check-arxiv` (scan), or `/check-arxiv dismiss <id> [<id>…]` to teach it "not relevant."

Do **not** use it to ingest (that is `get-arxiv`) or to compare a paper to the draft (`diff-arxiv`).

## Workflow

1. **Load the profile.** Read `resources/WATCH.md`. If it is missing or empty, **seed it**: pull
   topic words from `resources/CATALOG.md` tags and a skim of the manuscript sections, write the
   skeleton (categories / keywords / authors), and ask the user to curate before the first real
   scan (or proceed with the seed on request).
2. **Load the state.** Read `scratch/check-arxiv-state.md` (gitignored). If missing, create it
   with a first-run watermark (default: 60 days ago — confirm with the user) and an empty ledger.
3. **Reconcile.** For any ledger id now present as a folder in `resources/` (`arXiv-<id>v*/`),
   flip its status `suggested → ingested`. This keeps the ledger honest without manual bookkeeping.
4. **Query arXiv (recall).** Build the `search_query` from the profile (categories `cat:`,
   keywords in `ti:`/`abs:`, authors `au:`) with `submittedDate` from the watermark to now,
   `sortBy=submittedDate&sortOrder=descending`. Fetch from `export.arxiv.org/api/query`
   (see [references/QUERY.md](references/QUERY.md); mind the rate limit and paginate if needed).
5. **Exclude what's known.** Drop candidates whose bare id is already in `resources/` or is marked
   `ingested`/`dismissed` in the ledger. A still-open `suggested` id may reappear but flag it
   `(carried over)` so the list stays fresh without nagging.
6. **Rank (precision).** Read the remaining abstracts; rank by genuine relevance to the
   manuscript + profile; write a one-line "why relevant" for each. Keep the **top ~8**; report
   the count of lower-ranked matches rather than dumping them.
7. **Suggest.** Print the shortlist: arXiv id · title · authors · date · why-relevant · the
   `get-arxiv <id>` command. Never download.
8. **Update state.** Advance the watermark (to today, or the latest `submittedDate` seen) and
   record each surfaced id in the ledger as `suggested` with today's date.

To teach it: `/check-arxiv dismiss <id>…` marks those ids `dismissed` so they are never
re-pitched. Ingestion needs no manual step — step 3 reconciles it.

## Quick reference

| | |
|---|---|
| Profile (tracked) | `resources/WATCH.md` — categories · keywords · authors (seed from CATALOG tags) |
| State (gitignored) | `scratch/check-arxiv-state.md` — watermark + seen/dismissed ledger |
| Recall | arXiv API: `cat:`/`ti:`/`abs:`/`au:`, `submittedDate` from watermark, newest first |
| Precision | read abstracts → rank vs manuscript+profile → one-line why; top ~8 |
| Exclude | ids in `resources/` or ledger-marked `ingested`/`dismissed` |
| Output | ranked shortlist + `get-arxiv <id>`; **suggest only, never download** |
| Memory | watermark bounds the window; ledger stops re-pitching triaged papers |
| Teach it | `/check-arxiv dismiss <id>…`; ingestion auto-reconciles |
| Needs | network egress to `export.arxiv.org` |

Query syntax, exclusion/ranking rules, and state schemas: [references/QUERY.md](references/QUERY.md).
Profile: [resources/WATCH.md](../../../resources/WATCH.md).
