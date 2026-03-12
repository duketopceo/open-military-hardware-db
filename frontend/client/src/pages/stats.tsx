import { useQuery } from "@tanstack/react-query";
import { Database, Shield, DollarSign, Swords, Globe, BookOpen, Plane, Crosshair } from "lucide-react";
import {
  BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell, Legend
} from "recharts";
import type { StatsResponse } from "@/lib/api";
import { AppShell } from "@/components/AppShell";

const CHART_COLORS = [
  "hsl(38, 90%, 58%)",   // amber
  "hsl(190, 65%, 50%)",  // cyan
  "hsl(142, 50%, 45%)",  // green
  "hsl(0, 55%, 50%)",    // red
  "hsl(25, 80%, 55%)",   // orange
  "hsl(270, 40%, 55%)",  // purple
  "hsl(210, 50%, 55%)",  // blue
];

function KpiCard({ label, value, icon: Icon }: { label: string; value: number | string; icon: React.ElementType }) {
  return (
    <div className="glass rounded p-3 animate-in" data-testid={`kpi-${label.toLowerCase().replace(/\s+/g, "-")}`}>
      <div className="flex items-center gap-1.5 mb-1.5">
        <Icon className="w-3 h-3 text-[hsl(var(--bp-accent))] opacity-60" />
        <span className="label-caps">{label}</span>
      </div>
      <p className="text-lg font-bold font-mono tabular-nums text-[hsl(var(--bp-text))]">
        {typeof value === "number" ? value.toLocaleString() : value}
      </p>
    </div>
  );
}

function BpTooltip({ active, payload, label }: any) {
  if (active && payload?.length) {
    return (
      <div className="glass-heavy rounded px-3 py-2 text-[11px]">
        <p className="font-medium text-[hsl(var(--bp-text))]">{label}</p>
        <p className="font-mono tabular-nums text-[hsl(var(--bp-accent-text))]">{payload[0].value.toLocaleString()}</p>
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
      <AppShell>
        <div className="p-4 space-y-4 stagger-in">
          <div className="grid grid-cols-4 gap-3">
            {Array.from({ length: 8 }).map((_, i) => (
              <div key={i} className="glass rounded h-16 animate-pulse" />
            ))}
          </div>
        </div>
      </AppShell>
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
    .map(([k, v]) => ({ name: k, value: v }));

  const countryData = Object.entries(stats.countries)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 8)
    .map(([k, v]) => ({ name: k, value: v }));

  return (
    <AppShell>
      <div className="flex-1 overflow-y-auto overscroll-contain p-4 space-y-5">
        {/* Header */}
        <div className="flex items-center justify-between">
          <h1 className="text-[11px] font-semibold tracking-[0.2em] text-[hsl(var(--bp-text-muted))]">
            DATABASE ANALYTICS
          </h1>
          <span className="text-[9px] font-mono text-[hsl(var(--bp-text-faint))]">
            LAST UPDATED: {new Date().toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }).toUpperCase()}
          </span>
        </div>

        {/* KPIs */}
        <div className="grid grid-cols-4 gap-3 stagger-in">
          <KpiCard label="Platforms" value={stats.platforms_count} icon={Database} />
          <KpiCard label="Specifications" value={stats.specifications_count} icon={Shield} />
          <KpiCard label="Economics" value={stats.economics_count} icon={DollarSign} />
          <KpiCard label="Armaments" value={stats.armaments_count} icon={Swords} />
          <KpiCard label="Operators" value={stats.operators_count} icon={Globe} />
          <KpiCard label="Conflicts" value={stats.platform_conflicts_count} icon={Crosshair} />
          <KpiCard label="Media Records" value={stats.media_count} icon={Plane} />
          <KpiCard label="Source Citations" value={stats.sources_count} icon={BookOpen} />
        </div>

        {/* Charts */}
        <div className="grid grid-cols-2 gap-4">
          {/* Category */}
          <div className="glass rounded p-3 animate-in">
            <p className="label-caps mb-3">Distribution by domain</p>
            <ResponsiveContainer width="100%" height={200}>
              <PieChart>
                <Pie data={categoryData} cx="50%" cy="50%" innerRadius={45} outerRadius={75} dataKey="value" stroke="none">
                  {categoryData.map((_, i) => (
                    <Cell key={i} fill={CHART_COLORS[i % CHART_COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip content={<BpTooltip />} />
                <Legend formatter={(v) => <span className="text-[10px] font-mono text-[hsl(var(--bp-text-muted))]">{v}</span>} />
              </PieChart>
            </ResponsiveContainer>
          </div>

          {/* Status */}
          <div className="glass rounded p-3 animate-in">
            <p className="label-caps mb-3">Operational status</p>
            <ResponsiveContainer width="100%" height={200}>
              <PieChart>
                <Pie data={statusData} cx="50%" cy="50%" innerRadius={45} outerRadius={75} dataKey="value" stroke="none">
                  {statusData.map((_, i) => (
                    <Cell key={i} fill={CHART_COLORS[i % CHART_COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip content={<BpTooltip />} />
                <Legend formatter={(v) => <span className="text-[10px] font-mono text-[hsl(var(--bp-text-muted))]">{v}</span>} />
              </PieChart>
            </ResponsiveContainer>
          </div>

          {/* Era */}
          <div className="glass rounded p-3 animate-in">
            <p className="label-caps mb-3">Platforms by era</p>
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={eraData}>
                <XAxis dataKey="name" tick={{ fill: "hsl(210, 15%, 55%)", fontSize: 9, fontFamily: "var(--font-mono)" }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fill: "hsl(210, 15%, 55%)", fontSize: 9, fontFamily: "var(--font-mono)" }} axisLine={false} tickLine={false} width={25} />
                <Tooltip content={<BpTooltip />} />
                <Bar dataKey="value" fill="hsl(38, 90%, 58%)" radius={[2, 2, 0, 0]} opacity={0.8} />
              </BarChart>
            </ResponsiveContainer>
          </div>

          {/* Country */}
          <div className="glass rounded p-3 animate-in">
            <p className="label-caps mb-3">Top countries of origin</p>
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={countryData} layout="vertical">
                <XAxis type="number" tick={{ fill: "hsl(210, 15%, 55%)", fontSize: 9, fontFamily: "var(--font-mono)" }} axisLine={false} tickLine={false} />
                <YAxis type="category" dataKey="name" tick={{ fill: "hsl(210, 15%, 55%)", fontSize: 9, fontFamily: "var(--font-mono)" }} axisLine={false} tickLine={false} width={80} />
                <Tooltip content={<BpTooltip />} />
                <Bar dataKey="value" fill="hsl(190, 65%, 50%)" radius={[0, 2, 2, 0]} opacity={0.8} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </AppShell>
  );
}
