# OMHDB design direction: Blueprint Console

Status: documents the shipped direction (from `frontend/client/src/index.css`) and records the 2026-10-11 audit. The logo is a proposal; the owner signs off logos.

## Surfaces
| Surface | Where |
|---|---|
| Intelligence console (explorer, detail pane, analytics, compare) | `frontend/client/src/pages/`, `components/AppShell.tsx` |
| REST API docs (Swagger UI) | `api/main.py` at `/docs` |
| README, docs | repo root, `docs/` |
| Exports (JSON, CSV, SQLite) | `data/` |

No CLI, TUI or bar widget.

## Direction
**Blueprint Console**: a mid-1960s technical drawing sheet with a thin glass layer. Deep navy canvas with a 120 px / 24 px blueprint grid, hairline off-white linework, warm amber for the active and highlighted thing, monospace for data. Data is the decoration; no photography, no gradients beyond the grid. This is a dark-only app.

Research: no Refero MCP on this machine (fallback allowed). Reference lock: the repo's own `index.css` comment block and the console's existing screens, plus peer catalogues in `docs/research/`. Reject Jane's-style corporate light UI and "tactical HUD" green-on-black cliches. Decision ledger: amber is the only accent (focus, selection, primary data series); status colours (green/red/cyan/orange) are for chart series and indicators only; shadows are replaced by 1 px lines and low-alpha glass; Barlow Condensed for UI, Share Tech Mono for figures.

## Tokens (as shipped, with the audit fix)
| Token | HSL | Hex | Note |
|---|---|---|---|
| base | 215 55% 10% | `#0b1728` | canvas |
| surface / surface-2 | 215 45% 13% / 215 40% 16% | `#121f30` / `#182639` | panels |
| text | 210 15% 85% | `#d3d9de` | |
| text-muted | **210 15% 62%** (was 55%) | | |
| text-faint | **210 12% 58%** (was 45%) | | |
| accent | 38 90% 58% | `#f4ae34` | |
| accent-text | 38 95% 70% | `#fbc66a` | |
| green / red / cyan / orange | 142 50% 45% / 0 55% 50% / 190 65% 50% / 25 80% 55% | | series and status |

Contrast (WCAG, computed), before to after the fix:
- text on base 12.60; accent on base 9.35; accent-text on base 11.45.
- muted on base 5.22 to 6.16; muted on surface-2 **4.43 (fail)** to 5.23.
- faint on base **3.69 (fail)** to 5.80; faint on surface-2 **3.13 (fail)** to 4.92.
- red on base 3.46 (below 4.5): acceptable only for non-text series and indicators; do not use `--bp-red` for text.

## Glyphs and motion
Icons are the custom stroked set in `components/MilitaryIcons.tsx` plus lucide for UI chrome. Mark: quadrant datum (a ring and cross with two filled quadrants), a drafting symbol rather than a weapon or targeting motif. Motion: 80-200 ms fades and row hovers only; all disabled under `prefers-reduced-motion` (added in this pass).

## Known gaps
- Stats "Top countries" bars use flag colours; some are near-invisible on navy (ROADMAP P3).
- Sidebar footer credits "Created with Perplexity Computer"; kept as found.

## Assets
`assets/brand/` (logo, dark logo, wordmarks, previews). The app favicon is `frontend/client/public/favicon.svg`.
