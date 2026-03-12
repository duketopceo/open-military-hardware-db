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
