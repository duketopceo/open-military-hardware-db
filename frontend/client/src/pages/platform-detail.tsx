import { useQuery } from "@tanstack/react-query";
import { useParams, Link } from "wouter";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  ArrowLeft, Plane, Truck, Ship, Crosshair, ExternalLink,
  Shield, DollarSign, Swords, Globe, BookOpen, AlertTriangle
} from "lucide-react";
import type { PlatformDetail } from "@/lib/api";
import { categoryConfig, statusConfig, countryFlag } from "@/lib/api";

const CATEGORY_ICONS: Record<string, React.ElementType> = {
  air: Plane, land: Truck, sea: Ship, munition: Crosshair,
};

function Section({ title, icon: Icon, children }: { title: string; icon: React.ElementType; children: React.ReactNode }) {
  return (
    <div className="rounded-lg border border-card-border bg-card p-4">
      <h2 className="flex items-center gap-2 text-sm font-semibold mb-3">
        <Icon className="w-4 h-4 text-primary" />
        {title}
      </h2>
      {children}
    </div>
  );
}

function SpecRow({ label, value }: { label: string; value: any }) {
  if (value === null || value === undefined || value === "") return null;
  const display = typeof value === "number" ? value.toLocaleString() : String(value);
  return (
    <div className="flex justify-between items-baseline py-1.5 border-b border-border/40 last:border-b-0">
      <span className="text-xs text-muted-foreground">{label.replace(/_/g, " ").replace(/\b\w/g, l => l.toUpperCase())}</span>
      <span className="text-xs font-mono tabular-nums text-foreground ml-4 text-right">{display}</span>
    </div>
  );
}

export default function PlatformDetailPage() {
  const { id } = useParams<{ id: string }>();

  const { data: platform, isLoading, error } = useQuery<PlatformDetail>({
    queryKey: ["/api/v1/platforms", id],
  });

  if (isLoading) {
    return (
      <div className="p-4 space-y-4 max-w-5xl mx-auto">
        <Skeleton className="h-8 w-48" />
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <Skeleton className="h-64" />
          <Skeleton className="h-64" />
        </div>
      </div>
    );
  }

  if (error || !platform) {
    return (
      <div className="flex flex-col items-center justify-center h-full gap-4 text-muted-foreground">
        <AlertTriangle className="w-12 h-12" />
        <p className="text-sm">Platform not found</p>
        <Link href="/">
          <Button variant="outline" size="sm">
            <ArrowLeft className="w-4 h-4 mr-1.5" />
            Back to Explorer
          </Button>
        </Link>
      </div>
    );
  }

  const CatIcon = CATEGORY_ICONS[platform.category_id] || Crosshair;
  const catCfg = categoryConfig[platform.category_id];
  const statusCfg = statusConfig[platform.status_id || ""];
  const specs = platform.specifications || {};
  const econ = platform.economics || {};

  return (
    <div className="p-4 space-y-4 max-w-5xl mx-auto">
      {/* Back + Header */}
      <div className="flex items-start gap-3">
        <Link href="/">
          <Button variant="ghost" size="icon" className="h-8 w-8 mt-0.5" data-testid="button-back">
            <ArrowLeft className="w-4 h-4" />
          </Button>
        </Link>
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap">
            <CatIcon className="w-5 h-5 flex-shrink-0" style={{ color: catCfg?.color }} />
            <h1 className="text-xl font-bold tracking-tight" data-testid="text-platform-name">
              {platform.common_name}
            </h1>
            {statusCfg && (
              <Badge variant="outline" className="text-[10px] px-1.5 py-0"
                style={{ borderColor: statusCfg.color, color: statusCfg.color }}
              >
                {statusCfg.label}
              </Badge>
            )}
          </div>
          <div className="flex items-center gap-3 mt-1 text-xs text-muted-foreground flex-wrap">
            {platform.official_designation && (
              <span className="font-mono">{platform.official_designation}</span>
            )}
            {platform.nato_reporting_name && (
              <span>NATO: {platform.nato_reporting_name}</span>
            )}
            <span>{platform.manufacturer}</span>
            <span>{countryFlag(platform.country_of_origin)} {platform.country_of_origin}</span>
            {platform.entered_service_year && (
              <span className="tabular-nums">Service: {platform.entered_service_year}</span>
            )}
          </div>
          {platform.description && (
            <p className="mt-2 text-sm text-muted-foreground max-w-3xl">{platform.description}</p>
          )}
        </div>
      </div>

      {/* Content grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        {/* Specifications */}
        {Object.keys(specs).length > 0 && (
          <Section title="Specifications" icon={Shield}>
            <div className="space-y-0">
              {Object.entries(specs)
                .filter(([k]) => !k.endsWith("_id") && k !== "platform_id" && !k.includes("created_at") && !k.includes("updated_at"))
                .map(([k, v]) => (
                  <SpecRow key={k} label={k} value={v} />
                ))}
            </div>
          </Section>
        )}

        {/* Economics */}
        {Object.keys(econ).length > 0 && (
          <Section title="Economics" icon={DollarSign}>
            <div className="space-y-0">
              {Object.entries(econ)
                .filter(([k]) => !k.endsWith("_id") && k !== "platform_id" && !k.includes("created_at") && !k.includes("updated_at"))
                .map(([k, v]) => {
                  let display = v;
                  if (typeof v === "number" && (k.includes("cost") || k.includes("price") || k.includes("budget"))) {
                    display = `$${v.toLocaleString()}`;
                  }
                  return <SpecRow key={k} label={k} value={display} />;
                })}
            </div>
          </Section>
        )}

        {/* Armaments */}
        {platform.armaments.length > 0 && (
          <Section title={`Armaments (${platform.armaments.length})`} icon={Swords}>
            <div className="space-y-2">
              {platform.armaments.map((a, i) => (
                <div key={i} className="p-2.5 rounded bg-background/60 border border-border/30">
                  <p className="text-xs font-semibold">
                    {a.weapon_name || a.armament_name || `Armament ${i + 1}`}
                  </p>
                  {a.weapon_type && <p className="text-[10px] text-muted-foreground">{a.weapon_type}</p>}
                  {a.quantity && <p className="text-[10px] text-muted-foreground">Qty: {a.quantity}</p>}
                  {a.description && <p className="text-[10px] text-muted-foreground mt-1">{a.description}</p>}
                </div>
              ))}
            </div>
          </Section>
        )}

        {/* Operators */}
        {platform.operators.length > 0 && (
          <Section title={`Operators (${platform.operators.length})`} icon={Globe}>
            <div className="flex flex-wrap gap-1.5">
              {platform.operators.map((op, i) => (
                <Badge key={i} variant="secondary" className="text-[10px]">
                  {op.country_code ? countryFlag(op.country_code) + ' ' : ''}{op.country_name || op.operator_name || op.country_code || `Operator ${i + 1}`}
                  {op.quantity && ` (${op.quantity})`}
                </Badge>
              ))}
            </div>
          </Section>
        )}

        {/* Conflicts */}
        {platform.conflicts.length > 0 && (
          <Section title={`Combat History (${platform.conflicts.length})`} icon={Swords}>
            <div className="space-y-1.5">
              {platform.conflicts.map((c, i) => (
                <div key={i} className="flex items-center justify-between py-1 border-b border-border/30 last:border-b-0">
                  <span className="text-xs">{c.conflict_name}</span>
                  {(c.start_year || c.end_year) && (
                    <span className="text-[10px] text-muted-foreground tabular-nums">
                      {c.start_year}{c.end_year ? `–${c.end_year}` : ""}
                    </span>
                  )}
                </div>
              ))}
            </div>
          </Section>
        )}

        {/* Sources */}
        {platform.sources.length > 0 && (
          <Section title={`Sources (${platform.sources.length})`} icon={BookOpen}>
            <div className="space-y-1.5">
              {platform.sources.map((s, i) => (
                <div key={i} className="text-xs">
                  <span className="text-muted-foreground">{s.source_name || s.source_type || "Source"}</span>
                  {s.url && (
                    <a
                      href={s.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="ml-1.5 inline-flex items-center gap-0.5 text-primary hover:underline"
                    >
                      Link <ExternalLink className="w-3 h-3" />
                    </a>
                  )}
                </div>
              ))}
            </div>
          </Section>
        )}
      </div>
    </div>
  );
}
