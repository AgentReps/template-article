# Local arXiv Library — Index

Registry of papers ingested under `resources/` via the `get-arxiv` skill. Each lives in its
own `arXiv-<id>v<ver>/` mini-project (original top-level `.tex` + `.bbl`, figures, a
`justfile`, `CLAUDE.md` build notes, and a `SUMMARY.md` reading note).

> Note: this is a **library index** for humans/agents. It is *not* the arXiv per-paper
> manifest — that is the `00README.json` *inside* each paper folder, which the `get-arxiv`
> skill reads to find the top-level `.tex`.
>
> The paper folders themselves are gitignored (they can be large/binary); only this index
> is tracked, so the registry travels with the repo while the sources stay local.

## Papers (0)

| Folder | arXiv | Title | Year | Role in the manuscript |
| ------ | ----- | ----- | ---- | ---------------------- |
| _(none yet — run `get-arxiv <id>` to ingest the first paper)_ | | | | |

## Details

_No papers ingested yet._

## Maintenance
When ingesting a new paper with `get-arxiv`, add a row to the table and a Details entry here.
