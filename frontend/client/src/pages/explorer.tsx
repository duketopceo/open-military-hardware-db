import { useQuery } from "@tanstack/react-query";
import { useState, useMemo } from "react";
import { Link, useSearch } from "wouter";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Search, ChevronLeft, ChevronRight, Plane, Truck, Ship, Crosshair,
  ArrowUpDown, Filter, X
} from "lucide-react";
import type { PlatformListResponse, Category } from "@/lib/api";
import { categoryConfig, statusConfig } from "@/lib/api";

const CATEGORY_ICONS: Record<string, React.ElementType> = {
  air: Plane,
  land: Truck,
  sea: Ship,
  munition: Crosshair,
};

const PAGE_SIZE = 25;

export default function ExplorerPage() {
  const searchString = useSearch();
  const params = new URLSearchParams(searchString);
  const initialCategory = params.get("category") || "";

  const [search, setSearch] = useState("");
  const [category, setCategory] = useState(initialCategory);
  const [status, setStatus] = useState("");
  const [sortBy, setSortBy] = useState("common_name");
  const [sortOrder, setSortOrder] = useState("asc");
  const [page, setPage] = useState(0);

  const queryParams = useMemo(() => {
    const p = new URLSearchParams();
    if (search) p.set("search", search);
    if (category) p.set("category", category);
    if (status) p.set("status", status);
    p.set("sort_by", sortBy);
    p.set("sort_order", sortOrder);
    p.set("limit", String(PAGE_SIZE));
    p.set("offset", String(page * PAGE_SIZE));
    return p.toString();
  }, [search, category, status, sortBy, sortOrder, page]);

  const { data, isLoading } = useQuery<PlatformListResponse>({
    queryKey: [`/api/v1/platforms?${queryParams}`],
  });

  const { data: categories } = useQuery<Category[]>({
    queryKey: ["/api/v1/categories"],
  });

  const totalPages = data ? Math.ceil(data.total / PAGE_SIZE) : 0;
  const hasFilters = search || category || status;

  const clearFilters = () => {
    setSearch("");
    setCategory("");
    setStatus("");
    setPage(0);
  };

  return (
    <div className="p-4 space-y-4">
      {/* Filters */}
      <div className="flex flex-wrap items-center gap-3">
        <div className="relative flex-1 min-w-[200px] max-w-md">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input
            data-testid="input-search"
            type="search"
            placeholder="Search platforms..."
            value={search}
            onChange={(e) => { setSearch(e.target.value); setPage(0); }}
            className="pl-9 h-9 bg-card border-card-border text-sm"
          />
        </div>

        <Select value={category} onValueChange={(v) => { setCategory(v === "all" ? "" : v); setPage(0); }}>
          <SelectTrigger className="w-[140px] h-9 bg-card border-card-border text-sm" data-testid="select-category">
            <SelectValue placeholder="Category" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Categories</SelectItem>
            {(categories || []).map((c) => (
              <SelectItem key={c.category_id} value={c.category_id}>
                {c.category_name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Select value={status} onValueChange={(v) => { setStatus(v === "all" ? "" : v); setPage(0); }}>
          <SelectTrigger className="w-[130px] h-9 bg-card border-card-border text-sm" data-testid="select-status">
            <SelectValue placeholder="Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="active">Active</SelectItem>
            <SelectItem value="retired">Retired</SelectItem>
            <SelectItem value="limited">Limited</SelectItem>
            <SelectItem value="prototype">Prototype</SelectItem>
          </SelectContent>
        </Select>

        <Select value={`${sortBy}:${sortOrder}`} onValueChange={(v) => {
          const [s, o] = v.split(":");
          setSortBy(s);
          setSortOrder(o);
          setPage(0);
        }}>
          <SelectTrigger className="w-[160px] h-9 bg-card border-card-border text-sm" data-testid="select-sort">
            <ArrowUpDown className="w-3.5 h-3.5 mr-1.5" />
            <SelectValue placeholder="Sort" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="common_name:asc">Name A-Z</SelectItem>
            <SelectItem value="common_name:desc">Name Z-A</SelectItem>
            <SelectItem value="entered_service_year:desc">Newest First</SelectItem>
            <SelectItem value="entered_service_year:asc">Oldest First</SelectItem>
            <SelectItem value="category_id:asc">Category</SelectItem>
            <SelectItem value="manufacturer:asc">Manufacturer</SelectItem>
          </SelectContent>
        </Select>

        {hasFilters && (
          <Button variant="ghost" size="sm" onClick={clearFilters} className="h-9 text-xs gap-1" data-testid="button-clear-filters">
            <X className="w-3.5 h-3.5" />
            Clear
          </Button>
        )}
      </div>

      {/* Results count */}
      <div className="flex items-center justify-between">
        <p className="text-sm text-muted-foreground tabular-nums">
          {data ? (
            <>
              Showing {data.offset + 1}–{Math.min(data.offset + PAGE_SIZE, data.total)} of{" "}
              <span className="font-medium text-foreground">{data.total}</span> platforms
            </>
          ) : (
            "Loading..."
          )}
        </p>
      </div>

      {/* Platform grid */}
      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-3">
          {Array.from({ length: 9 }).map((_, i) => (
            <div key={i} className="p-4 rounded-lg border border-card-border bg-card space-y-3">
              <Skeleton className="h-5 w-3/4" />
              <Skeleton className="h-4 w-1/2" />
              <Skeleton className="h-3 w-full" />
              <Skeleton className="h-3 w-2/3" />
            </div>
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-3">
          {(data?.platforms || []).map((p) => {
            const CatIcon = CATEGORY_ICONS[p.category_id] || Crosshair;
            const catCfg = categoryConfig[p.category_id];
            const statusCfg = statusConfig[p.status_id || ""];
            return (
              <Link key={p.platform_id} href={`/platform/${p.platform_id}`}>
                <div
                  data-testid={`card-platform-${p.platform_id}`}
                  className="group p-4 rounded-lg border border-card-border bg-card hover:bg-accent/40 transition-colors cursor-pointer"
                >
                  <div className="flex items-start justify-between gap-2 mb-2">
                    <div className="flex items-center gap-2 min-w-0">
                      <CatIcon className="w-4 h-4 flex-shrink-0" style={{ color: catCfg?.color }} />
                      <h3 className="text-sm font-semibold truncate group-hover:text-primary transition-colors">
                        {p.common_name}
                      </h3>
                    </div>
                    {statusCfg && (
                      <Badge variant="outline" className="text-[10px] flex-shrink-0 px-1.5 py-0"
                        style={{ borderColor: statusCfg.color, color: statusCfg.color }}
                      >
                        {statusCfg.label}
                      </Badge>
                    )}
                  </div>

                  {p.official_designation && (
                    <p className="text-xs text-muted-foreground font-mono mb-1.5">{p.official_designation}</p>
                  )}

                  <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-muted-foreground">
                    <span>{p.manufacturer}</span>
                    {p.entered_service_year && (
                      <span className="tabular-nums">{p.entered_service_year}</span>
                    )}
                    {p.units_built && (
                      <span className="tabular-nums">{p.units_built.toLocaleString()} built</span>
                    )}
                  </div>

                  {p.description && (
                    <p className="mt-2 text-xs text-muted-foreground line-clamp-2">
                      {p.description}
                    </p>
                  )}
                </div>
              </Link>
            );
          })}
        </div>
      )}

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-2 py-2">
          <Button
            variant="outline"
            size="sm"
            disabled={page === 0}
            onClick={() => setPage((p) => p - 1)}
            className="h-8 text-xs"
            data-testid="button-prev-page"
          >
            <ChevronLeft className="w-3.5 h-3.5 mr-1" />
            Previous
          </Button>
          <span className="text-sm text-muted-foreground tabular-nums px-2">
            Page {page + 1} of {totalPages}
          </span>
          <Button
            variant="outline"
            size="sm"
            disabled={page >= totalPages - 1}
            onClick={() => setPage((p) => p + 1)}
            className="h-8 text-xs"
            data-testid="button-next-page"
          >
            Next
            <ChevronRight className="w-3.5 h-3.5 ml-1" />
          </Button>
        </div>
      )}
    </div>
  );
}
