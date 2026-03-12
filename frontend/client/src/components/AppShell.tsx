import { Link, useLocation } from "wouter";
import { useTheme } from "./ThemeProvider";
import {
  Plane, Truck, Ship, Crosshair, BarChart3, Search,
  GitCompare, Sun, Moon, Database, Menu, X, ChevronRight
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { useState } from "react";
import { PerplexityAttribution } from "@/components/PerplexityAttribution";

const navItems = [
  { path: "/", label: "Explorer", icon: Search },
  { path: "/stats", label: "Dashboard", icon: BarChart3 },
  { path: "/compare", label: "Compare", icon: GitCompare },
];

const categoryFilters = [
  { id: "air", label: "Air", icon: Plane },
  { id: "land", label: "Land", icon: Truck },
  { id: "sea", label: "Sea", icon: Ship },
  { id: "munition", label: "Munitions", icon: Crosshair },
];

// Inline SVG logo — shield with database grid
function Logo({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 32 32"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      aria-label="Open Military Hardware DB"
    >
      <path
        d="M16 2L4 8v8c0 7.18 5.12 13.88 12 16 6.88-2.12 12-8.82 12-16V8L16 2z"
        stroke="currentColor"
        strokeWidth="1.5"
        fill="none"
      />
      <rect x="10" y="10" width="12" height="3" rx="0.5" stroke="currentColor" strokeWidth="1" fill="none" />
      <rect x="10" y="14.5" width="12" height="3" rx="0.5" stroke="currentColor" strokeWidth="1" fill="none" />
      <rect x="10" y="19" width="12" height="3" rx="0.5" stroke="currentColor" strokeWidth="1" fill="none" />
      <circle cx="13" cy="11.5" r="0.75" fill="currentColor" />
      <circle cx="13" cy="16" r="0.75" fill="currentColor" />
      <circle cx="13" cy="20.5" r="0.75" fill="currentColor" />
    </svg>
  );
}

export function AppShell({ children }: { children: React.ReactNode }) {
  const [location] = useLocation();
  const { theme, toggleTheme } = useTheme();
  const [sidebarOpen, setSidebarOpen] = useState(true);

  return (
    <div className="flex h-full overflow-hidden bg-background text-foreground">
      {/* Sidebar */}
      <aside
        className={`
          flex flex-col border-r border-sidebar-border bg-sidebar
          transition-all duration-200 ease-out
          ${sidebarOpen ? "w-56" : "w-0 overflow-hidden border-r-0"}
        `}
      >
        {/* Logo */}
        <div className="flex items-center gap-2.5 px-4 py-4 border-b border-sidebar-border">
          <Logo className="w-6 h-6 text-primary flex-shrink-0" />
          <div className="flex flex-col min-w-0">
            <span className="text-sm font-semibold tracking-tight truncate">OMHDB</span>
            <span className="text-[10px] font-mono text-muted-foreground tracking-wider">v2.1 BETA</span>
          </div>
        </div>

        {/* Nav */}
        <nav className="flex-1 px-2 py-3 space-y-0.5 overflow-y-auto overscroll-contain">
          <p className="px-3 py-1.5 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
            Navigation
          </p>
          {navItems.map((item) => {
            const Icon = item.icon;
            const active = item.path === "/"
              ? location === "/" || location.startsWith("/platform")
              : location.startsWith(item.path);
            return (
              <Link key={item.path} href={item.path}>
                <span
                  data-testid={`nav-${item.label.toLowerCase()}`}
                  className={`
                    flex items-center gap-2.5 px-3 py-2 rounded-md text-sm cursor-pointer
                    transition-colors duration-100
                    ${active
                      ? "bg-sidebar-accent text-sidebar-foreground font-medium"
                      : "text-muted-foreground hover:bg-sidebar-accent/50 hover:text-sidebar-foreground"
                    }
                  `}
                >
                  <Icon className="w-4 h-4 flex-shrink-0" />
                  {item.label}
                </span>
              </Link>
            );
          })}

          <p className="px-3 pt-4 pb-1.5 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
            Categories
          </p>
          {categoryFilters.map((cat) => {
            const Icon = cat.icon;
            const active = location === `/?category=${cat.id}`;
            return (
              <Link key={cat.id} href={`/?category=${cat.id}`}>
                <span
                  data-testid={`nav-cat-${cat.id}`}
                  className={`
                    flex items-center gap-2.5 px-3 py-2 rounded-md text-sm cursor-pointer
                    transition-colors duration-100
                    ${active
                      ? "bg-sidebar-accent text-sidebar-foreground font-medium"
                      : "text-muted-foreground hover:bg-sidebar-accent/50 hover:text-sidebar-foreground"
                    }
                  `}
                >
                  <Icon className="w-4 h-4 flex-shrink-0" />
                  {cat.label}
                </span>
              </Link>
            );
          })}
        </nav>

        {/* Footer */}
        <div className="px-3 py-3 border-t border-sidebar-border space-y-2">
          <div className="flex items-center gap-1.5 text-[10px] font-mono text-muted-foreground">
            <Database className="w-3 h-3" />
            <span>165 platforms · US origin</span>
          </div>
          <PerplexityAttribution />
        </div>
      </aside>

      {/* Main content */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        {/* Header */}
        <header className="flex items-center gap-3 px-4 py-2.5 border-b border-border bg-background/80 backdrop-blur-sm z-10">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => setSidebarOpen(!sidebarOpen)}
            className="h-8 w-8"
            data-testid="toggle-sidebar"
          >
            {sidebarOpen ? <X className="w-4 h-4" /> : <Menu className="w-4 h-4" />}
          </Button>

          {/* Breadcrumb */}
          <div className="flex items-center gap-1 text-sm text-muted-foreground">
            <span className="font-medium text-foreground">Open Military Hardware DB</span>
            <ChevronRight className="w-3.5 h-3.5" />
            <span>
              {location === "/" && "Platform Explorer"}
              {location === "/stats" && "Statistics Dashboard"}
              {location.startsWith("/compare") && "Compare"}
              {location.startsWith("/platform/") && "Platform Detail"}
            </span>
          </div>

          <div className="flex-1" />

          <Button
            variant="ghost"
            size="icon"
            onClick={toggleTheme}
            className="h-8 w-8"
            data-testid="toggle-theme"
          >
            {theme === "dark" ? <Sun className="w-4 h-4" /> : <Moon className="w-4 h-4" />}
          </Button>
        </header>

        {/* Content */}
        <main className="flex-1 overflow-y-auto overscroll-contain">
          {children}
        </main>
      </div>
    </div>
  );
}
