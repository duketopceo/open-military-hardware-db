import { useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Search, Plus, X, GitCompare,
  Shield, DollarSign, Swords, Globe
} from "lucide-react";
import { MILITARY_ICONS, MissileIcon } from "@/components/MilitaryIcons";
import type { PlatformListResponse, CompareResponse, PlatformSummary } from "@/lib/api";
import { categoryConfig } from "@/lib/api";
import { AppShell } from "@/components/AppShell";

const CATEGORY_ICONS = MILITARY_ICONS;

export default function ComparePage() {
  const [selectedIds, setSelectedIds] = useState<string[]>([]);
  const [search, setSearch] = useState("");

  const { data: searchResults } = useQuery<PlatformListResponse>({
    queryKey: [`/api/v1/platforms?search=${search}&limit=10`],
    enabled: search.length >= 2,
  });

  const { data: comparison, isLoading: comparing } = useQuery<CompareResponse>({
    queryKey: [`/api/v1/compare?ids=${selectedIds.join(",")}`],
    enabled: selectedIds.length >= 2,
  });

  const addPlatform = (id: string) => {
    if (!selectedIds.includes(id) && selectedIds.length < 10) {
      setSelectedIds([...selectedIds, id]);
      setSearch("");
    }
  };

  const removePlatform = (id: string) => {
    setSelectedIds(selectedIds.filter((i) => i !== id));
  };

  return (
    <AppShell>
      <div className="flex flex-col h-full overflow-hidden">
        {/* Header bar */}
        <div className="px-3 py-2.5 border-b border-[hsl(var(--bp-line-faint))] flex items-center gap-3">
          <GitCompare className="w-4 h-4 text-[hsl(var(--bp-accent))] opacity-70" />
          <h1 className="text-[11px] font-semibold tracking-[0.15em] text-[hsl(var(--bp-text))]">
            COMPARE PLATFORMS
          </h1>
          <span className="text-[9px] font-mono text-[hsl(var(--bp-text-faint))] tracking-wide">
            SELECT 2–10 SYSTEMS
          </span>
          <div className="flex-1" />
          <span className="text-[10px] font-mono text-[hsl(var(--bp-text-faint))] tabular-nums tracking-wide">
            {selectedIds.length} SELECTED
          </span>
        </div>

        {/* Search + tags */}
        <div className="px-3 py-2.5 space-y-2 border-b border-[hsl(var(--bp-line-faint)/0.5)]">
          <div className="relative max-w-md">
            <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-[hsl(var(--bp-text-faint))]" />
            <Input
              data-testid="input-compare-search"
              type="search"
              placeholder="Search platforms to compare..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="pl-8 h-8 text-[11px] font-mono bg-transparent border-[hsl(var(--bp-line-faint))] text-[hsl(var(--bp-text))] placeholder:text-[hsl(var(--bp-text-faint))] focus-visible:ring-[hsl(var(--bp-accent))] focus-visible:ring-1 focus-visible:border-[hsl(var(--bp-accent)/0.5)]"
            />

            {/* Dropdown results */}
            {search.length >= 2 && searchResults && searchResults.platforms.length > 0 && (
              <div className="absolute z-20 top-full mt-1 w-full rounded glass-heavy overflow-hidden">
                {searchResults.platforms
                  .filter((p) => !selectedIds.includes(p.platform_id))
                  .slice(0, 6)
                  .map((p) => {
                    const CatIcon = CATEGORY_ICONS[p.category_id] || MissileIcon;
                    return (
                      <button
                        key={p.platform_id}
                        onClick={() => addPlatform(p.platform_id)}
                        className="flex items-center gap-2 w-full px-3 py-2 text-[11px] hover:bg-[var(--glass-bg-hover)] transition-colors text-left"
                        data-testid={`add-compare-${p.platform_id}`}
                      >
                        <CatIcon className="w-3 h-3 text-[hsl(var(--bp-text-faint))] flex-shrink-0" />
                        <span className="truncate font-mono text-[hsl(var(--bp-text))]">{p.common_name}</span>
                        <span className="text-[9px] text-[hsl(var(--bp-text-faint))] ml-auto flex-shrink-0 uppercase tracking-wider">{p.category_id}</span>
                        <Plus className="w-3 h-3 text-[hsl(var(--bp-accent))] flex-shrink-0 opacity-70" />
                      </button>
                    );
                  })}
              </div>
            )}
          </div>

          {/* Selected tags */}
          {selectedIds.length > 0 && (
            <div className="flex flex-wrap gap-1.5">
              {selectedIds.map((id) => (
                <span key={id} className="tag-chip active flex items-center gap-1">
                  {id.replace(/-/g, " ").replace(/\b\w/g, l => l.toUpperCase()).substring(0, 30)}
                  <button onClick={() => removePlatform(id)} className="ml-0.5 opacity-60 hover:opacity-100">
                    <X className="w-2.5 h-2.5" />
                  </button>
                </span>
              ))}
            </div>
          )}
        </div>

        {/* Content */}
        <div className="flex-1 overflow-auto overscroll-contain">
          {/* Empty state */}
          {selectedIds.length < 2 && (
            <div className="flex flex-col items-center justify-center py-24 gap-4">
              <GitCompare className="w-8 h-8 text-[hsl(var(--bp-text-faint))]" />
              <p className="text-[11px] text-[hsl(var(--bp-text-muted))] tracking-wide">
                SELECT AT LEAST 2 PLATFORMS TO COMPARE
              </p>
            </div>
          )}

          {/* Loading */}
          {comparing && selectedIds.length >= 2 && (
            <div className="p-4 space-y-3">
              <div className="glass rounded h-8 animate-pulse" />
              <div className="glass rounded h-64 animate-pulse" />
            </div>
          )}

          {/* Comparison table */}
          {comparison && comparison.platforms.length >= 2 && (
            <table className="intel-table" data-testid="table-compare">
              <thead>
                <tr>
                  <th className="sticky left-0 z-10 bg-[hsl(var(--bp-surface))] min-w-[130px]">
                    FIELD
                  </th>
                  {comparison.platforms.map((p) => {
                    const CatIcon = CATEGORY_ICONS[p.category_id] || MissileIcon;
                    return (
                      <th key={p.platform_id} className="min-w-[160px]">
                        <span className="flex items-center gap-1.5">
                          <CatIcon className="w-3 h-3 opacity-50" />
                          {p.common_name}
                        </span>
                      </th>
                    );
                  })}
                </tr>
              </thead>
              <tbody>
                {/* Basic info rows */}
                {[
                  { label: "Designation", key: "official_designation" },
                  { label: "Category", key: "category_id" },
                  { label: "Manufacturer", key: "manufacturer" },
                  { label: "Country", key: "country_of_origin" },
                  { label: "Service Year", key: "entered_service_year" },
                  { label: "Status", key: "status_id" },
                  { label: "Units Built", key: "units_built" },
                ].map((field) => (
                  <tr key={field.key}>
                    <td className="sticky left-0 z-10 bg-[hsl(var(--bp-base))] font-semibold text-[hsl(var(--bp-text-muted))]">
                      {field.label}
                    </td>
                    {comparison.platforms.map((p: any) => (
                      <td key={p.platform_id}>
                        {field.key === "status_id" && p[field.key] ? (
                          <span className={`tag-chip ${p[field.key] === "active" ? "active" : ""}`}>
                            {String(p[field.key]).replace(/_/g, " ")}
                          </span>
                        ) : field.key === "category_id" && p[field.key] ? (
                          <span className="tag-chip">{p[field.key]}</span>
                        ) : p[field.key] !== null && p[field.key] !== undefined ? (
                          typeof p[field.key] === "number"
                            ? p[field.key].toLocaleString()
                            : String(p[field.key])
                        ) : "—"}
                      </td>
                    ))}
                  </tr>
                ))}

                {/* Separator */}
                <tr>
                  <td colSpan={comparison.platforms.length + 1} className="!p-0">
                    <div className="h-px bg-[hsl(var(--bp-accent)/0.2)]" />
                  </td>
                </tr>

                {/* Specs */}
                {(() => {
                  const allSpecKeys = new Set<string>();
                  comparison.platforms.forEach((p) => {
                    Object.keys(p.specifications || {}).forEach((k) => {
                      if (!k.endsWith("_id") && k !== "platform_id") allSpecKeys.add(k);
                    });
                  });
                  const specKeys = Array.from(allSpecKeys).slice(0, 20);
                  if (specKeys.length === 0) return null;
                  return (
                    <>
                      <tr>
                        <td colSpan={comparison.platforms.length + 1} className="!py-2">
                          <span className="label-caps flex items-center gap-1.5">
                            <Shield className="w-3 h-3 opacity-50" /> Specifications
                          </span>
                        </td>
                      </tr>
                      {specKeys.map((key) => (
                        <tr key={`spec-${key}`}>
                          <td className="sticky left-0 z-10 bg-[hsl(var(--bp-base))] font-semibold text-[hsl(var(--bp-text-muted))]">
                            {key.replace(/_/g, " ").replace(/\b\w/g, l => l.toUpperCase())}
                          </td>
                          {comparison.platforms.map((p) => (
                            <td key={p.platform_id} className="font-mono">
                              {(p.specifications as any)?.[key] ?? "—"}
                            </td>
                          ))}
                        </tr>
                      ))}
                    </>
                  );
                })()}

                {/* Separator */}
                <tr>
                  <td colSpan={comparison.platforms.length + 1} className="!p-0">
                    <div className="h-px bg-[hsl(var(--bp-accent)/0.2)]" />
                  </td>
                </tr>

                {/* Armaments count */}
                <tr>
                  <td className="sticky left-0 z-10 bg-[hsl(var(--bp-base))] font-semibold text-[hsl(var(--bp-text-muted))]">
                    <span className="flex items-center gap-1.5">
                      <Swords className="w-3 h-3 opacity-40" /> Armaments
                    </span>
                  </td>
                  {comparison.platforms.map((p) => (
                    <td key={p.platform_id}>
                      <span className="font-mono">{p.armaments?.length || 0}</span>
                      <span className="text-[hsl(var(--bp-text-faint))] ml-1">systems</span>
                    </td>
                  ))}
                </tr>

                {/* Operators count */}
                <tr>
                  <td className="sticky left-0 z-10 bg-[hsl(var(--bp-base))] font-semibold text-[hsl(var(--bp-text-muted))]">
                    <span className="flex items-center gap-1.5">
                      <Globe className="w-3 h-3 opacity-40" /> Operators
                    </span>
                  </td>
                  {comparison.platforms.map((p) => (
                    <td key={p.platform_id}>
                      <span className="font-mono">{p.operators?.length || 0}</span>
                      <span className="text-[hsl(var(--bp-text-faint))] ml-1">nations</span>
                    </td>
                  ))}
                </tr>
              </tbody>
            </table>
          )}
        </div>
      </div>
    </AppShell>
  );
}
