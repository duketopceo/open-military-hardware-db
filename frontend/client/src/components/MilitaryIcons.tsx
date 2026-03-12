/**
 * Custom military silhouette icons for domain and subcategory types.
 * Designed to work at 12–16px inline with the blueprint aesthetic.
 * Props match Lucide icon interface for drop-in replacement.
 */

import type { SVGProps } from "react";

type IconProps = SVGProps<SVGSVGElement>;

const defaultSvgProps = {
  viewBox: "0 0 24 24",
  fill: "none",
  stroke: "currentColor",
  strokeWidth: 1.5,
  strokeLinecap: "round" as const,
  strokeLinejoin: "round" as const,
};

// ─── DOMAIN ICONS (original 5) ───

/** Fighter jet silhouette — AIR domain */
export function FighterJetIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M2 12.5 L8 11.5 L11 10 L16 9 L22 10.5 L21 12 L16 11.5 L11 12.5 L8 13 Z" />
      <path d="M10 10 L7 4 L12 9" />
      <path d="M10 13 L7 19 L12 13.5" />
      <path d="M3 12 L2 8.5" />
      <path d="M3 13 L2 16.5" />
      <path d="M16 10 L17.5 9.5 L18.5 10.5" />
    </svg>
  );
}

/** Tank / APC silhouette — LAND domain */
export function TankIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M3 14 L5 11 L18 11 L20 14" />
      <rect x="8" y="8" width="7" height="3" rx="0.5" />
      <line x1="15" y1="9.5" x2="22" y2="8" />
      <path d="M3 14 L3 16 C3 17.1 3.9 18 5 18 L19 18 C20.1 18 21 17.1 21 16 L21 14" />
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
    <svg {...defaultSvgProps} {...props}>
      <path d="M2 16 L4 13 L20 13 L22 16 Z" />
      <path d="M7 13 L7 10 L17 10 L17 13" />
      <rect x="9" y="7.5" width="5" height="2.5" rx="0.3" />
      <line x1="11.5" y1="7.5" x2="11.5" y2="4" />
      <line x1="10" y1="5" x2="13" y2="5" />
      <line x1="18" y1="12" x2="20" y2="11" />
      <path d="M1 17.5 C3 16.5 5 18 7 17 C9 16 11 18 13 17 C15 16 17 18 19 17 C21 16 23 17.5 23 17.5" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

/** Missile silhouette — MUNITION domain */
export function MissileIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M22 5 L20 4 L6 10 L4 10.5 L3 12 L4 13.5 L6 14 L20 20 L22 19" />
      <path d="M22 5 L23 12 L22 19" />
      <path d="M6 10 L4 7" />
      <path d="M6 14 L4 17" />
      <line x1="8" y1="10.5" x2="8" y2="13.5" strokeWidth="1" opacity="0.5" />
      <path d="M3 12 L1 12" strokeWidth="1" opacity="0.4" strokeDasharray="1 1" />
    </svg>
  );
}

/** Software/C2 circuit board icon — SOFTWARE domain */
export function SoftwareIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <rect x="3" y="4" width="18" height="13" rx="1" />
      <line x1="3" y1="14" x2="21" y2="14" strokeWidth="1" opacity="0.4" />
      <line x1="12" y1="17" x2="12" y2="20" />
      <line x1="8" y1="20" x2="16" y2="20" />
      <line x1="6" y1="7.5" x2="10" y2="7.5" strokeWidth="1" opacity="0.6" />
      <line x1="6" y1="10" x2="14" y2="10" strokeWidth="1" opacity="0.6" />
      <circle cx="17" cy="8.5" r="1.5" strokeWidth="1" opacity="0.6" />
    </svg>
  );
}

// ─── AIR SUBCATEGORY ICONS ───

/** Bomber — large swept-wing aircraft with bomb bay */
export function BomberIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M2 12 L6 11 L10 10 L18 9 L22 10 L21 12 L18 12 L10 13 L6 13 Z" />
      <path d="M8 10 L4 5 L13 9.5" />
      <path d="M8 13 L4 18 L13 13" />
      <path d="M3 11.5 L2 9" />
      <path d="M3 12.5 L2 15" />
      <line x1="14" y1="13" x2="14" y2="15" strokeWidth="1" opacity="0.5" />
      <line x1="16" y1="12.5" x2="16" y2="14.5" strokeWidth="1" opacity="0.5" />
    </svg>
  );
}

/** Attack helicopter — main rotor + tail boom */
export function AttackHelicopterIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <line x1="4" y1="5" x2="20" y2="5" strokeWidth="1" opacity="0.5" />
      <line x1="12" y1="5" x2="12" y2="8" />
      <path d="M8 8 L10 10 L16 10 L17 8" />
      <path d="M10 10 L8 14 L14 14 L16 10" />
      <path d="M8 14 L4 15 L3 14" />
      <line x1="14" y1="14" x2="20" y2="13" />
      <line x1="20" y1="11" x2="20" y2="15" strokeWidth="1" />
      <line x1="8" y1="16" x2="14" y2="16" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

/** Transport helicopter — large cabin profile */
export function TransportHelicopterIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <line x1="5" y1="5" x2="19" y2="5" strokeWidth="1" opacity="0.5" />
      <line x1="12" y1="5" x2="12" y2="7" />
      <path d="M6 7 L7 10 L17 10 L18 7 Z" />
      <path d="M7 10 L6 15 L18 15 L17 10" />
      <line x1="6" y1="15" x2="4" y2="17" />
      <line x1="18" y1="15" x2="20" y2="17" />
      <path d="M18 12 L21 11" strokeWidth="1" opacity="0.5" />
      <line x1="21" y1="10" x2="21" y2="13" strokeWidth="1" />
    </svg>
  );
}

/** Tiltrotor — V-22 style with two rotors */
export function TiltrotorIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M8 11 L10 9 L14 9 L16 11 L16 14 L14 15 L10 15 L8 14 Z" />
      <circle cx="5" cy="8" r="3" strokeWidth="1" opacity="0.5" />
      <circle cx="19" cy="8" r="3" strokeWidth="1" opacity="0.5" />
      <line x1="8" y1="10" x2="5" y2="8" />
      <line x1="16" y1="10" x2="19" y2="8" />
      <line x1="10" y1="15" x2="9" y2="18" strokeWidth="1" />
      <line x1="14" y1="15" x2="15" y2="18" strokeWidth="1" />
    </svg>
  );
}

/** UAV / drone — small flying wing */
export function UAVIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M4 12 L8 10 L12 9 L16 10 L20 12 L16 13 L12 12.5 L8 13 Z" />
      <path d="M10 10 L8 6 L13 9.5" />
      <path d="M10 13 L8 17 L13 12.5" />
      <circle cx="14" cy="11" r="1" strokeWidth="1" opacity="0.5" />
      <line x1="20" y1="12" x2="22" y2="12" strokeWidth="1" opacity="0.4" strokeDasharray="1 1" />
    </svg>
  );
}

/** Surveillance / AWACS — plane with radome */
export function SurveillanceIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M3 13 L7 12 L17 11 L21 12 L20 13.5 L17 13 L7 14 Z" />
      <path d="M9 12 L7 7 L13 11" />
      <path d="M9 14 L7 18 L13 13.5" />
      <ellipse cx="14" cy="9" rx="4" ry="1.5" strokeWidth="1" opacity="0.6" />
      <line x1="14" y1="10.5" x2="14" y2="11" strokeWidth="1" opacity="0.5" />
    </svg>
  );
}

/** Tanker — aircraft with refueling boom */
export function TankerIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M3 12 L7 11 L17 10 L21 11 L20 12.5 L17 12 L7 13 Z" />
      <path d="M9 11 L7 6 L13 10.5" />
      <path d="M9 13 L7 18 L13 12.5" />
      <line x1="3" y1="12.5" x2="1" y2="15" strokeWidth="1" opacity="0.5" />
      <line x1="1" y1="15" x2="1" y2="17" strokeWidth="1" opacity="0.4" strokeDasharray="1 1" />
    </svg>
  );
}

/** Transport aircraft — large fuselage, high wings */
export function TransportAircraftIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M2 12 L6 11 L18 10 L22 11 L21 12.5 L18 12 L6 13 Z" />
      <path d="M8 11 L6 5 L12 10.5" />
      <path d="M8 13 L6 19 L12 12.5" />
      <path d="M3 11.5 L2 9" />
      <path d="M3 12.5 L2 15" />
      <rect x="16" y="10" width="3" height="2.5" rx="0.3" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

// ─── LAND SUBCATEGORY ICONS ───

/** IFV (Infantry Fighting Vehicle) — lighter than tank, angled hull */
export function IFVIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M3 13 L5 10 L19 10 L21 13" />
      <rect x="10" y="7.5" width="5" height="2.5" rx="0.3" />
      <line x1="15" y1="8.5" x2="20" y2="7" />
      <path d="M3 13 L3 15.5 C3 16.6 3.9 17.5 5 17.5 L19 17.5 C20.1 17.5 21 16.6 21 15.5 L21 13" />
      <circle cx="6" cy="15.5" r="0.8" />
      <circle cx="10" cy="15.5" r="0.8" />
      <circle cx="14" cy="15.5" r="0.8" />
      <circle cx="18" cy="15.5" r="0.8" />
    </svg>
  );
}

/** APC (Armored Personnel Carrier) — boxy hull, no turret */
export function APCIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M3 13 L4 9 L20 9 L21 13" />
      <path d="M3 13 L3 15.5 C3 16.6 3.9 17.5 5 17.5 L19 17.5 C20.1 17.5 21 16.6 21 15.5 L21 13" />
      <circle cx="6" cy="15.5" r="0.8" />
      <circle cx="10" cy="15.5" r="0.8" />
      <circle cx="14" cy="15.5" r="0.8" />
      <circle cx="18" cy="15.5" r="0.8" />
      <line x1="6" y1="9" x2="6" y2="11" strokeWidth="1" opacity="0.4" />
      <line x1="10" y1="9" x2="10" y2="11" strokeWidth="1" opacity="0.4" />
      <line x1="14" y1="9" x2="14" y2="11" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

/** Artillery — self-propelled gun with long barrel */
export function ArtilleryIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M4 14 L6 11 L17 11 L19 14" />
      <rect x="9" y="8" width="5" height="3" rx="0.3" />
      <line x1="14" y1="9" x2="23" y2="5" />
      <path d="M4 14 L4 16 C4 17.1 4.9 18 6 18 L17 18 C18.1 18 19 17.1 19 16 L19 14" />
      <circle cx="7" cy="16" r="0.8" />
      <circle cx="11" cy="16" r="0.8" />
      <circle cx="16" cy="16" r="0.8" />
    </svg>
  );
}

/** Air defense — vehicle with radar dish / SAM launcher */
export function AirDefenseIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M4 15 L6 12 L18 12 L20 15" />
      <path d="M4 15 L4 17 C4 17.6 4.4 18 5 18 L19 18 C19.6 18 20 17.6 20 17 L20 15" />
      <circle cx="8" cy="17" r="0.7" />
      <circle cx="12" cy="17" r="0.7" />
      <circle cx="16" cy="17" r="0.7" />
      <line x1="10" y1="12" x2="8" y2="6" />
      <line x1="12" y1="12" x2="12" y2="6" />
      <line x1="14" y1="12" x2="16" y2="6" />
      <path d="M7 6 L17 6" strokeWidth="1" opacity="0.5" />
    </svg>
  );
}

/** Engineering vehicle — dozer blade + crane */
export function EngineeringIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M5 14 L7 11 L18 11 L20 14" />
      <path d="M5 14 L5 16 C5 17.1 5.9 18 7 18 L18 18 C19.1 18 20 17.1 20 16 L20 14" />
      <circle cx="8" cy="16" r="0.8" />
      <circle cx="12" cy="16" r="0.8" />
      <circle cx="17" cy="16" r="0.8" />
      <path d="M5 12 L2 12 L2 9 L5 11" />
      <path d="M16 11 L17 7 L19 7" strokeWidth="1" opacity="0.6" />
    </svg>
  );
}

/** Logistics vehicle — truck silhouette */
export function LogisticsIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <rect x="3" y="9" width="13" height="7" rx="0.5" />
      <path d="M16 11 L20 11 L22 14 L22 16 L16 16" />
      <circle cx="7" cy="18" r="1.5" />
      <circle cx="19" cy="18" r="1.5" />
      <line x1="8.5" y1="18" x2="17.5" y2="18" strokeWidth="1" opacity="0.3" />
    </svg>
  );
}

/** Counter-UAS system — radar + jammer dish */
export function CounterUASIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <rect x="6" y="13" width="12" height="5" rx="0.5" />
      <circle cx="6" cy="18" r="1" />
      <circle cx="18" cy="18" r="1" />
      <path d="M12 13 L12 9" />
      <path d="M8 9 L12 7 L16 9" />
      <path d="M6 7 L12 4 L18 7" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

// ─── SEA SUBCATEGORY ICONS ───

/** Aircraft carrier — flat deck with island */
export function CarrierIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M1 15 L3 12 L21 12 L23 15 Z" />
      <line x1="3" y1="12" x2="22" y2="12" />
      <rect x="16" y="8.5" width="3" height="3.5" rx="0.3" />
      <line x1="17.5" y1="8.5" x2="17.5" y2="6" />
      <line x1="16" y1="7" x2="19" y2="7" strokeWidth="1" opacity="0.5" />
      <line x1="5" y1="11.5" x2="8" y2="11.5" strokeWidth="1" opacity="0.4" />
      <line x1="10" y1="11.5" x2="13" y2="11.5" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

/** Submarine — cigar hull with sail */
export function SubmarineIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M2 13 C2 10 5 8 12 8 C19 8 22 10 22 13 C22 16 19 18 12 18 C5 18 2 16 2 13 Z" />
      <rect x="10" y="5.5" width="4" height="3" rx="0.5" />
      <line x1="12" y1="5.5" x2="12" y2="4" />
      <line x1="11" y1="4.5" x2="13" y2="4.5" strokeWidth="1" opacity="0.5" />
      <line x1="5" y1="13" x2="7" y2="13" strokeWidth="1" opacity="0.4" />
      <path d="M19 11 L22 10" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

/** Destroyer — sleek warship profile */
export function DestroyerIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M1 16 L3 13 L21 13 L23 16 Z" />
      <path d="M6 13 L6 10.5 L18 10.5 L18 13" />
      <rect x="8" y="8" width="4" height="2.5" rx="0.3" />
      <line x1="10" y1="8" x2="10" y2="5.5" />
      <line x1="9" y1="6.5" x2="11" y2="6.5" strokeWidth="1" opacity="0.5" />
      <line x1="14" y1="10.5" x2="14" y2="8" />
      <line x1="19" y1="12" x2="21" y2="11" />
    </svg>
  );
}

/** Cruiser — heavy warship with multiple systems */
export function CruiserIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M1 16 L3 12 L21 12 L23 16 Z" />
      <path d="M5 12 L5 9 L19 9 L19 12" />
      <rect x="7" y="6.5" width="3.5" height="2.5" rx="0.3" />
      <rect x="13" y="6.5" width="3.5" height="2.5" rx="0.3" />
      <line x1="8.5" y1="6.5" x2="8.5" y2="4.5" />
      <line x1="15" y1="6.5" x2="15" y2="5" />
      <line x1="20" y1="11" x2="22" y2="10" />
    </svg>
  );
}

/** Littoral combat ship — trimaran / fast hull */
export function LittoralIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M2 16 L5 12 L19 12 L22 16 Z" />
      <path d="M8 12 L9 9 L15 9 L16 12" />
      <line x1="12" y1="9" x2="12" y2="6" />
      <line x1="10.5" y1="7" x2="13.5" y2="7" strokeWidth="1" opacity="0.5" />
      <path d="M3 17 C5 16 7 17.5 9 16.5" strokeWidth="1" opacity="0.3" />
    </svg>
  );
}

/** UUV — unmanned underwater vehicle */
export function UUVIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M4 12 C4 10 7 8 12 8 C17 8 20 10 20 12 C20 14 17 16 12 16 C7 16 4 14 4 12 Z" />
      <circle cx="17" cy="12" r="1.5" strokeWidth="1" opacity="0.5" />
      <line x1="7" y1="12" x2="9" y2="12" strokeWidth="1" opacity="0.4" />
      <path d="M20 12 L22 11" strokeWidth="1" opacity="0.4" />
      <path d="M20 12 L22 13" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

/** Patrol boat — small fast vessel */
export function PatrolIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M3 16 L5 13 L19 13 L21 16 Z" />
      <path d="M8 13 L9 10 L15 10 L16 13" />
      <line x1="12" y1="10" x2="12" y2="7" />
      <line x1="16" y1="12" x2="18" y2="11" />
    </svg>
  );
}

// ─── MUNITION SUBCATEGORY ICONS ───

/** AAM — air-to-air missile with small fins */
export function AAMIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M2 12 L4 11 L18 10 L22 11 L22 13 L18 14 L4 13 Z" />
      <path d="M4 11 L3 9" />
      <path d="M4 13 L3 15" />
      <path d="M18 10 L17 8.5" />
      <path d="M18 14 L17 15.5" />
      <circle cx="20" cy="12" r="0.5" strokeWidth="1" opacity="0.5" />
    </svg>
  );
}

/** AGM — air-to-ground missile with guidance seeker */
export function AGMIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M2 12 L4 10.5 L16 9.5 L20 10.5 L20 13.5 L16 14.5 L4 13.5 Z" />
      <path d="M20 10.5 L22 11 L22 13 L20 13.5" />
      <path d="M4 10.5 L3 8.5" />
      <path d="M4 13.5 L3 15.5" />
      <line x1="10" y1="10" x2="10" y2="14" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

/** Cruise missile — long body with wings */
export function CruiseMissileIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M1 12 L3 11 L19 10 L22 11.5 L22 12.5 L19 14 L3 13 Z" />
      <path d="M22 11.5 L23 12 L22 12.5" />
      <path d="M10 10.5 L8 7 L13 10" />
      <path d="M10 13.5 L8 17 L13 14" />
      <path d="M3 11.5 L2 10" />
      <path d="M3 12.5 L2 14" />
    </svg>
  );
}

/** Anti-tank missile — compact with launch tube shape */
export function AntiTankIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <rect x="4" y="10" width="14" height="4" rx="2" />
      <path d="M18 10.5 L21 11 L21 13 L18 13.5" />
      <path d="M4 11 L2 10" />
      <path d="M4 13 L2 14" />
      <line x1="8" y1="10" x2="8" y2="14" strokeWidth="1" opacity="0.4" />
      <path d="M2 12 L1 12" strokeWidth="1" opacity="0.4" strokeDasharray="1 1" />
    </svg>
  );
}

/** Bomb — teardrop shape with fins */
export function BombIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M12 3 L15 8 L15 16 C15 18.2 13.7 20 12 20 C10.3 20 9 18.2 9 16 L9 8 Z" />
      <path d="M9 7 L7 5" />
      <path d="M15 7 L17 5" />
      <line x1="9" y1="4" x2="15" y2="4" strokeWidth="1" opacity="0.4" />
      <line x1="10" y1="14" x2="14" y2="14" strokeWidth="1" opacity="0.3" />
    </svg>
  );
}

/** Rocket — unguided with exhaust plume */
export function RocketIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M12 2 L14 7 L14 16 L12 18 L10 16 L10 7 Z" />
      <path d="M10 14 L7 17" />
      <path d="M14 14 L17 17" />
      <path d="M12 18 L11 21" strokeWidth="1" opacity="0.4" strokeDasharray="1 1" />
      <path d="M12 18 L13 21" strokeWidth="1" opacity="0.4" strokeDasharray="1 1" />
      <line x1="10.5" y1="10" x2="13.5" y2="10" strokeWidth="1" opacity="0.3" />
    </svg>
  );
}

/** Loitering munition — small drone with warhead */
export function LoiteringMunitionIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <path d="M6 12 L9 10 L12 9.5 L15 10 L18 12 L15 13 L12 12.5 L9 13 Z" />
      <path d="M10 10 L9 7 L13 9.5" />
      <path d="M10 13 L9 16 L13 12.5" />
      <circle cx="16" cy="11.5" r="1" strokeWidth="1" opacity="0.5" />
      <path d="M18 12 L21 12" strokeWidth="1" opacity="0.4" />
      <path d="M4 12 L6 12" strokeWidth="1" opacity="0.4" strokeDasharray="1 1" />
    </svg>
  );
}

// ─── SOFTWARE SUBCATEGORY ICONS ───

/** C2 Platform — command screens with network nodes */
export function C2PlatformIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <rect x="4" y="4" width="16" height="11" rx="1" />
      <line x1="12" y1="15" x2="12" y2="18" />
      <line x1="8" y1="18" x2="16" y2="18" />
      <circle cx="8" cy="9" r="2" strokeWidth="1" opacity="0.6" />
      <circle cx="16" cy="9" r="2" strokeWidth="1" opacity="0.6" />
      <line x1="10" y1="9" x2="14" y2="9" strokeWidth="1" opacity="0.4" />
      <circle cx="12" cy="12" r="0.8" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

/** Analytics — chart/graph visualization */
export function AnalyticsIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <rect x="3" y="4" width="18" height="13" rx="1" />
      <line x1="12" y1="17" x2="12" y2="20" />
      <line x1="8" y1="20" x2="16" y2="20" />
      <polyline points="6,14 9,10 12,12 15,7 18,9" strokeWidth="1" opacity="0.6" />
      <line x1="6" y1="14" x2="6" y2="7" strokeWidth="1" opacity="0.3" />
      <line x1="6" y1="14" x2="18" y2="14" strokeWidth="1" opacity="0.3" />
    </svg>
  );
}

/** Autonomy — AI/neural network icon */
export function AutonomyIcon(props: IconProps) {
  return (
    <svg {...defaultSvgProps} {...props}>
      <circle cx="12" cy="6" r="2" strokeWidth="1" />
      <circle cx="6" cy="12" r="2" strokeWidth="1" />
      <circle cx="18" cy="12" r="2" strokeWidth="1" />
      <circle cx="8" cy="18" r="2" strokeWidth="1" />
      <circle cx="16" cy="18" r="2" strokeWidth="1" />
      <line x1="12" y1="8" x2="7" y2="11" strokeWidth="1" opacity="0.4" />
      <line x1="12" y1="8" x2="17" y2="11" strokeWidth="1" opacity="0.4" />
      <line x1="7" y1="14" x2="9" y2="17" strokeWidth="1" opacity="0.4" />
      <line x1="17" y1="14" x2="15" y2="17" strokeWidth="1" opacity="0.4" />
    </svg>
  );
}

// ─── ICON MAPS ───

/** Map of category_id → icon component for easy lookup */
export const MILITARY_ICONS: Record<string, React.FC<IconProps>> = {
  air: FighterJetIcon,
  land: TankIcon,
  sea: WarshipIcon,
  munition: MissileIcon,
  software: SoftwareIcon,
};

/** Map of subcategory_id → icon component for detailed lookup */
export const SUBCATEGORY_ICONS: Record<string, React.FC<IconProps>> = {
  // Air
  fighter: FighterJetIcon,
  bomber: BomberIcon,
  attack_helicopter: AttackHelicopterIcon,
  transport_helicopter: TransportHelicopterIcon,
  tiltrotor: TiltrotorIcon,
  uav: UAVIcon,
  surveillance: SurveillanceIcon,
  tanker: TankerIcon,
  transport: TransportAircraftIcon,
  // Land
  tank: TankIcon,
  ifv: IFVIcon,
  apc: APCIcon,
  artillery: ArtilleryIcon,
  air_defense: AirDefenseIcon,
  engineering: EngineeringIcon,
  logistics: LogisticsIcon,
  counter_uas: CounterUASIcon,
  // Sea
  carrier: CarrierIcon,
  submarine: SubmarineIcon,
  destroyer: DestroyerIcon,
  cruiser: CruiserIcon,
  littoral: LittoralIcon,
  uuv: UUVIcon,
  patrol: PatrolIcon,
  // Munition
  aam: AAMIcon,
  agm: AGMIcon,
  cruise_missile: CruiseMissileIcon,
  anti_tank: AntiTankIcon,
  bomb: BombIcon,
  rocket: RocketIcon,
  loitering_munition: LoiteringMunitionIcon,
  // Software
  c2_platform: C2PlatformIcon,
  analytics: AnalyticsIcon,
  autonomy: AutonomyIcon,
};
