import { Link, useLocation } from "wouter";
import { PerplexityAttribution } from "@/components/PerplexityAttribution";
import {
  BarChart3, Search,
  GitCompare, Database, ChevronDown, Satellite
} from "lucide-react";
import { FighterJetIcon, TankIcon, WarshipIcon, MissileIcon, SoftwareIcon } from "@/components/MilitaryIcons";
import { useState } from "react";

const domainFilters = [
  { id: "air", label: "AIR", icon: FighterJetIcon, count: 53 },
  { id: "land", label: "LAND", icon: TankIcon, count: 68 },
  { id: "sea", label: "SEA", icon: WarshipIcon, count: 25 },
  { id: "munition", label: "MUNITION", icon: MissileIcon, count: 29 },
  { id: "software", label: "SOFTWARE", icon: SoftwareIcon, count: 8 },
];

const navItems = [
  { path: "/", label: "PLATFORM EXPLORER", icon: Search },
  { path: "/stats", label: "ANALYTICS", icon: BarChart3 },
  { path: "/compare", label: "COMPARE", icon: GitCompare },
];

// Shield + grid logo SVG
function Logo() {
  // Quadrant datum mark (assets/brand/logo-dark.svg): ring, cross, two filled quadrants.
  return (
    <svg width="22" height="22" viewBox="0 0 64 64" fill="none" role="img" aria-label="OMHDB">
      <circle cx="32" cy="32" r="26" stroke="hsl(210 15% 85%)" strokeWidth="4" />
      <path d="M32 32V6A26 26 0 0 0 6 32Z M32 32V58A26 26 0 0 0 58 32Z" fill="hsl(38 90% 58%)" transform="rotate(180 32 32)" />
      <path d="M32 6V58M6 32H58" stroke="hsl(210 15% 85%)" strokeWidth="3" />
    </svg>
  );
}

interface AppShellProps {
  children: React.ReactNode;
  rightPanel?: React.ReactNode;
}

export function AppShell({ children, rightPanel }: AppShellProps) {
  const [location] = useLocation();
  const [activeDomain, setActiveDomain] = useState<string | null>(null);

  return (
    <div className="flex h-full overflow-hidden bp-grid">
      {/* ─── LEFT PANE: Filter / Navigation ─── */}
      <aside className="w-52 flex-shrink-0 flex flex-col border-r border-[hsl(var(--bp-line-faint))] glass" style={{ background: 'rgba(10, 22, 40, 0.85)' }}>
        {/* Brand */}
        <div className="flex items-center gap-2 px-3 py-3 border-b border-[hsl(var(--bp-line-faint))]">
          <Logo />
          <div className="flex flex-col">
            <span className="text-[11px] font-semibold tracking-[0.15em] text-[hsl(var(--bp-text))]">OMHDB</span>
            <span className="text-[9px] font-mono tracking-[0.2em] text-[hsl(var(--bp-text-faint))]">v3.0 // INTEL</span>
          </div>
        </div>

        {/* Navigation */}
        <nav className="px-2 pt-3 space-y-0.5">
          <p className="label-caps px-2 pb-1.5">Navigation</p>
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = item.path === "/"
              ? location === "/" || location.startsWith("/platform")
              : location.startsWith(item.path);
            return (
              <Link key={item.path} href={item.path}>
                <span
                  data-testid={`nav-${item.label.toLowerCase().replace(/\s+/g, "-")}`}
                  className={`
                    flex items-center gap-2 px-2 py-1.5 rounded text-[11px] font-medium tracking-wide cursor-pointer
                    transition-all duration-100
                    ${isActive
                      ? "glass-active text-[hsl(var(--bp-accent-text))]"
                      : "text-[hsl(var(--bp-text-muted))] hover:text-[hsl(var(--bp-text))] glass-hover"
                    }
                  `}
                >
                  <Icon className="w-3.5 h-3.5 flex-shrink-0 opacity-60" />
                  {item.label}
                </span>
              </Link>
            );
          })}
        </nav>

        {/* Domain filters */}
        <div className="px-2 pt-4 space-y-0.5">
          <p className="label-caps px-2 pb-1.5">Domain</p>
          {domainFilters.map((d) => {
            const Icon = d.icon;
            const isActive = activeDomain === d.id;
            return (
              <Link key={d.id} href={`/?category=${d.id}`}>
                <span
                  onClick={() => setActiveDomain(isActive ? null : d.id)}
                  data-testid={`domain-${d.id}`}
                  className={`
                    flex items-center gap-2 px-2 py-1.5 rounded text-[11px] cursor-pointer
                    transition-all duration-100
                    ${isActive
                      ? "glass-active text-[hsl(var(--bp-accent-text))]"
                      : "text-[hsl(var(--bp-text-muted))] hover:text-[hsl(var(--bp-text))] glass-hover"
                    }
                  `}
                >
                  <Icon className="w-3.5 h-3.5 flex-shrink-0 opacity-50" />
                  <span className="flex-1 tracking-wide">{d.label}</span>
                  <span className="text-[9px] font-mono tabular-nums opacity-50">{d.count}</span>
                </span>
              </Link>
            );
          })}
        </div>

        {/* Spacer */}
        <div className="flex-1" />

        {/* Footer */}
        <div className="px-3 py-2.5 border-t border-[hsl(var(--bp-line-faint))] space-y-1.5">
          <div className="flex items-center gap-1.5 text-[9px] font-mono text-[hsl(var(--bp-text-faint))] tracking-wide">
            <Database className="w-3 h-3 opacity-40" />
            <span>183 PLATFORMS // US ORIGIN</span>
          </div>
          <PerplexityAttribution />
        </div>
      </aside>

      {/* ─── CENTER + RIGHT PANES ─── */}
      <div className="flex-1 flex min-w-0 overflow-hidden">
        {/* Center: primary content */}
        <div className="flex-1 min-w-0 overflow-hidden flex flex-col">
          {children}
        </div>

        {/* Right: detail pane (conditional) */}
        {rightPanel && (
          <aside className="w-[380px] flex-shrink-0 border-l border-[hsl(var(--bp-line-faint))] overflow-y-auto overscroll-contain glass"
            style={{ background: 'rgba(10, 22, 40, 0.7)' }}
          >
            {rightPanel}
          </aside>
        )}
      </div>
    </div>
  );
}
