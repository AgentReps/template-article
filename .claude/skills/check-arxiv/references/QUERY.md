# check-arxiv — arXiv Query, Exclusion/Ranking, and State Schemas

The recall→precision details for `/check-arxiv`. Read the convention in
[resources/WATCH.md](../../../../resources/WATCH.md) (the profile) and
[resources/CATALOG.md](../../../../resources/CATALOG.md) (what's already in the library).

## arXiv API (recall)

Endpoint: `http://export.arxiv.org/api/query` — returns an Atom feed. Key parameters:

- `search_query=` a boolean expression over fields: `cat:` (category, e.g. `cat:cs.LG`),
  `ti:` (title), `abs:` (abstract), `all:` (any), `au:` (author). Combine with `AND`, `OR`,
  `ANDNOT`, and group with parentheses (URL-encode: space→`+`, etc.).
- `sortBy=submittedDate&sortOrder=descending` — newest first.
- `start=` and `max_results=` — pagination (page in chunks of ~100; stop when results predate
  the watermark).

Build the query from the profile, e.g. for categories `{cs.LG, cs.NE}`, keywords
`{evolutionary, "LLM optimizer"}`, author `Smith_J`:

```
search_query=(cat:cs.LG OR cat:cs.NE) AND (abs:evolutionary OR abs:%22LLM+optimizer%22 OR au:Smith_J)
&sortBy=submittedDate&sortOrder=descending&max_results=100
```

**Date window.** The Atom feed carries `<published>`/`<updated>`; arXiv also supports a
`submittedDate:[YYYYMMDDHHMM+TO+YYYYMMDDHHMM]` clause in `search_query`. Prefer paginating newest
-first and **stopping when `<published>` falls before the watermark** — simpler and robust. Use
the watermark date as the lower bound; "now" as the upper.

**Rate limit / etiquette.** arXiv asks for ~1 request per 3 seconds and a sane `max_results`.
Page politely; don't hammer. Network egress to `export.arxiv.org` is required (not in the default
sandbox allowlist).

**Per entry, extract:** the arXiv id (from `<id>`, e.g. `http://arxiv.org/abs/2501.01234v1` →
bare id `2501.01234`, version `v1`), `<title>`, `<author><name>` list, `<published>`,
`<arxiv:primary_category>`, and `<summary>` (abstract) for ranking. **Key the ledger on the bare
id** (no version) so a v1→v2 update is the same paper.

## Exclusion (what to drop before ranking)

A candidate is excluded if its bare id:

- already exists as a folder in `resources/` (`arXiv-<id>v*/`) — it's in the library; or
- is in the ledger with status `ingested` or `dismissed` — already triaged.

A still-open `suggested` id is **not** excluded, but mark it `(carried over from <date>)` so the
shortlist stays honest without re-nagging. Everything else is a fresh candidate.

## Ranking (precision)

Read each fresh candidate's abstract and judge relevance to **the manuscript** (its
`sections/*.tex` topics) and **the profile**, not just keyword overlap. For each kept paper write
a one-line *why-relevant* that names the connection (a section it bears on, a method it
extends/contrasts, an author being followed). Keep the **top ~8**; report the count of
lower-ranked matches (`N more matched lower — ask to see them`) rather than dumping everything.
Prefer precision: a tight, well-justified shortlist beats a long list.

## State schemas

### `resources/WATCH.md` (tracked profile — what to look for)

Sections, each a bullet list: `## Categories` (arXiv category codes), `## Keywords` (topic terms,
reusing CATALOG tag words), `## Authors` (optional, arXiv author form), `## Excludes` (optional
down-rank/skip terms). Seed it from `CATALOG.md` tags + manuscript topics; the user curates it.
It is tracked, so the watch list travels with the repo.

### `scratch/check-arxiv-state.md` (gitignored — what's been seen)

Per-clone operational state, created/updated by the skill:

```markdown
# /check-arxiv state (local, gitignored)

## Watermark
last_checked: <YYYY-MM-DD>

## Ledger
| arXiv id | status | when | note |
| -------- | ------ | ---- | ---- |
| 2501.01234 | suggested | 2026-06-13 | relevance: LLM-optimizer lineage |
| 2412.09999 | dismissed | 2026-06-13 | off-topic (vision) |
| 2502.05555 | ingested  | 2026-06-13 | now in resources/ |
```

`status` ∈ `suggested | ingested | dismissed`. Advance `last_checked` each run; add surfaced ids
as `suggested`; `dismiss` flips to `dismissed`; reconciliation flips `suggested → ingested` when
the folder appears in `resources/`.

## Convergence

Incremental by construction: the watermark shrinks each query window to "since last time," and
the ledger guarantees a paper triaged once (ingested or dismissed) is never re-pitched. A run
with nothing new prints "no new relevant papers since <last_checked>" and only advances the
watermark.
