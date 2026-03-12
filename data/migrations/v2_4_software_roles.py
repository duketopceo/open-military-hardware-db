"""
V2.4 Migration: Add software category, role_type classification, 
Palantir & Anduril platforms.
"""
import sqlite3
import os

DB_PATH = os.path.join(os.path.dirname(__file__), "..", "sql", "military_hardware.db")

def run():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys=ON")
    cur = conn.cursor()

    # ── 1. Add role_type column to platforms ──────────────────────────────
    # offensive | defensive | dual | support | intelligence
    try:
        cur.execute("ALTER TABLE platforms ADD COLUMN role_type TEXT DEFAULT NULL")
        print("✓ Added role_type column to platforms")
    except sqlite3.OperationalError as e:
        if "duplicate column" in str(e).lower():
            print("⊘ role_type column already exists")
        else:
            raise

    # ── 2. Add 'software' category + subcategories ──────────────────────
    cur.execute("""
        INSERT OR IGNORE INTO categories (category_id, category_name, description)
        VALUES ('software', 'Software', 'Military software platforms, C2 systems, AI/ML platforms, and digital infrastructure')
    """)
    
    software_subcategories = [
        ('c2-platform', 'software', 'Command & Control Platform', 'Integrated command and control software for operational decision-making'),
        ('ai-ml-platform', 'software', 'AI/ML Platform', 'Artificial intelligence and machine learning platforms for defense'),
        ('isr-analytics', 'software', 'ISR Analytics', 'Intelligence, surveillance, and reconnaissance data analytics'),
        ('data-integration', 'software', 'Data Integration', 'Data fusion and integration platforms for defense operations'),
        ('autonomy-os', 'software', 'Autonomy OS', 'Operating systems for autonomous systems and robotics'),
        ('cyber-platform', 'software', 'Cyber Platform', 'Cybersecurity and cyber operations platforms'),
    ]
    for sub_id, cat_id, name, desc in software_subcategories:
        cur.execute("""
            INSERT OR IGNORE INTO subcategories (subcategory_id, category_id, subcategory_name, description)
            VALUES (?, ?, ?, ?)
        """, (sub_id, cat_id, name, desc))
    print("✓ Added software category + subcategories")

    # ── 3. Classify existing platforms (role_type) ────────────────────────
    
    # Offensive platforms (weapons, strike aircraft, attack systems)
    offensive_subcats = [
        'fighter', 'bomber', 'helicopter-attack', 'drone-combat',
        'mbt', 'ifv', 'artillery-sp', 'artillery-towed', 'mlrs',
        'aam', 'agm', 'ssm', 'bm', 'ashm', 'bomb-guided', 'bomb-unguided',
        'torpedo', 'atgm', 'artillery-round',
        'destroyer', 'cruiser', 'submarine-ssn', 'submarine-ssbn',
    ]
    
    # Defensive platforms  
    defensive_subcats = [
        'sam', 'sam-missile',
    ]
    
    # Dual-role (can be offensive or defensive depending on mission)
    dual_subcats = [
        'frigate', 'corvette', 'patrol',
        'apc', 'armored-car', 'mrap', 'small-arms',
    ]
    
    # Support platforms
    support_subcats = [
        'transport', 'helicopter-utility', 'drone-recon', 'awacs', 'tanker', 'trainer',
        'engineer', 'carrier', 'amphibious', 'submarine-ssk',
    ]
    
    for subcat in offensive_subcats:
        cur.execute("UPDATE platforms SET role_type = 'offensive' WHERE subcategory_id = ? AND role_type IS NULL", (subcat,))
    for subcat in defensive_subcats:
        cur.execute("UPDATE platforms SET role_type = 'defensive' WHERE subcategory_id = ? AND role_type IS NULL", (subcat,))
    for subcat in dual_subcats:
        cur.execute("UPDATE platforms SET role_type = 'dual' WHERE subcategory_id = ? AND role_type IS NULL", (subcat,))
    for subcat in support_subcats:
        cur.execute("UPDATE platforms SET role_type = 'support' WHERE subcategory_id = ? AND role_type IS NULL", (subcat,))
    
    # Specific overrides — some platforms have clear roles despite subcategory
    # F-15E is dual (air superiority + strike)
    cur.execute("UPDATE platforms SET role_type = 'dual' WHERE platform_id LIKE '%f-15e%'")
    # F/A-18 is dual
    cur.execute("UPDATE platforms SET role_type = 'dual' WHERE platform_id LIKE '%f-a-18%' OR platform_id LIKE '%fa-18%'")
    # AWACS is intelligence
    cur.execute("UPDATE platforms SET role_type = 'intelligence' WHERE subcategory_id = 'awacs'")
    # Recon drones are intelligence
    cur.execute("UPDATE platforms SET role_type = 'intelligence' WHERE subcategory_id = 'drone-recon'")
    
    # Catch any remaining NULLs
    cur.execute("UPDATE platforms SET role_type = 'dual' WHERE role_type IS NULL")
    
    updated = cur.execute("SELECT role_type, COUNT(*) FROM platforms GROUP BY role_type").fetchall()
    print(f"✓ Classified platforms: {dict(updated)}")

    # ── 4. Insert Palantir software platforms ─────────────────────────────
    
    palantir_platforms = [
        {
            "platform_id": "palantir-gotham",
            "common_name": "Palantir Gotham",
            "official_designation": "Gotham Intelligence Platform",
            "category_id": "software",
            "subcategory_id": "isr-analytics",
            "manufacturer": "Palantir Technologies",
            "country_of_origin": "US",
            "entered_service_year": 2008,
            "status_id": "active_service",
            "role_type": "intelligence",
            "description": "Intelligence analysis platform designed for counterterrorism and defense operations. Integrates and analyzes structured and unstructured data from multiple sources to identify patterns, relationships, and threats. Used extensively by CIA, NSA, FBI, and military intelligence units. Provides graph-based entity resolution, geospatial analysis, and temporal event tracking across classified networks (NIPR, SIPR, JWICS)."
        },
        {
            "platform_id": "palantir-foundry",
            "common_name": "Palantir Foundry",
            "official_designation": "Foundry Operating System",
            "category_id": "software",
            "subcategory_id": "data-integration",
            "manufacturer": "Palantir Technologies",
            "country_of_origin": "US",
            "entered_service_year": 2017,
            "status_id": "active_service",
            "role_type": "support",
            "description": "Enterprise data integration and operational analytics platform. Provides an ontology-based data model that maps relationships across disparate data sources. Used by DoD for logistics optimization, supply chain management, and operational planning. Supports Army Vantage program ($619M contract) for Army-wide data integration and AI-enabled decision-making."
        },
        {
            "platform_id": "palantir-aip",
            "common_name": "Palantir AIP",
            "official_designation": "Artificial Intelligence Platform",
            "category_id": "software",
            "subcategory_id": "ai-ml-platform",
            "manufacturer": "Palantir Technologies",
            "country_of_origin": "US",
            "entered_service_year": 2023,
            "status_id": "active_service",
            "role_type": "dual",
            "description": "AI/ML platform that integrates large language models into defense operations across classified networks. Enables responsible deployment of frontier AI models with military-grade guardrails, access controls, and audit trails. Supports mission planning, targeting workflows, electronic warfare coordination, and autonomous system tasking. Deployed on NIPR, SIPR, and JWICS via AWS GovCloud. Core AI backbone for Maven Smart System and JADC2 initiatives."
        },
        {
            "platform_id": "palantir-maven-smart-system",
            "common_name": "Maven Smart System (MSS)",
            "official_designation": "MSS / Project Maven",
            "category_id": "software",
            "subcategory_id": "c2-platform",
            "manufacturer": "Palantir Technologies",
            "country_of_origin": "US",
            "entered_service_year": 2024,
            "status_id": "active_service",
            "role_type": "offensive",
            "description": "Full-spectrum AI-enabled command-and-control system evolved from Project Maven (est. 2017). Fuses intelligence from satellite imagery, SIGINT, surveillance feeds, HUMINT, and open-source data into a single operational picture. Identifies and prioritizes targets in near-real time, generates GPS coordinates for strikes, recommends optimal weapons systems, and produces automated legal justifications. Supports JADC2 connecting every sensor and shooter across all domains. $1.3B contract ceiling through 2029, 20,000+ active military users. NATO variant operational since April 2025."
        },
        {
            "platform_id": "palantir-titan",
            "common_name": "TITAN Ground Station",
            "official_designation": "Tactical Intelligence Targeting Access Node",
            "category_id": "software",
            "subcategory_id": "isr-analytics",
            "manufacturer": "Palantir Technologies",
            "country_of_origin": "US",
            "entered_service_year": 2025,
            "status_id": "prototype",
            "role_type": "intelligence",
            "description": "Next-generation Army intelligence ground station enabled by AI and machine learning. Represents a transformational leap in deep sensing and effects capabilities, providing tactical units with AI-processed intelligence from space-based and aerial sensors. Designed to dramatically reduce sensor-to-shooter timelines and enable precision targeting at echelon."
        },
        {
            "platform_id": "palantir-apollo",
            "common_name": "Palantir Apollo",
            "official_designation": "Apollo Continuous Delivery",
            "category_id": "software",
            "subcategory_id": "data-integration",
            "manufacturer": "Palantir Technologies",
            "country_of_origin": "US",
            "entered_service_year": 2020,
            "status_id": "active_service",
            "role_type": "support",
            "description": "Continuous delivery and deployment platform that manages software across classified and edge environments. Enables autonomous software updates across NIPR, SIPR, JWICS, and tactical edge devices. Manages the deployment pipeline for Gotham, Foundry, and AIP across DoD infrastructure. Critical infrastructure layer enabling 24-hour software update cycles in operational environments."
        },
    ]
    
    for p in palantir_platforms:
        cols = ", ".join(p.keys())
        placeholders = ", ".join(["?"] * len(p))
        cur.execute(f"INSERT OR IGNORE INTO platforms ({cols}) VALUES ({placeholders})", list(p.values()))
    
    print(f"✓ Inserted {len(palantir_platforms)} Palantir platforms")

    # ── 5. Insert Anduril platforms ───────────────────────────────────────
    
    anduril_platforms = [
        {
            "platform_id": "anduril-lattice",
            "common_name": "Lattice OS",
            "official_designation": "Lattice Operating System",
            "category_id": "software",
            "subcategory_id": "autonomy-os",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2019,
            "status_id": "active_service",
            "role_type": "dual",
            "description": "Open, hardware-agnostic operating system for defense that delivers autonomous operations across air, land, sea, and space. Fuses data from thousands of sensors into an intelligent common operating picture. Enables a single operator to manage dozens of autonomous systems. Features mesh networking for contested environments, Lattice SDK for third-party integration, and Mission Autonomy for team-of-teams coordination. Active users include USMC, USAF, UK Royal Marines, and CBP."
        },
        {
            "platform_id": "anduril-lattice-mission-autonomy",
            "common_name": "Lattice Mission Autonomy",
            "official_designation": "Lattice for Mission Autonomy",
            "category_id": "software",
            "subcategory_id": "c2-platform",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2023,
            "status_id": "active_service",
            "role_type": "dual",
            "description": "Extension of Lattice OS enabling teams of unmanned systems to autonomously collaborate to achieve mission outcomes across all domains. Understands commander's intent and orchestrates autonomous assets like an orchestra conductor. Enables dynamic handoff of C2 between nodes, automatic communications relay, and rapid force reconfiguration. $99.6M Army Next-Gen C2 prototype contract (July 2025)."
        },
        {
            "platform_id": "anduril-fury",
            "common_name": "Fury",
            "official_designation": "Fury Autonomous Air Vehicle",
            "category_id": "air",
            "subcategory_id": "drone-combat",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "development_start_year": 2023,
            "status_id": "prototype",
            "role_type": "dual",
            "description": "High-performance, multi-mission Group 5 autonomous air vehicle (AAV) enabling trusted and collaborative autonomy for the high-end fight. Originally developed by Blue Force Technologies (acquired 2023). Leverages Lattice software for mission autonomy. Features advanced rapid prototyping, digital engineering, open and modular system design. Supports variety of first or third-party sensors and payloads. Uses synthetic pilots and intelligent flight simulation for rapid iteration. Built at a fraction of the cost of crewed fighters."
        },
        {
            "platform_id": "anduril-roadrunner",
            "common_name": "Roadrunner",
            "official_designation": "Roadrunner AAV",
            "category_id": "air",
            "subcategory_id": "drone-combat",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2024,
            "status_id": "active_service",
            "role_type": "dual",
            "description": "Reusable, vertical take-off and landing (VTOL) autonomous air vehicle with twin turbojet engines and modular payload bay. Carbon fiber body capable of high subsonic speeds (~980 km/h). Can be deployed from container-based launch stations and recovered like SpaceX rockets. Modular nose payload supports ISR or explosive warhead (Roadrunner-M variant). 3x warhead capacity, 10x one-way effective range, and 3x more maneuverable than comparable systems. Controlled by Lattice OS."
        },
        {
            "platform_id": "anduril-roadrunner-m",
            "common_name": "Roadrunner-M",
            "official_designation": "Roadrunner-Munition",
            "category_id": "air",
            "subcategory_id": "drone-combat",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2024,
            "status_id": "active_service",
            "role_type": "defensive",
            "description": "High-explosive interceptor variant of Roadrunner for ground-based air defense. Rapidly identifies, intercepts, and destroys aerial threats including aircraft up to 100x more expensive, or can be safely recovered and reused at near-zero cost if threat is not confirmed. Operator-supervised autonomous engagement with Lattice integration. Designed to counter drones, cruise missiles, and manned aircraft. Operationally assessed and validated."
        },
        {
            "platform_id": "anduril-ghost-x",
            "common_name": "Ghost-X",
            "official_designation": "Ghost-X sUAS",
            "category_id": "air",
            "subcategory_id": "drone-recon",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2023,
            "status_id": "active_service",
            "role_type": "intelligence",
            "description": "Expeditionary small unmanned aerial system (sUAS) with low acoustic signature and 3-axis maneuverability for hover-and-stare ISR. 75-minute flight time with dual battery configuration, doubled payload capacity over Ghost 4. Integrated with Lattice OS for autonomous mission planning and airspace management. Equipped with Trillium HD45-LV imaging with 1-degree geolocation accuracy. Used by US Army (13 units, 1,200+ flight hours), USAF, and UK forces. Redesigned based on Ukraine combat feedback for EW-contested environments. Units with Ghost-X performed 300% more effectively against opposing forces."
        },
        {
            "platform_id": "anduril-altius-600",
            "common_name": "Altius-600",
            "official_designation": "ALTIUS-600",
            "category_id": "air",
            "subcategory_id": "drone-combat",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2022,
            "status_id": "active_service",
            "role_type": "offensive",
            "description": "Tube-launched expendable small UAS (12.3 kg) with fold-out wings. Range up to 440 km, endurance 4+ hours. Supports ISR, EW, SIGINT, comms relay, and warhead payloads. Launchable from helicopters, C-130, Blackhawk, ground vehicles, ships, or other drones. Developed by Area-I (acquired 2021). Hundreds supplied to Ukraine including ~100 for Black Sea operations ($40M contract). Manufactured at scale for affordability. Integrated with Lattice OS and Mission Autonomy."
        },
        {
            "platform_id": "anduril-altius-700",
            "common_name": "Altius-700",
            "official_designation": "ALTIUS-700",
            "category_id": "air",
            "subcategory_id": "drone-combat",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2023,
            "status_id": "active_service",
            "role_type": "offensive",
            "description": "Larger variant of Altius-600 designed for multi-domain operations. 30 kg max weight, range up to 500 km, endurance 2+ hours. Expanded payload capacity for heavier warheads and more sophisticated sensor suites. Tube-launched from multiple platforms. Integrated with Lattice OS."
        },
        {
            "platform_id": "anduril-anvil",
            "common_name": "Anvil",
            "official_designation": "Anvil Counter-UAS Interceptor",
            "category_id": "air",
            "subcategory_id": "drone-combat",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2022,
            "status_id": "active_service",
            "role_type": "defensive",
            "description": "Autonomous counter-UAS interceptor drone that defeats hostile drones through kinetic impact at speeds up to 320 km/h (200 mph). Uses Lattice AI for autonomous detection, tracking, and intercept. Cost-effective alternative to expensive missile interceptors for defeating small UAS threats. Reusable if intercept is not required."
        },
        {
            "platform_id": "anduril-sentry-tower",
            "common_name": "Sentry Tower",
            "official_designation": "Sentry Autonomous Surveillance Tower",
            "category_id": "land",
            "subcategory_id": "sam",  # closest existing — surveillance system
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2020,
            "status_id": "active_service",
            "role_type": "defensive",
            "description": "Autonomous surveillance tower platform using AI to detect, identify, classify, and track objects of interest across land, sea, and air. Equipped with radar, EO/IR cameras, and other sensors. Powered by Lattice for real-time threat detection and alerting. Deployable as fixed or mobile installation. Used by US Customs and Border Protection and military installations for perimeter security. Part of integrated counter-UAS solutions including $642M 10-year USMC CUAS program of record."
        },
        {
            "platform_id": "anduril-dive-ld",
            "common_name": "Dive-LD",
            "official_designation": "Dive-LD AUV",
            "category_id": "sea",
            "subcategory_id": "submarine-ssk",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "entered_service_year": 2021,
            "status_id": "active_service",
            "role_type": "intelligence",
            "description": "Extra-large autonomous underwater vehicle (XL-AUV) for littoral and deep-water operations. Over 1 m³ payload capacity for rapid integration of mission-specific payloads and sensor suites. Supports survey, inspection, and ISR missions. Most reliable and flexible AUV platform, applicable to wide range of defense and commercial mission sets. Controlled by Lattice OS."
        },
        {
            "platform_id": "anduril-ghost-shark",
            "common_name": "Ghost Shark",
            "official_designation": "Ghost Shark XL-AUV",
            "category_id": "sea",
            "subcategory_id": "submarine-ssk",
            "manufacturer": "Anduril Industries",
            "country_of_origin": "US",
            "development_start_year": 2022,
            "status_id": "prototype",
            "role_type": "offensive",
            "description": "Extra-large autonomous undersea vehicle developed in partnership with Royal Australian Navy and DSTG. Designed for multi-mission autonomous operations in contested environments. Integrated with Lattice OS and Lattice Mission Autonomy for autonomous team coordination. Being developed at a secure facility in Sydney, Australia. Represents next generation of undersea autonomous warfare capability."
        },
    ]
    
    for p in anduril_platforms:
        cols = ", ".join(p.keys())
        placeholders = ", ".join(["?"] * len(p))
        cur.execute(f"INSERT OR IGNORE INTO platforms ({cols}) VALUES ({placeholders})", list(p.values()))
    
    print(f"✓ Inserted {len(anduril_platforms)} Anduril platforms")

    # ── 6. Add sources for new platforms ──────────────────────────────────
    
    sources = [
        # Palantir
        ("palantir-gotham", "Palantir Technologies", "https://www.palantir.com/offerings/defense/", "2026-03-12", "all", "primary"),
        ("palantir-foundry", "Palantir Technologies", "https://www.palantir.com/offerings/defense/", "2026-03-12", "all", "primary"),
        ("palantir-aip", "Palantir AIP for Defense", "https://www.palantir.com/platforms/aip/defense/", "2026-03-12", "all", "primary"),
        ("palantir-maven-smart-system", "Palantir Investor Relations", "https://investors.palantir.com/news-details/2024/Palantir-Expands-Maven-Smart-System-AIML-Capabilities-to-Military-Services/", "2026-03-12", "all", "primary"),
        ("palantir-maven-smart-system", "FedSavvy Strategies", "https://www.fedsavvystrategies.com/palantir-federal/", "2026-03-12", "contracts", "secondary"),
        ("palantir-titan", "Palantir TITAN", "https://www.palantir.com/titan/", "2026-03-12", "all", "primary"),
        ("palantir-apollo", "Palantir Technologies", "https://www.palantir.com/offerings/defense/solutions/", "2026-03-12", "all", "primary"),
        # Anduril
        ("anduril-lattice", "Anduril Lattice OS", "https://sldinfo.com/wp-content/uploads/2022/10/2022-slick-Lattice-OS-AUS.pdf", "2026-03-12", "all", "primary"),
        ("anduril-lattice", "Anduril Lattice SDK", "https://www.anduril.com/lattice/lattice-sdk", "2026-03-12", "sdk", "primary"),
        ("anduril-lattice-mission-autonomy", "Anduril Mission Autonomy", "https://www.anduril.com/lattice/mission-autonomy", "2026-03-12", "all", "primary"),
        ("anduril-fury", "Anduril Fury", "https://www.anduril.com/fury", "2026-03-12", "all", "primary"),
        ("anduril-roadrunner", "Anduril Roadrunner", "https://www.anduril.com/roadrunner", "2026-03-12", "all", "primary"),
        ("anduril-roadrunner-m", "Anduril Roadrunner & Roadrunner-M", "https://www.anduril.com/news/anduril-unveils-roadrunner-and-roadrunner-m", "2026-03-12", "all", "primary"),
        ("anduril-ghost-x", "Anduril Ghost-X", "https://www.anduril.com/ghost", "2026-03-12", "all", "primary"),
        ("anduril-ghost-x", "Anduril Ghost-X Announcement", "https://www.anduril.com/news/anduril-unveils-ghost-x", "2026-03-12", "specs", "primary"),
        ("anduril-altius-600", "Defence Industry Europe", "https://defence-industry.eu/anduril-responds-to-reports-of-failed-altius-and-ghost-x-tests-with-wider-context-on-development/", "2026-03-12", "all", "secondary"),
        ("anduril-altius-700", "Defence Industry Europe", "https://defence-industry.eu/anduril-responds-to-reports-of-failed-altius-and-ghost-x-tests-with-wider-context-on-development/", "2026-03-12", "all", "secondary"),
        ("anduril-anvil", "Anduril Industries", "https://www.anduril.com", "2026-03-12", "all", "primary"),
        ("anduril-sentry-tower", "Anduril Sentry", "https://www.anduril.com/sentry", "2026-03-12", "all", "primary"),
        ("anduril-sentry-tower", "Anduril USMC CUAS Contract", "https://www.anduril.com/news/anduril-awarded-10-year-642m-program-of-record-to-deliver-cuas-systems-for-u-s-marine-corps", "2026-03-12", "contracts", "primary"),
        ("anduril-dive-ld", "Anduril Dive-LD", "https://www.anduril.com/dive-ld", "2026-03-12", "all", "primary"),
        ("anduril-ghost-shark", "EX2 Defence", "https://www.ex2.com.au/uncategorized/in-detail-anduril-launches-extended-lattice-os/", "2026-03-12", "all", "secondary"),
    ]
    
    for pid, name, url, access, fields, reliability in sources:
        cur.execute("""
            INSERT OR IGNORE INTO sources (platform_id, source_name, source_url, access_date, data_fields_sourced, reliability_rating)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (pid, name, url, access, fields, reliability))
    
    print(f"✓ Inserted {len(sources)} source citations")

    # ── 7. Add specifications for key platforms ──────────────────────────
    
    # Anduril hardware specs
    specs = [
        {
            "platform_id": "anduril-roadrunner",
            "speed_max_kmh": 980,
            "powerplant_type": "turbojet",
            "powerplant_count": 2,
            "additional_specs_json": '{"launch_type": "VTOL container", "reusable": true, "payload_type": "modular nose bay"}'
        },
        {
            "platform_id": "anduril-roadrunner-m",
            "speed_max_kmh": 980,
            "powerplant_type": "turbojet",
            "powerplant_count": 2,
            "additional_specs_json": '{"launch_type": "VTOL container", "reusable": true, "warhead": "high-explosive", "target_types": "UAS, cruise missiles, manned aircraft"}'
        },
        {
            "platform_id": "anduril-ghost-x",
            "weight_max_kg": 15,
            "endurance_hours": 1.25,
            "additional_specs_json": '{"propulsion": "electric multi-rotor", "batteries": "dual", "acoustic_signature": "low", "geolocation_accuracy_deg": 1, "camera": "Trillium HD45-LV"}'
        },
        {
            "platform_id": "anduril-altius-600",
            "weight_max_kg": 12.3,
            "range_km": 440,
            "endurance_hours": 4,
            "additional_specs_json": '{"launch_type": "tube-launched", "wing_type": "fold-out", "payloads": ["ISR", "EW", "SIGINT", "comms relay", "warhead"]}'
        },
        {
            "platform_id": "anduril-altius-700",
            "weight_max_kg": 30,
            "range_km": 500,
            "endurance_hours": 2,
            "additional_specs_json": '{"launch_type": "tube-launched", "wing_type": "fold-out"}'
        },
        {
            "platform_id": "anduril-anvil",
            "speed_max_kmh": 320,
            "additional_specs_json": '{"intercept_method": "kinetic impact", "reusable": true, "target_types": "small UAS"}'
        },
        {
            "platform_id": "anduril-dive-ld",
            "additional_specs_json": '{"payload_volume_m3": 1.0, "mission_types": ["survey", "inspection", "ISR"], "environment": "littoral and deep-water"}'
        },
    ]
    
    for spec in specs:
        pid = spec.pop("platform_id")
        # Check if spec already exists
        existing = cur.execute("SELECT spec_id FROM specifications WHERE platform_id = ?", (pid,)).fetchone()
        if existing:
            continue
        cols = ["platform_id"] + list(spec.keys())
        vals = [pid] + list(spec.values())
        placeholders = ", ".join(["?"] * len(vals))
        cur.execute(f"INSERT INTO specifications ({', '.join(cols)}) VALUES ({placeholders})", vals)
    
    print("✓ Inserted specifications for Anduril hardware")

    # ── 8. Add economics for notable contracts ───────────────────────────
    
    economics = [
        ("palantir-maven-smart-system", 1300000000, 2029, None, None, "Program ceiling $1.3B through 2029. Initial $480M 5-year deal May 2024, expanded $795M modification 2025."),
        ("palantir-gotham", None, None, None, None, "Part of enterprise Palantir defense portfolio. Army exploring $10B enterprise deal."),
        ("anduril-sentry-tower", None, None, 642000000, None, "$642M 10-year USMC CUAS program of record."),
        ("anduril-lattice-mission-autonomy", None, None, 99600000, None, "$99.6M Army Next-Gen C2 prototype contract (July 2025)."),
        ("anduril-altius-600", None, None, 40000000, None, "$40M contract for ~100 units to Ukraine for Black Sea operations (2023)."),
    ]
    
    for pid, unit_cost, cost_year, program_cost, dev_cost, notes in economics:
        existing = cur.execute("SELECT econ_id FROM economics WHERE platform_id = ?", (pid,)).fetchone()
        if existing:
            continue
        cur.execute("""
            INSERT INTO economics (platform_id, unit_cost_usd, unit_cost_year, program_cost_usd, development_cost_usd, cost_notes)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (pid, unit_cost, cost_year, program_cost, dev_cost, notes))
    
    print("✓ Inserted economics data")

    # ── 9. Fix Sentry Tower subcategory (was 'sam', should be something better) ──
    # Add a new subcategory for surveillance systems under land
    cur.execute("""
        INSERT OR IGNORE INTO subcategories (subcategory_id, category_id, subcategory_name, description)
        VALUES ('surveillance', 'land', 'Surveillance System', 'Autonomous surveillance and sensor systems for perimeter security and threat detection')
    """)
    cur.execute("UPDATE platforms SET subcategory_id = 'surveillance' WHERE platform_id = 'anduril-sentry-tower'")
    print("✓ Added surveillance subcategory, fixed Sentry Tower")

    conn.commit()
    
    # Final stats
    total = cur.execute("SELECT COUNT(*) FROM platforms").fetchone()[0]
    software = cur.execute("SELECT COUNT(*) FROM platforms WHERE category_id = 'software'").fetchone()[0]
    print(f"\n✓ Migration complete. Total platforms: {total} ({software} software)")
    
    conn.close()

if __name__ == "__main__":
    run()
