import { useQuery } from "@tanstack/react-query";
import { useState, useMemo, useRef, useEffect } from "react";
import { useSearch } from "wouter";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  Search, ChevronUp, ChevronDown, X, ArrowUpDown,
  ExternalLink, Shield,
  DollarSign, Swords, Globe, BookOpen, Factory, ChevronRight
} from "lucide-react";
import { MILITARY_ICONS, SUBCATEGORY_ICONS, MissileIcon } from "@/components/MilitaryIcons";
import type { PlatformListResponse, PlatformDetail } from "@/lib/api";
import { categoryConfig, statusConfig, countryFlag } from "@/lib/api";
import { AppShell } from "@/components/AppShell";

const CATEGORY_ICONS = MILITARY_ICONS;

const PAGE_SIZE = 50;

const ROLE_TYPES = [
  { id: "offensive", label: "OFFENSIVE", color: "var(--bp-red)" },
  { id: "defensive", label: "DEFENSIVE", color: "var(--bp-cyan)" },
  { id: "dual", label: "DUAL-ROLE", color: "var(--bp-accent)" },
  { id: "support", label: "SUPPORT", color: "var(--bp-green)" },
  { id: "intelligence", label: "INTEL", color: "var(--bp-orange)" },
];

// ─── Detail Panel (Right Pane) ───
function DetailPanel({ platform }: { platform: PlatformDetail }) {
  const specs = platform.specifications || {};
  const econ = platform.economics || {};
  const CatIcon = CATEGORY_ICONS[platform.category_id] || MissileIcon;

  const filteredSpecs = Object.entries(specs).filter(
    ([k, v]) => !k.endsWith("_id") && k !== "platform_id" && !k.includes("created_at") && !k.includes("updated_at") && v !== null && v !== undefined && v !== ""
  );

  const filteredEcon = Object.entries(econ).filter(
    ([k, v]) => !k.endsWith("_id") && k !== "platform_id" && !k.includes("created_at") && !k.includes("updated_at") && v !== null && v !== undefined && v !== ""
  );

  return (
    <div className="p-3 space-y-4 animate-in">
      {/* Header */}
      <div>
        <div className="flex items-center gap-2 mb-1">
          <CatIcon className="w-4 h-4 text-[hsl(var(--bp-accent))] opacity-70" />
          <h2 className="text-sm font-semibold tracking-tight text-[hsl(var(--bp-text))]" data-testid="detail-name">
            {platform.common_name}
          </h2>
        </div>
        {platform.official_designation && (
          <p className="text-[10px] font-mono text-[hsl(var(--bp-text-muted))] tracking-wide">{platform.official_designation}</p>
        )}
        <div className="flex flex-wrap gap-1.5 mt-2">
          {platform.nato_reporting_name && (
            <span className="tag-chip">NATO: {platform.nato_reporting_name}</span>
          )}
          <span className="tag-chip">{countryFlag(platform.country_of_origin)} {platform.country_of_origin}</span>
          <span className="tag-chip">{platform.category_id}</span>
          {(platform as any).role_type && (
            <span className="tag-chip">{(platform as any).role_type.toUpperCase()}</span>
          )}
          {platform.status_id && <span className="tag-chip">{platform.status_id.replace(/_/g, " ")}</span>}
        </div>
      </div>

      {platform.description && (
        <p className="text-[11px] text-[hsl(var(--bp-text-muted))] leading-relaxed">{platform.description}</p>
      )}

      {/* Timeline strip */}
      {platform.entered_service_year && (
        <div>
          <p className="label-caps mb-1">Service timeline</p>
          <div className="timeline-strip">
            <div
              className="timeline-bar"
              style={{
                left: `${Math.max(0, ((platform.entered_service_year - 1940) / 90) * 100)}%`,
                right: platform.status_id === "retired" ? "30%" : "2%",
              }}
            />
            <span className="absolute top-0 text-[9px] font-mono text-[hsl(var(--bp-text-faint))]" style={{
              left: `${Math.max(0, ((platform.entered_service_year - 1940) / 90) * 100)}%`,
            }}>
              {platform.entered_service_year}
            </span>
          </div>
        </div>
      )}

      {/* Specs */}
      {filteredSpecs.length > 0 && (
        <div>
          <p className="label-caps mb-1.5 flex items-center gap-1.5">
            <Shield className="w-3 h-3 opacity-50" /> Specifications
          </p>
          <div className="space-y-0 glass rounded p-2">
            {filteredSpecs.slice(0, 15).map(([k, v]) => (
              <div key={k} className="flex justify-between items-baseline py-1 border-b border-[hsl(var(--bp-line-faint)/0.3)] last:border-b-0">
                <span className="text-[10px] text-[hsl(var(--bp-text-muted))]">
                  {k.replace(/_/g, " ").replace(/\b\w/g, l => l.toUpperCase())}
                </span>
                <span className="data-mono text-[10px] text-[hsl(var(--bp-text))] ml-3 text-right">
                  {typeof v === "number" ? v.toLocaleString() : String(v)}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Economics */}
      {filteredEcon.length > 0 && (
        <div>
          <p className="label-caps mb-1.5 flex items-center gap-1.5">
            <DollarSign className="w-3 h-3 opacity-50" /> Economics
          </p>
          <div className="space-y-0 glass rounded p-2">
            {filteredEcon.map(([k, v]) => {
              let display = v;
              if (typeof v === "number" && (k.includes("cost") || k.includes("price") || k.includes("budget"))) {
                display = `$${v.toLocaleString()}`;
              }
              return (
                <div key={k} className="flex justify-between items-baseline py-1 border-b border-[hsl(var(--bp-line-faint)/0.3)] last:border-b-0">
                  <span className="text-[10px] text-[hsl(var(--bp-text-muted))]">
                    {k.replace(/_/g, " ").replace(/\b\w/g, l => l.toUpperCase())}
                  </span>
                  <span className="data-mono text-[10px] text-[hsl(var(--bp-text))] ml-3 text-right">
                    {typeof display === "number" ? display.toLocaleString() : String(display)}
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Armaments */}
      {platform.armaments.length > 0 && (
        <div>
          <p className="label-caps mb-1.5 flex items-center gap-1.5">
            <Swords className="w-3 h-3 opacity-50" /> Primary armament ({platform.armaments.length})
          </p>
          <div className="space-y-1">
            {platform.armaments.map((a, i) => (
              <div key={i} className="glass rounded px-2 py-1.5">
                <span className="text-[10px] font-medium text-[hsl(var(--bp-text))]">
                  {a.weapon_name || a.armament_name || `System ${i + 1}`}
                </span>
                {a.weapon_type && (
                  <span className="text-[9px] text-[hsl(var(--bp-text-faint))] ml-2">{a.weapon_type}</span>
                )}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Operators */}
      {platform.operators.length > 0 && (
        <div>
          <p className="label-caps mb-1.5 flex items-center gap-1.5">
            <Globe className="w-3 h-3 opacity-50" /> Operators ({platform.operators.length})
          </p>
          <div className="flex flex-wrap gap-1">
            {platform.operators.map((op, i) => (
              <span key={i} className="tag-chip">
                {op.country_code ? countryFlag(op.country_code) + ' ' : ''}{op.country_name || op.operator_name || op.country_code}
                {op.quantity ? ` (${op.quantity})` : ""}
              </span>
            ))}
          </div>
        </div>
      )}

      {/* Conflicts */}
      {platform.conflicts.length > 0 && (
        <div>
          <p className="label-caps mb-1.5 flex items-center gap-1.5">
            <Swords className="w-3 h-3 opacity-50" /> Combat history ({platform.conflicts.length})
          </p>
          <div className="space-y-0.5">
            {platform.conflicts.map((c, i) => (
              <div key={i} className="flex items-center justify-between py-0.5">
                <span className="text-[10px] text-[hsl(var(--bp-text-muted))]">{c.conflict_name}</span>
                <span className="text-[9px] font-mono text-[hsl(var(--bp-text-faint))] tabular-nums">
                  {c.start_year}{c.end_year ? `–${c.end_year}` : ""}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Sources */}
      {platform.sources.length > 0 && (
        <div>
          <p className="label-caps mb-1.5 flex items-center gap-1.5">
            <BookOpen className="w-3 h-3 opacity-50" /> Sources ({platform.sources.length})
          </p>
          <div className="space-y-0.5">
            {platform.sources.slice(0, 5).map((s, i) => (
              <div key={i} className="text-[10px] text-[hsl(var(--bp-text-faint))]">
                {s.source_name || s.source_type || "Source"}
                {s.url && (
                  <a href={s.url} target="_blank" rel="noopener noreferrer"
                    className="ml-1 inline-flex items-center gap-0.5 text-[hsl(var(--bp-accent-text))] hover:underline">
                    <ExternalLink className="w-2.5 h-2.5" />
                  </a>
                )}
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

// ─── Main Explorer ───
export default function ExplorerPage() {
  const searchString = useSearch();
  const params = new URLSearchParams(searchString);
  const urlCategory = params.get("category") || "";

  const [search, setSearch] = useState("");
  const [category, setCategory] = useState(urlCategory);

  // Sync URL category param to state
  useEffect(() => {
    setCategory(urlCategory);
    setPage(0);
  }, [urlCategory]);
  const [roleType, setRoleType] = useState("");
  const [manufacturer, setManufacturer] = useState("");
  const [sortBy, setSortBy] = useState("common_name");
  const [sortOrder, setSortOrder] = useState<"asc" | "desc">("asc");
  const [page, setPage] = useState(0);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [mfgOpen, setMfgOpen] = useState(false);
  const mfgRef = useRef<HTMLDivElement>(null);

  // Fetch manufacturers list for dropdown
  const { data: manufacturers } = useQuery<{ manufacturer: string; platform_count: number; categories: string[] }[]>({
    queryKey: ["/api/v1/manufacturers"],
  });

  // Close manufacturer dropdown on outside click
  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (mfgRef.current && !mfgRef.current.contains(e.target as Node)) setMfgOpen(false);
    };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, []);

  const queryParams = useMemo(() => {
    const p = new URLSearchParams();
    if (search) p.set("search", search);
    if (category) p.set("category", category);
    if (roleType) p.set("role_type", roleType);
    if (manufacturer) p.set("manufacturer", manufacturer);
    p.set("sort_by", sortBy);
    p.set("sort_order", sortOrder);
    p.set("limit", String(PAGE_SIZE));
    p.set("offset", String(page * PAGE_SIZE));
    return p.toString();
  }, [search, category, roleType, manufacturer, sortBy, sortOrder, page]);

  const { data, isLoading } = useQuery<PlatformListResponse>({
    queryKey: [`/api/v1/platforms?${queryParams}`],
  });

  // Fetch selected platform detail
  const { data: selectedPlatform } = useQuery<PlatformDetail>({
    queryKey: ["/api/v1/platforms", selectedId],
    enabled: !!selectedId,
  });

  const totalPages = data ? Math.ceil(data.total / PAGE_SIZE) : 0;

  const toggleSort = (field: string) => {
    if (sortBy === field) {
      setSortOrder(sortOrder === "asc" ? "desc" : "asc");
    } else {
      setSortBy(field);
      setSortOrder("asc");
    }
  };

  const SortIcon = ({ field }: { field: string }) => {
    if (sortBy !== field) return <ArrowUpDown className="w-2.5 h-2.5 opacity-30" />;
    return sortOrder === "asc"
      ? <ChevronUp className="w-2.5 h-2.5 text-[hsl(var(--bp-accent))]" />
      : <ChevronDown className="w-2.5 h-2.5 text-[hsl(var(--bp-accent))]" />;
  };

  const rightPanel = selectedPlatform ? <DetailPanel platform={selectedPlatform} /> : null;

  return (
    <AppShell rightPanel={rightPanel}>
      <div className="flex flex-col h-full overflow-hidden">
        {/* Search bar */}
        <div className="px-3 py-2.5 border-b border-[hsl(var(--bp-line-faint))] flex items-center gap-3">
          <div className="relative flex-1 max-w-lg">
            <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-[hsl(var(--bp-text-faint))]" />
            <Input
              data-testid="input-search"
              type="search"
              placeholder="Search platforms... (name, designation, manufacturer)"
              value={search}
              onChange={(e) => { setSearch(e.target.value); setPage(0); }}
              className="pl-8 h-8 text-[11px] font-mono bg-transparent border-[hsl(var(--bp-line-faint))] text-[hsl(var(--bp-text))] placeholder:text-[hsl(var(--bp-text-faint))] focus-visible:ring-[hsl(var(--bp-accent))] focus-visible:ring-1 focus-visible:border-[hsl(var(--bp-accent)/0.5)]"
            />
          </div>

          {search && (
            <button onClick={() => { setSearch(""); setPage(0); }}
              className="text-[hsl(var(--bp-text-faint))] hover:text-[hsl(var(--bp-text))] transition-colors">
              <X className="w-3.5 h-3.5" />
            </button>
          )}

          <div className="flex-1" />

          <span className="text-[10px] font-mono text-[hsl(var(--bp-text-faint))] tabular-nums tracking-wide">
            {data ? `${data.total} RECORDS` : "LOADING..."}
          </span>
        </div>

        {/* Filter bar: Role type pills + Contractor dropdown */}
        <div className="px-3 py-1.5 border-b border-[hsl(var(--bp-line-faint)/0.5)] flex items-center gap-2 flex-wrap">
          {/* Role type pills */}
          <span className="label-caps mr-1">Role</span>
          {ROLE_TYPES.map((r) => (
            <button
              key={r.id}
              onClick={() => { setRoleType(roleType === r.id ? "" : r.id); setPage(0); }}
              data-testid={`filter-role-${r.id}`}
              className={`tag-chip ${
                roleType === r.id ? "active" : ""
              }`}
              style={roleType === r.id ? { borderColor: `hsl(${r.color})`, color: `hsl(${r.color})` } : {}}
            >
              {r.label}
            </button>
          ))}

          <div className="w-px h-4 bg-[hsl(var(--bp-line-faint))] mx-1" />

          {/* Contractor dropdown */}
          <div className="relative" ref={mfgRef}>
            <button
              onClick={() => setMfgOpen(!mfgOpen)}
              data-testid="filter-manufacturer"
              className={`tag-chip flex items-center gap-1 ${manufacturer ? "active" : ""}`}
            >
              <Factory className="w-2.5 h-2.5 opacity-50" />
              {manufacturer || "CONTRACTOR"}
              <ChevronDown className="w-2.5 h-2.5 opacity-40" />
            </button>
            {mfgOpen && manufacturers && (
              <div className="absolute z-30 top-full mt-1 left-0 w-72 max-h-64 overflow-y-auto rounded glass-heavy">
                {manufacturer && (
                  <button
                    onClick={() => { setManufacturer(""); setMfgOpen(false); setPage(0); }}
                    className="flex items-center gap-2 w-full px-3 py-1.5 text-[10px] hover:bg-[var(--glass-bg-hover)] transition-colors text-left text-[hsl(var(--bp-accent-text))]"
                  >
                    <X className="w-2.5 h-2.5" /> CLEAR FILTER
                  </button>
                )}
                {manufacturers.map((m) => (
                  <button
                    key={m.manufacturer}
                    onClick={() => { setManufacturer(m.manufacturer); setMfgOpen(false); setPage(0); }}
                    className={`flex items-center gap-2 w-full px-3 py-1.5 text-[10px] hover:bg-[var(--glass-bg-hover)] transition-colors text-left ${
                      manufacturer === m.manufacturer ? "text-[hsl(var(--bp-accent-text))]" : "text-[hsl(var(--bp-text-muted))]"
                    }`}
                  >
                    <span className="flex-1 truncate font-mono">{m.manufacturer}</span>
                    <span className="text-[9px] tabular-nums opacity-50">{m.platform_count}</span>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Active filter clear */}
          {(roleType || manufacturer) && (
            <button
              onClick={() => { setRoleType(""); setManufacturer(""); setPage(0); }}
              className="text-[9px] text-[hsl(var(--bp-accent-text))] hover:underline tracking-wide ml-1"
            >
              CLEAR ALL
            </button>
          )}
        </div>

        {/* Table */}
        <div className="flex-1 overflow-auto overscroll-contain">
          <table className="intel-table" data-testid="platform-table">
            <thead>
              <tr>
                <th style={{ width: 36 }}></th>
                <th onClick={() => toggleSort("common_name")} style={{ minWidth: 180 }}>
                  <span className="flex items-center gap-1">System <SortIcon field="common_name" /></span>
                </th>
                <th>Designation</th>
                <th onClick={() => toggleSort("category_id")}>
                  <span className="flex items-center gap-1">Type <SortIcon field="category_id" /></span>
                </th>
                <th onClick={() => toggleSort("role_type")}>
                  <span className="flex items-center gap-1">Role <SortIcon field="role_type" /></span>
                </th>
                <th onClick={() => toggleSort("manufacturer")}>
                  <span className="flex items-center gap-1">Manufacturer <SortIcon field="manufacturer" /></span>
                </th>
                <th onClick={() => toggleSort("country_of_origin")}>
                  <span className="flex items-center gap-1">Origin <SortIcon field="country_of_origin" /></span>
                </th>
                <th onClick={() => toggleSort("entered_service_year")} style={{ textAlign: "right" }}>
                  <span className="flex items-center gap-1 justify-end">IOC <SortIcon field="entered_service_year" /></span>
                </th>
                <th style={{ textAlign: "right" }}>Built</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                Array.from({ length: 20 }).map((_, i) => (
                  <tr key={i}>
                    <td colSpan={10}>
                      <div className="h-4 rounded animate-pulse" style={{ background: 'var(--glass-bg)', width: `${60 + Math.random() * 30}%` }} />
                    </td>
                  </tr>
                ))
              ) : (
                (data?.platforms || []).map((p) => {
                  const SubIcon = p.subcategory_id ? SUBCATEGORY_ICONS[p.subcategory_id] : null;
                  const CatIcon = SubIcon || CATEGORY_ICONS[p.category_id] || MissileIcon;
                  const isSelected = selectedId === p.platform_id;
                  return (
                    <tr
                      key={p.platform_id}
                      className={isSelected ? "selected" : ""}
                      onClick={() => setSelectedId(isSelected ? null : p.platform_id)}
                      data-testid={`row-${p.platform_id}`}
                    >
                      <td className="text-center">
                        <CatIcon className="w-3 h-3 inline-block opacity-40" />
                      </td>
                      <td className="font-medium text-[hsl(var(--bp-text))]">{p.common_name}</td>
                      <td className="text-[hsl(var(--bp-text-muted))]">{p.official_designation || "—"}</td>
                      <td>
                        <span className="tag-chip">{p.category_id}</span>
                      </td>
                      <td className="text-[10px] text-[hsl(var(--bp-text-faint))] uppercase tracking-wider">
                        {(p as any).role_type || "—"}
                      </td>
                      <td className="text-[hsl(var(--bp-text-muted))]">{p.manufacturer}</td>
                      <td className="text-[hsl(var(--bp-text-muted))]">{countryFlag(p.country_of_origin)} {p.country_of_origin}</td>
                      <td className="text-right tabular-nums">{p.entered_service_year || "—"}</td>
                      <td className="text-right tabular-nums text-[hsl(var(--bp-text-muted))]">
                        {p.units_built ? p.units_built.toLocaleString() : "—"}
                      </td>
                      <td>
                        {p.status_id && (
                          <span className={`tag-chip ${p.status_id === "active" ? "active" : ""}`}>
                            {p.status_id.replace(/_/g, " ")}
                          </span>
                        )}
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        {totalPages > 1 && (
          <div className="flex items-center justify-between px-3 py-1.5 border-t border-[hsl(var(--bp-line-faint))]">
            <button
              disabled={page === 0}
              onClick={() => setPage(p => p - 1)}
              className="text-[10px] font-mono text-[hsl(var(--bp-text-muted))] hover:text-[hsl(var(--bp-text))] disabled:opacity-30 disabled:cursor-not-allowed tracking-wide"
              data-testid="button-prev"
            >
              ← PREV
            </button>
            <span className="text-[10px] font-mono text-[hsl(var(--bp-text-faint))] tabular-nums">
              PAGE {page + 1} / {totalPages}
            </span>
            <button
              disabled={page >= totalPages - 1}
              onClick={() => setPage(p => p + 1)}
              className="text-[10px] font-mono text-[hsl(var(--bp-text-muted))] hover:text-[hsl(var(--bp-text))] disabled:opacity-30 disabled:cursor-not-allowed tracking-wide"
              data-testid="button-next"
            >
              NEXT →
            </button>
          </div>
        )}
      </div>
    </AppShell>
  );
}
