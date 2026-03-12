/**
 * Custom military silhouette icons for domain categories.
 * Designed to work at 12–16px inline with the blueprint aesthetic.
 * Props match Lucide icon interface for drop-in replacement.
 */

import type { SVGProps } from "react";

type IconProps = SVGProps<SVGSVGElement>;

/** Fighter jet silhouette — AIR domain */
export function FighterJetIcon(props: IconProps) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      {/* Fuselage */}
      <path d="M2 12.5 L8 11.5 L11 10 L16 9 L22 10.5 L21 12 L16 11.5 L11 12.5 L8 13 Z" />
      {/* Main wings */}
      <path d="M10 10 L7 4 L12 9" />
      <path d="M10 13 L7 19 L12 13.5" />
      {/* Tail fins */}
      <path d="M3 12 L2 8.5" />
      <path d="M3 13 L2 16.5" />
      {/* Canopy */}
      <path d="M16 10 L17.5 9.5 L18.5 10.5" />
    </svg>
  );
}

/** Tank / APC silhouette — LAND domain */
export function TankIcon(props: IconProps) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      {/* Hull */}
      <path d="M3 14 L5 11 L18 11 L20 14" />
      {/* Turret */}
      <rect x="8" y="8" width="7" height="3" rx="0.5" />
      {/* Gun barrel */}
      <line x1="15" y1="9.5" x2="22" y2="8" />
      {/* Tracks */}
      <path d="M3 14 L3 16 C3 17.1 3.9 18 5 18 L19 18 C20.1 18 21 17.1 21 16 L21 14" />
      {/* Track wheels */}
      <circle cx="6" cy="16" r="1" />
      <circle cx="10" cy="16" r="1" />
      <circle cx="14" cy="16" r="1" />
      <circle cx="18" cy="16" r="1" />
    </svg>
  );
}

/** Warship silhouette — SEA domain */
export function WarshipIcon(props: IconProps) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      {/* Hull / waterline */}
      <path d="M2 16 L4 13 L20 13 L22 16 Z" />
      {/* Superstructure */}
      <path d="M7 13 L7 10 L17 10 L17 13" />
      {/* Bridge */}
      <rect x="9" y="7.5" width="5" height="2.5" rx="0.3" />
      {/* Mast */}
      <line x1="11.5" y1="7.5" x2="11.5" y2="4" />
      {/* Antenna array */}
      <line x1="10" y1="5" x2="13" y2="5" />
      {/* Bow detail */}
      <line x1="18" y1="12" x2="20" y2="11" />
      {/* Waterline */}
      <path d="M1 17.5 C3 16.5 5 18 7 17 C9 16 11 18 13 17 C15 16 17 18 19 17 C21 16 23 17.5 23 17.5" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

/** Missile silhouette — MUNITION domain */
export function MissileIcon(props: IconProps) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      {/* Missile body */}
      <path d="M22 5 L20 4 L6 10 L4 10.5 L3 12 L4 13.5 L6 14 L20 20 L22 19" />
      {/* Nosecone */}
      <path d="M22 5 L23 12 L22 19" />
      {/* Fins */}
      <path d="M6 10 L4 7" />
      <path d="M6 14 L4 17" />
      {/* Body line */}
      <line x1="8" y1="10.5" x2="8" y2="13.5" strokeWidth="1" opacity="0.5" />
      {/* Exhaust */}
      <path d="M3 12 L1 12" strokeWidth="1" opacity="0.4" strokeDasharray="1 1" />
    </svg>
  );
}

/** Software/C2 circuit board icon — SOFTWARE domain */
export function SoftwareIcon(props: IconProps) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      {/* Terminal/screen */}
      <rect x="3" y="4" width="18" height="13" rx="1" />
      {/* Screen line */}
      <line x1="3" y1="14" x2="21" y2="14" strokeWidth="1" opacity="0.4" />
      {/* Stand */}
      <line x1="12" y1="17" x2="12" y2="20" />
      <line x1="8" y1="20" x2="16" y2="20" />
      {/* Code/data lines on screen */}
      <line x1="6" y1="7.5" x2="10" y2="7.5" strokeWidth="1" opacity="0.6" />
      <line x1="6" y1="10" x2="14" y2="10" strokeWidth="1" opacity="0.6" />
      <circle cx="17" cy="8.5" r="1.5" strokeWidth="1" opacity="0.6" />
    </svg>
  );
}

/** Map of category_id → icon component for easy lookup */
export const MILITARY_ICONS: Record<string, React.FC<IconProps>> = {
  air: FighterJetIcon,
  land: TankIcon,
  sea: WarshipIcon,
  munition: MissileIcon,
  software: SoftwareIcon,
};
