# arXiv Watch Profile

The standing query for `/check-arxiv`: what counts as **relevant** when scanning arXiv for new
papers not yet in the library. If `CATALOG.md` is what you *have*, this is what you *want* —
`/check-arxiv` surfaces "want − have," suggests a ranked shortlist, and never downloads (use
`get-arxiv <id>` to ingest the ones you choose).

Seed this from your `CATALOG.md` tags and manuscript topics, then curate it over time. **Reuse
the tag vocabulary** so the watch list lines up with the catalog. This file is tracked, so the
watch list travels with the repo; the per-clone scan state (watermark + ledger) lives separately
in `scratch/check-arxiv-state.md` (gitignored).

## Categories
arXiv category codes to scan (one per line, e.g. `cs.LG`, `cs.IT`, `cs.NE`, `math.OC`):
-

## Keywords
Topic terms matched in title/abstract; reuse `CATALOG.md` tag words where possible:
-

## Authors (optional)
Researchers to follow, in arXiv author form (e.g. `Shannon_C`):
-

## Excludes (optional)
Terms or categories to down-rank or skip (reduce false positives):
-
