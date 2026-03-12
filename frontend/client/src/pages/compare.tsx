import { useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Search, Plus, X, GitCompare, Plane, Truck, Ship, Crosshair } from "lucide-react";
import type { PlatformListResponse, CompareResponse, PlatformSummary } from "@/lib/api";
import { categoryConfig } from "@/lib/api";

const CATEGORY_ICONS: Record<string, React.ElementType> = {
  air: Plane, land: Truck, sea: Ship, munition: Crosshair,
};

export default function ComparePage() {
  const [selectedIds, setSelectedIds] = useState<string[]>([]);
  const [search, setSearch] = useState("");

  // Search for platforms to add
  const { data: searchResults } = useQuery<PlatformListResponse>({
    queryKey: [`/api/v1/platforms?search=${search}&limit=10`],
    enabled: search.length >= 2,
  });

  // Compare selected platforms
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
    <div className="p-4 space-y-5">
      <div className="flex items-center gap-3">
        <GitCompare className="w-5 h-5 text-primary" />
        <h1 className="text-lg font-bold">Compare Platforms</h1>
        <span className="text-xs text-muted-foreground">Select 2–10 platforms</span>
      </div>

      {/* Search / add */}
      <div className="max-w-md relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
        <Input
          data-testid="input-compare-search"
          type="search"
          placeholder="Search to add platforms..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="pl-9 h-9 bg-card border-card-border text-sm"
        />

        {/* Dropdown results */}
        {search.length >= 2 && searchResults && searchResults.platforms.length > 0 && (
          <div className="absolute z-20 top-full mt-1 w-full rounded-md border border-popover-border bg-popover overflow-hidden">
            {searchResults.platforms
              .filter((p) => !selectedIds.includes(p.platform_id))
              .slice(0, 6)
              .map((p) => {
                const CatIcon = CATEGORY_ICONS[p.category_id] || Crosshair;
                return (
                  <button
                    key={p.platform_id}
                    onClick={() => addPlatform(p.platform_id)}
                    className="flex items-center gap-2 w-full px-3 py-2 text-sm hover:bg-accent/40 transition-colors text-left"
                    data-testid={`add-compare-${p.platform_id}`}
                  >
                    <CatIcon className="w-3.5 h-3.5 text-muted-foreground flex-shrink-0" />
                    <span className="truncate">{p.common_name}</span>
                    <span className="text-[10px] text-muted-foreground ml-auto flex-shrink-0">{p.category_id}</span>
                    <Plus className="w-3.5 h-3.5 text-primary flex-shrink-0" />
                  </button>
                );
              })}
          </div>
        )}
      </div>

      {/* Selected tags */}
      {selectedIds.length > 0 && (
        <div className="flex flex-wrap gap-2">
          {selectedIds.map((id) => (
            <Badge key={id} variant="secondary" className="text-xs gap-1 pr-1">
              {id.replace(/-/g, " ").replace(/\b\w/g, l => l.toUpperCase()).substring(0, 30)}
              <button onClick={() => removePlatform(id)} className="ml-1 p-0.5 hover:bg-accent rounded">
                <X className="w-3 h-3" />
              </button>
            </Badge>
          ))}
        </div>
      )}

      {/* Comparison table */}
      {selectedIds.length < 2 && (
        <div className="flex flex-col items-center justify-center py-16 text-muted-foreground gap-3">
          <GitCompare className="w-10 h-10" />
          <p className="text-sm">Select at least 2 platforms to compare</p>
        </div>
      )}

      {comparing && selectedIds.length >= 2 && (
        <div className="space-y-3">
          <Skeleton className="h-10 w-full" />
          <Skeleton className="h-64 w-full" />
        </div>
      )}

      {comparison && comparison.platforms.length >= 2 && (
        <div className="overflow-x-auto rounded-lg border border-card-border">
          <table className="w-full text-xs" data-testid="table-compare">
            <thead>
              <tr className="bg-card border-b border-card-border">
                <th className="text-left px-3 py-2.5 font-semibold text-muted-foreground sticky left-0 bg-card z-10 min-w-[120px]">
                  Field
                </th>
                {comparison.platforms.map((p) => (
                  <th key={p.platform_id} className="text-left px-3 py-2.5 font-semibold min-w-[160px]">
                    <div className="flex items-center gap-1.5">
                      {(() => {
                        const CatIcon = CATEGORY_ICONS[p.category_id] || Crosshair;
                        return <CatIcon className="w-3.5 h-3.5" style={{ color: categoryConfig[p.category_id]?.color }} />;
                      })()}
                      {p.common_name}
                    </div>
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {/* Basic info */}
              {[
                { label: "Designation", key: "official_designation" },
                { label: "Category", key: "category_id" },
                { label: "Manufacturer", key: "manufacturer" },
                { label: "Country", key: "country_of_origin" },
                { label: "Service Year", key: "entered_service_year" },
                { label: "Status", key: "status_id" },
                { label: "Units Built", key: "units_built" },
              ].map((field) => (
                <tr key={field.key} className="border-b border-border/30 hover:bg-accent/20">
                  <td className="px-3 py-2 font-medium text-muted-foreground sticky left-0 bg-background/80 z-10">
                    {field.label}
                  </td>
                  {comparison.platforms.map((p: any) => (
                    <td key={p.platform_id} className="px-3 py-2 tabular-nums">
                      {p[field.key] !== null && p[field.key] !== undefined
                        ? typeof p[field.key] === "number"
                          ? p[field.key].toLocaleString()
                          : String(p[field.key])
                        : "—"}
                    </td>
                  ))}
                </tr>
              ))}

              {/* Specs */}
              {(() => {
                const allSpecKeys = new Set<string>();
                comparison.platforms.forEach((p) => {
                  Object.keys(p.specifications || {}).forEach((k) => {
                    if (!k.endsWith("_id") && k !== "platform_id") allSpecKeys.add(k);
                  });
                });
                return Array.from(allSpecKeys).slice(0, 20).map((key) => (
                  <tr key={`spec-${key}`} className="border-b border-border/30 hover:bg-accent/20">
                    <td className="px-3 py-2 font-medium text-muted-foreground sticky left-0 bg-background/80 z-10">
                      {key.replace(/_/g, " ").replace(/\b\w/g, l => l.toUpperCase())}
                    </td>
                    {comparison.platforms.map((p) => (
                      <td key={p.platform_id} className="px-3 py-2 font-mono tabular-nums">
                        {(p.specifications as any)?.[key] ?? "—"}
                      </td>
                    ))}
                  </tr>
                ));
              })()}

              {/* Armaments count */}
              <tr className="border-b border-border/30 hover:bg-accent/20">
                <td className="px-3 py-2 font-medium text-muted-foreground sticky left-0 bg-background/80 z-10">
                  Armaments
                </td>
                {comparison.platforms.map((p) => (
                  <td key={p.platform_id} className="px-3 py-2 tabular-nums">
                    {p.armaments?.length || 0} systems
                  </td>
                ))}
              </tr>

              {/* Operators count */}
              <tr className="border-b border-border/30 hover:bg-accent/20">
                <td className="px-3 py-2 font-medium text-muted-foreground sticky left-0 bg-background/80 z-10">
                  Operators
                </td>
                {comparison.platforms.map((p) => (
                  <td key={p.platform_id} className="px-3 py-2 tabular-nums">
                    {p.operators?.length || 0} nations
                  </td>
                ))}
              </tr>
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
