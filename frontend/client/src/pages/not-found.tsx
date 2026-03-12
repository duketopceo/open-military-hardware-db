import { Link } from "wouter";
import { AlertCircle, ArrowLeft } from "lucide-react";

export default function NotFound() {
  return (
    <div className="h-full w-full flex items-center justify-center bp-grid">
      <div className="glass rounded p-8 max-w-sm text-center space-y-4 animate-in">
        <AlertCircle className="w-8 h-8 text-[hsl(var(--bp-accent))] mx-auto opacity-60" />
        <div>
          <h1 className="text-sm font-semibold tracking-[0.15em] text-[hsl(var(--bp-text))] mb-1">
            SIGNAL NOT FOUND
          </h1>
          <p className="text-[11px] text-[hsl(var(--bp-text-muted))] font-mono">
            404 // REQUESTED RESOURCE UNAVAILABLE
          </p>
        </div>
        <Link href="/">
          <span className="inline-flex items-center gap-1.5 text-[10px] font-mono text-[hsl(var(--bp-accent-text))] hover:underline cursor-pointer tracking-wide">
            <ArrowLeft className="w-3 h-3" />
            RETURN TO EXPLORER
          </span>
        </Link>
      </div>
    </div>
  );
}
