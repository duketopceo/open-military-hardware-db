-- ============================================================================
-- SEED DATA for reference/enum tables
-- Run after 001_create_tables.sql
-- ============================================================================

-- Categories
INSERT OR IGNORE INTO categories VALUES ('air', 'Air', 'Fixed-wing aircraft, rotorcraft, and unmanned aerial systems');
INSERT OR IGNORE INTO categories VALUES ('land', 'Land', 'Ground combat vehicles, artillery, and infantry systems');
INSERT OR IGNORE INTO categories VALUES ('sea', 'Sea', 'Naval vessels including surface combatants and submarines');
INSERT OR IGNORE INTO categories VALUES ('munition', 'Munition', 'Missiles, bombs, torpedoes, mines, and ammunition');

-- Subcategories: Air
INSERT OR IGNORE INTO subcategories VALUES ('fighter', 'air', 'Fighter', 'Air superiority and multirole combat aircraft');
INSERT OR IGNORE INTO subcategories VALUES ('bomber', 'air', 'Bomber', 'Strategic and tactical bombing aircraft');
INSERT OR IGNORE INTO subcategories VALUES ('transport', 'air', 'Transport', 'Military cargo and troop transport aircraft');
INSERT OR IGNORE INTO subcategories VALUES ('helicopter-attack', 'air', 'Attack Helicopter', 'Rotary-wing attack platforms');
INSERT OR IGNORE INTO subcategories VALUES ('helicopter-utility', 'air', 'Utility Helicopter', 'Multi-purpose rotary-wing aircraft');
INSERT OR IGNORE INTO subcategories VALUES ('drone-combat', 'air', 'Combat Drone', 'Armed unmanned aerial vehicles');
INSERT OR IGNORE INTO subcategories VALUES ('drone-recon', 'air', 'Reconnaissance Drone', 'Surveillance and ISR UAVs');
INSERT OR IGNORE INTO subcategories VALUES ('awacs', 'air', 'AWACS/AEW', 'Airborne early warning and control');
INSERT OR IGNORE INTO subcategories VALUES ('tanker', 'air', 'Tanker', 'Aerial refueling aircraft');
INSERT OR IGNORE INTO subcategories VALUES ('trainer', 'air', 'Trainer', 'Military training aircraft');

-- Subcategories: Land
INSERT OR IGNORE INTO subcategories VALUES ('mbt', 'land', 'Main Battle Tank', 'Primary armored fighting vehicles');
INSERT OR IGNORE INTO subcategories VALUES ('ifv', 'land', 'Infantry Fighting Vehicle', 'Armored troop carriers with integral weapons');
INSERT OR IGNORE INTO subcategories VALUES ('apc', 'land', 'Armored Personnel Carrier', 'Troop transport vehicles with light armor');
INSERT OR IGNORE INTO subcategories VALUES ('artillery-sp', 'land', 'Self-Propelled Artillery', 'Mobile howitzers and gun systems');
INSERT OR IGNORE INTO subcategories VALUES ('artillery-towed', 'land', 'Towed Artillery', 'Towed howitzers and guns');
INSERT OR IGNORE INTO subcategories VALUES ('mlrs', 'land', 'MLRS', 'Multiple launch rocket systems');
INSERT OR IGNORE INTO subcategories VALUES ('sam', 'land', 'SAM System', 'Surface-to-air missile systems');
INSERT OR IGNORE INTO subcategories VALUES ('armored-car', 'land', 'Armored Car', 'Wheeled armored reconnaissance vehicles');
INSERT OR IGNORE INTO subcategories VALUES ('mrap', 'land', 'MRAP', 'Mine-resistant ambush protected vehicles');
INSERT OR IGNORE INTO subcategories VALUES ('engineer', 'land', 'Engineer Vehicle', 'Combat engineering and bridging vehicles');
INSERT OR IGNORE INTO subcategories VALUES ('small-arms', 'land', 'Small Arms', 'Infantry weapons and crew-served weapons');

-- Subcategories: Sea
INSERT OR IGNORE INTO subcategories VALUES ('carrier', 'sea', 'Aircraft Carrier', 'Fleet aircraft carriers and light carriers');
INSERT OR IGNORE INTO subcategories VALUES ('destroyer', 'sea', 'Destroyer', 'Multi-mission surface combatants');
INSERT OR IGNORE INTO subcategories VALUES ('frigate', 'sea', 'Frigate', 'Escort and patrol combatants');
INSERT OR IGNORE INTO subcategories VALUES ('corvette', 'sea', 'Corvette', 'Coastal combatants');
INSERT OR IGNORE INTO subcategories VALUES ('submarine-ssn', 'sea', 'Nuclear Attack Submarine', 'Nuclear-powered attack submarines');
INSERT OR IGNORE INTO subcategories VALUES ('submarine-ssbn', 'sea', 'Ballistic Missile Submarine', 'Nuclear ballistic missile submarines');
INSERT OR IGNORE INTO subcategories VALUES ('submarine-ssk', 'sea', 'Conventional Submarine', 'Diesel-electric attack submarines');
INSERT OR IGNORE INTO subcategories VALUES ('amphibious', 'sea', 'Amphibious', 'Landing ships and assault vessels');
INSERT OR IGNORE INTO subcategories VALUES ('patrol', 'sea', 'Patrol Craft', 'Coastal and offshore patrol vessels');
INSERT OR IGNORE INTO subcategories VALUES ('cruiser', 'sea', 'Cruiser', 'Large multi-mission surface combatants');

-- Subcategories: Munitions
INSERT OR IGNORE INTO subcategories VALUES ('aam', 'munition', 'Air-to-Air Missile', 'Air-launched anti-aircraft missiles');
INSERT OR IGNORE INTO subcategories VALUES ('agm', 'munition', 'Air-to-Ground Missile', 'Air-launched surface attack missiles');
INSERT OR IGNORE INTO subcategories VALUES ('sam-missile', 'munition', 'Surface-to-Air Missile', 'Ground/sea-launched anti-aircraft missiles');
INSERT OR IGNORE INTO subcategories VALUES ('ssm', 'munition', 'Surface-to-Surface Missile', 'Land/sea-attack cruise missiles');
INSERT OR IGNORE INTO subcategories VALUES ('bm', 'munition', 'Ballistic Missile', 'Ballistic missiles (tactical to ICBM)');
INSERT OR IGNORE INTO subcategories VALUES ('ashm', 'munition', 'Anti-Ship Missile', 'Anti-ship cruise missiles');
INSERT OR IGNORE INTO subcategories VALUES ('bomb-guided', 'munition', 'Guided Bomb', 'Precision-guided munitions');
INSERT OR IGNORE INTO subcategories VALUES ('bomb-unguided', 'munition', 'Unguided Bomb', 'Gravity bombs');
INSERT OR IGNORE INTO subcategories VALUES ('torpedo', 'munition', 'Torpedo', 'Anti-submarine and anti-ship torpedoes');
INSERT OR IGNORE INTO subcategories VALUES ('atgm', 'munition', 'Anti-Tank Guided Missile', 'Anti-armor missiles');
INSERT OR IGNORE INTO subcategories VALUES ('artillery-round', 'munition', 'Artillery Round', 'Shells and projectiles');

-- Platform statuses
INSERT OR IGNORE INTO platform_statuses VALUES ('in_production', 'In Production', 'Currently being manufactured');
INSERT OR IGNORE INTO platform_statuses VALUES ('active_service', 'Active Service', 'In operational use but no longer produced');
INSERT OR IGNORE INTO platform_statuses VALUES ('limited_service', 'Limited Service', 'Reduced numbers, being phased out');
INSERT OR IGNORE INTO platform_statuses VALUES ('retired', 'Retired', 'No longer in active military service');
INSERT OR IGNORE INTO platform_statuses VALUES ('prototype', 'Prototype', 'In development or testing phase');
INSERT OR IGNORE INTO platform_statuses VALUES ('cancelled', 'Cancelled', 'Program cancelled before production');
INSERT OR IGNORE INTO platform_statuses VALUES ('reserve', 'Reserve/Storage', 'In reserve or long-term storage');

-- Major countries (will be expanded)
INSERT OR IGNORE INTO countries VALUES ('US', 'United States', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('RU', 'Russia', 'CIS');
INSERT OR IGNORE INTO countries VALUES ('CN', 'China', 'Asia-Pacific');
INSERT OR IGNORE INTO countries VALUES ('GB', 'United Kingdom', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('FR', 'France', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('DE', 'Germany', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('IL', 'Israel', 'Middle East');
INSERT OR IGNORE INTO countries VALUES ('IN', 'India', 'South Asia');
INSERT OR IGNORE INTO countries VALUES ('JP', 'Japan', 'Asia-Pacific');
INSERT OR IGNORE INTO countries VALUES ('KR', 'South Korea', 'Asia-Pacific');
INSERT OR IGNORE INTO countries VALUES ('TR', 'Turkey', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('IT', 'Italy', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('SE', 'Sweden', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('UA', 'Ukraine', 'Europe');
INSERT OR IGNORE INTO countries VALUES ('AU', 'Australia', 'Asia-Pacific');
INSERT OR IGNORE INTO countries VALUES ('TW', 'Taiwan', 'Asia-Pacific');
INSERT OR IGNORE INTO countries VALUES ('SA', 'Saudi Arabia', 'Middle East');
INSERT OR IGNORE INTO countries VALUES ('PK', 'Pakistan', 'South Asia');
INSERT OR IGNORE INTO countries VALUES ('BR', 'Brazil', 'South America');
INSERT OR IGNORE INTO countries VALUES ('EG', 'Egypt', 'Middle East');
INSERT OR IGNORE INTO countries VALUES ('PL', 'Poland', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('ES', 'Spain', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('NL', 'Netherlands', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('NO', 'Norway', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('GR', 'Greece', 'NATO');
INSERT OR IGNORE INTO countries VALUES ('SU', 'Soviet Union', 'Historical');
INSERT OR IGNORE INTO countries VALUES ('CS', 'Czechoslovakia', 'Historical');
INSERT OR IGNORE INTO countries VALUES ('IR', 'Iran', 'Middle East');
INSERT OR IGNORE INTO countries VALUES ('KP', 'North Korea', 'Asia-Pacific');
INSERT OR IGNORE INTO countries VALUES ('ZA', 'South Africa', 'Africa');

-- Major conflicts reference
INSERT OR IGNORE INTO conflicts VALUES ('wwii-1939', 'World War II', 1939, 1945, 'Global', 'Global conflict');
INSERT OR IGNORE INTO conflicts VALUES ('korea-1950', 'Korean War', 1950, 1953, 'Korean Peninsula', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('vietnam-1955', 'Vietnam War', 1955, 1975, 'Southeast Asia', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('yom-kippur-1973', 'Yom Kippur War', 1973, 1973, 'Middle East', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('falklands-1982', 'Falklands War', 1982, 1982, 'South Atlantic', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('iran-iraq-1980', 'Iran-Iraq War', 1980, 1988, 'Middle East', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('gulf-war-1991', 'Gulf War (Desert Storm)', 1991, 1991, 'Middle East', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('balkans-1991', 'Yugoslav Wars', 1991, 2001, 'Balkans', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('afghanistan-2001', 'War in Afghanistan', 2001, 2021, 'Central Asia', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('iraq-2003', 'Iraq War', 2003, 2011, 'Middle East', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('libya-2011', 'Libyan Civil War', 2011, 2020, 'North Africa', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('syria-2011', 'Syrian Civil War', 2011, NULL, 'Middle East', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('ukraine-2022', 'Russo-Ukrainian War', 2022, NULL, 'Eastern Europe', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('nagorno-karabakh-2020', 'Nagorno-Karabakh War', 2020, 2020, 'South Caucasus', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('gaza-2023', 'Israel-Hamas War', 2023, NULL, 'Middle East', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('indo-pak-1971', 'Indo-Pakistani War', 1971, 1971, 'South Asia', NULL);
INSERT OR IGNORE INTO conflicts VALUES ('six-day-1967', 'Six-Day War', 1967, 1967, 'Middle East', NULL);
