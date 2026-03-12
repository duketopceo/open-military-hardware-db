import { useQuery } from "@tanstack/react-query";
import { Skeleton } from "@/components/ui/skeleton";
import { Database, Shield, DollarSign, Swords, Globe, BookOpen, Plane, Crosshair } from "lucide-react";
import {
  BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell, Legend
} from "recharts";
import type { StatsResponse } from "@/lib/api";

const CHART_COLORS = [
  "hsl(142, 50%, 50%)",
  "hsl(38, 85%, 55%)",
  "hsl(200, 60%, 55%)",
  "hsl(0, 65%, 55%)",
  "hsl(262, 50%, 60%)",
  "hsl(180, 40%, 50%)",
  "hsl(320, 50%, 55%)",
  "hsl(60, 60%, 50%)",
];

function KpiCard({ label, value, icon: Icon }: { label: string; value: number | string; icon: React.ElementType }) {
  return (
    <div className="p-4 rounded-lg border border-card-border bg-card" data-testid={`kpi-${label.toLowerCase().replace(/\s+/g, "-")}`}>
      <div className="flex items-center gap-2 mb-2">
        <Icon className="w-4 h-4 text-primary" />
        <span className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">{label}</span>
      </div>
      <p className="text-xl font-bold tabular-nums">{typeof value === "number" ? value.toLocaleString() : value}</p>
    </div>
  );
}

function CustomTooltip({ active, payload, label }: any) {
  if (active && payload && payload.length) {
    return (
      <div className="px-3 py-2 rounded-md bg-popover border border-popover-border text-sm">
        <p className="font-medium text-foreground">{label}</p>
        <p className="text-muted-foreground tabular-nums">{payload[0].value.toLocaleString()}</p>
      </div>
    );
  }
  return null;
}

export default function StatsPage() {
  const { data: stats, isLoading } = useQuery<StatsResponse>({
    queryKey: ["/api/v1/stats"],
  });

  if (isLoading || !stats) {
    return (
      <div className="p-4 space-y-4">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {Array.from({ length: 8 }).map((_, i) => (
            <Skeleton key={i} className="h-20 rounded-lg" />
          ))}
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Skeleton className="h-64 rounded-lg" />
          <Skeleton className="h-64 rounded-lg" />
        </div>
      </div>
    );
  }

  const categoryData = Object.entries(stats.categories).map(([k, v]) => ({
    name: k.charAt(0).toUpperCase() + k.slice(1),
    value: v,
  }));

  const statusData = Object.entries(stats.statuses)
    .filter(([_, v]) => v > 0)
    .map(([k, v]) => ({
      name: k.replace(/_/g, " ").replace(/\b\w/g, l => l.toUpperCase()),
      value: v,
    }));

  const eraData = Object.entries(stats.eras)
    .filter(([_, v]) => v > 0)
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([k, v]) => ({
      name: k,
      value: v,
    }));

  const countryData = Object.entries(stats.countries)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 10)
    .map(([k, v]) => ({ name: k, value: v }));

  return (
    <div className="p-4 space-y-5">
      {/* KPI cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        <KpiCard label="Platforms" value={stats.platforms_count} icon={Database} />
        <KpiCard label="Specifications" value={stats.specifications_count} icon={Shield} />
        <KpiCard label="Economics" value={stats.economics_count} icon={DollarSign} />
        <KpiCard label="Armaments" value={stats.armaments_count} icon={Swords} />
        <KpiCard label="Operators" value={stats.operators_count} icon={Globe} />
        <KpiCard label="Conflicts" value={stats.platform_conflicts_count} icon={Crosshair} />
        <KpiCard label="Media" value={stats.media_count} icon={Plane} />
        <KpiCard label="Sources" value={stats.sources_count} icon={BookOpen} />
      </div>

      {/* Charts row */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {/* Category Pie */}
        <div className="rounded-lg border border-card-border bg-card p-4">
          <h3 className="text-sm font-semibold mb-3">By Category</h3>
          <ResponsiveContainer width="100%" height={220}>
            <PieChart>
              <Pie
                data={categoryData}
                cx="50%"
                cy="50%"
                innerRadius={50}
                outerRadius={80}
                dataKey="value"
                stroke="none"
              >
                {categoryData.map((_, i) => (
                  <Cell key={i} fill={CHART_COLORS[i % CHART_COLORS.length]} />
                ))}
              </Pie>
              <Tooltip content={<CustomTooltip />} />
              <Legend
                formatter={(value) => <span className="text-xs text-muted-foreground">{value}</span>}
              />
            </PieChart>
          </ResponsiveContainer>
        </div>

        {/* Status Pie */}
        <div className="rounded-lg border border-card-border bg-card p-4">
          <h3 className="text-sm font-semibold mb-3">By Status</h3>
          <ResponsiveContainer width="100%" height={220}>
            <PieChart>
              <Pie
                data={statusData}
                cx="50%"
                cy="50%"
                innerRadius={50}
                outerRadius={80}
                dataKey="value"
                stroke="none"
              >
                {statusData.map((_, i) => (
                  <Cell key={i} fill={CHART_COLORS[i % CHART_COLORS.length]} />
                ))}
              </Pie>
              <Tooltip content={<CustomTooltip />} />
              <Legend
                formatter={(value) => <span className="text-xs text-muted-foreground">{value}</span>}
              />
            </PieChart>
          </ResponsiveContainer>
        </div>

        {/* Era Bar */}
        <div className="rounded-lg border border-card-border bg-card p-4">
          <h3 className="text-sm font-semibold mb-3">By Era</h3>
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={eraData}>
              <XAxis
                dataKey="name"
                tick={{ fill: "hsl(200, 6%, 55%)", fontSize: 10 }}
                axisLine={false}
                tickLine={false}
              />
              <YAxis
                tick={{ fill: "hsl(200, 6%, 55%)", fontSize: 10 }}
                axisLine={false}
                tickLine={false}
                width={30}
              />
              <Tooltip content={<CustomTooltip />} />
              <Bar dataKey="value" fill="hsl(142, 50%, 50%)" radius={[3, 3, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Country Bar */}
        <div className="rounded-lg border border-card-border bg-card p-4">
          <h3 className="text-sm font-semibold mb-3">Top Countries</h3>
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={countryData} layout="vertical">
              <XAxis
                type="number"
                tick={{ fill: "hsl(200, 6%, 55%)", fontSize: 10 }}
                axisLine={false}
                tickLine={false}
              />
              <YAxis
                type="category"
                dataKey="name"
                tick={{ fill: "hsl(200, 6%, 55%)", fontSize: 10 }}
                axisLine={false}
                tickLine={false}
                width={30}
              />
              <Tooltip content={<CustomTooltip />} />
              <Bar dataKey="value" fill="hsl(38, 85%, 55%)" radius={[0, 3, 3, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
}
