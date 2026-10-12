# Landscape: open military hardware data

Written 2026-10-11 from one round of web searches plus the repo. The search did not surface SIPRI's own tools, Wikidata or Military Factory, so those are named only where the repo already relies on them.

## Others in the space
- **Jane's defence equipment intelligence** (commercial): variant-level profiles; its materials claim 791,500+ specification points across 32,300+ equipment items; subscription only. [Jane's](https://Janes.com/defence-equipment-intelligence), [brochure](https://cdn.ihs.com/www/pdf/JDET-Intelligence-Centre.pdf).
- **GlobalMilitary.net** (free): open-source catalogue with technical specs, range, development and production history; browsable, no bulk download or API was found. [example page](https://www.globalmilitary.net/firearms/category/assault/).
- **SIPRI databases**: the source this repo already ingests for expenditure, top-100 arms companies and US transfers (`data/sipri/README.md`). Not re-checked here.

## What they do better
Breadth (tens of thousands of items), variant-level detail, editorial review. This repo has 183 platforms, mostly US.

## What users expect
Search and filter, side-by-side comparison, a source for every figure, a clear licence on data, and a download.

## What is unique here
Open licence, citation per data point (675 sources), a REST API plus a SQLite/JSON/CSV export, SIPRI spending and transfer data in the same console, and a data-collector framework.

## Findings from reading the code and running it
- `data/json/platforms.json` and `data/csv/platforms.csv` hold 165 platforms; the SQLite DB reaches 183 only after the Python migrations `data/migrations/v2_4_software_roles.py` and `v3_0_sipri_integration.py` run. `scripts/exporters/export_all.py` does not run them, so a fresh clone built per the README has no `role_type` column and 5-6 tests fail.
- Two tests still expect API version `2.1.0` while the API reports `3.0.0`.
- `ruff check api/ tests/ scripts/ --ignore E501` (the CI lint step) reports 126 errors, 117 auto-fixable.
- `docs/UI_UX.md` specifies Next.js, but the shipped UI is Vite + Express + React; the doc is stale.
- `index.html` carried "165 US platforms" and `favicon.png` did not exist (fixed in the UI commits).
- Stats "Top countries" bars use flag colours; dark ones (e.g. navy) are near-invisible on the navy canvas.
