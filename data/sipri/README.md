# SIPRI External Data

Data sourced from the [Stockholm International Peace Research Institute (SIPRI)](https://www.sipri.org/) — the world's leading independent international institute dedicated to research into conflict, armaments, arms control and disarmament.

**License:** SIPRI data is free for non-commercial research use with attribution. See [SIPRI terms](https://www.sipri.org/about/terms-and-conditions).

**Citation:** Stockholm International Peace Research Institute (SIPRI). Retrieved March 2026 from https://www.sipri.org/databases

---

## Files

### Raw (original SIPRI downloads)

| File | Source | Description |
|------|--------|-------------|
| `sipri_milex_1949_2024.xlsx` | [SIPRI MILEX Database](https://www.sipri.org/databases/milex) | Military expenditure by country, 1949–2024. Multiple sheets: local currency, constant USD, current USD, % GDP, per capita, % govt spending |
| `sipri_top100_2002_2024.xlsx` | [SIPRI Arms Industry Database](https://www.sipri.org/databases/armsindustry) | Top 100 arms companies by year, 2002–2024. Rank, revenue, country, arms % of total |
| `sipri_total_arms_revenue_2002_2024.xlsx` | [SIPRI Arms Industry Database](https://www.sipri.org/databases/armsindustry) | Aggregate Top 100 revenue totals, 2002–2024 |
| `sipri_usa_transfers_2000_2025.csv` | [SIPRI Arms Transfers Database](https://armstransfers.sipri.org) | US arms transfers to all recipients, 2000–2025. Raw export with metadata headers |

### Clean (processed for integration)

| File | Rows | Description |
|------|------|-------------|
| `milex_constant_usd_millions.csv` | 175 countries | Military spending in constant 2023 USD (millions), 1949–2024. Columns: country, region, 1949...2024 |
| `top100_arms_companies.csv` | 2,300 records | 271 unique arms companies across 23 years. Columns: year, rank, company, country, arms_revenue_usd_m, total_revenue_usd_m, arms_pct_of_total |
| `usa_arms_transfers_2000_2025_clean.csv` | 3,006 records | US arms exports to 130 countries. Columns: recipient, supplier, year_of_order, number_ordered, weapon_designation, weapon_description, number_delivered, year_of_delivery, status, comments, sipri_tiv_per_unit, sipri_tiv_total, sipri_tiv_delivered |

---

## Integration with OMHDB

These datasets expand the database horizontally across several new dimensions:

1. **Country military spending** — contextualizes platform procurement decisions
2. **Arms company financials** — enriches manufacturer data beyond just name
3. **Arms transfers** — maps which platforms were exported to which countries, with quantities and values
4. **Cross-reference** — weapon designations in transfers map to our platform IDs (F-35, HIMARS, Patriot, etc.)

## Data Quality Notes

- SIPRI uses `. .` for unavailable data and `xxx` for non-applicable
- Arms revenue figures are estimates based on open sources
- TIV (Trend Indicator Value) is SIPRI's own measure — not dollar values but relative transfer volumes
- Military expenditure figures in constant 2023 USD allow cross-year comparison
