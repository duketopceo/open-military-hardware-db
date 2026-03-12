// API types matching FastAPI response models

export interface PlatformSummary {
  platform_id: string;
  common_name: string;
  official_designation?: string;
  nato_reporting_name?: string;
  category_id: string;
  subcategory_id?: string;
  country_of_origin: string;
  manufacturer: string;
  status_id?: string;
  entered_service_year?: number;
  units_built?: number;
  description?: string;
}

export interface PlatformListResponse {
  platforms: PlatformSummary[];
  total: number;
  limit: number;
  offset: number;
}

export interface PlatformDetail extends PlatformSummary {
  specifications: Record<string, any>;
  economics: Record<string, any>;
  armaments: Array<Record<string, any>>;
  operators: Array<Record<string, any>>;
  conflicts: Array<Record<string, any>>;
  media: Array<Record<string, any>>;
  sources: Array<Record<string, any>>;
}

export interface StatsResponse {
  platforms_count: number;
  specifications_count: number;
  economics_count: number;
  armaments_count: number;
  operators_count: number;
  platform_conflicts_count: number;
  media_count: number;
  sources_count: number;
  categories: Record<string, number>;
  countries: Record<string, number>;
  statuses: Record<string, number>;
  eras: Record<string, number>;
}

export interface Category {
  category_id: string;
  category_name: string;
  description?: string;
  subcategories: Subcategory[];
}

export interface Subcategory {
  subcategory_id: string;
  category_id: string;
  subcategory_name: string;
  description?: string;
}

export interface Conflict {
  conflict_id: string;
  conflict_name: string;
  start_year?: number;
  end_year?: number;
  region?: string;
  description?: string;
  platform_count: number;
}

export interface CompareResponse {
  count: number;
  platforms: PlatformDetail[];
}

// ─── Country flag emoji from 2-letter ISO code ───
export function countryFlag(code: string): string {
  if (!code || code.length !== 2) return '';
  return String.fromCodePoint(
    ...code.toUpperCase().split('').map(c => c.charCodeAt(0) + 127397)
  );
}

// ─── Country → dominant flag color for charts ───
export const countryColors: Record<string, string> = {
  'US': '#3C3B6E',
  'United States': '#3C3B6E',
  'RU': '#D52B1E',
  'Russia': '#D52B1E',
  'CN': '#DE2910',
  'China': '#DE2910',
  'GB': '#012169',
  'United Kingdom': '#012169',
  'FR': '#002395',
  'France': '#002395',
  'DE': '#FFCE00',
  'Germany': '#FFCE00',
  'SE': '#006AA7',
  'Sweden': '#006AA7',
  'IL': '#0038B8',
  'Israel': '#0038B8',
  'IN': '#FF9933',
  'India': '#FF9933',
  'AU': '#002868',
  'Australia': '#002868',
  'KR': '#003478',
  'South Korea': '#003478',
  'JP': '#BC002D',
  'Japan': '#BC002D',
  'IT': '#009246',
  'Italy': '#009246',
  'Soviet Union': '#CC0000',
  'TR': '#E30A17',
  'Turkey': '#E30A17',
};

// Category icons/colors
export const categoryConfig: Record<string, { label: string; color: string; icon: string }> = {
  air: { label: "Air", color: "hsl(200, 60%, 55%)", icon: "Plane" },
  land: { label: "Land", color: "hsl(142, 45%, 42%)", icon: "Truck" },
  sea: { label: "Sea", color: "hsl(220, 50%, 50%)", icon: "Ship" },
  munition: { label: "Munition", color: "hsl(38, 80%, 50%)", icon: "Crosshair" },
};

export const statusConfig: Record<string, { label: string; color: string }> = {
  active: { label: "Active", color: "hsl(142, 50%, 50%)" },
  retired: { label: "Retired", color: "hsl(0, 0%, 55%)" },
  limited: { label: "Limited", color: "hsl(38, 80%, 50%)" },
  prototype: { label: "Prototype", color: "hsl(262, 50%, 55%)" },
  in_development: { label: "In Development", color: "hsl(200, 60%, 55%)" },
};
