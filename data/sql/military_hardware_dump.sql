-- Military Hardware Database SQL Dump
-- Generated: 2026-03-11T02:10:08.283982
-- Platforms: 50

BEGIN TRANSACTION;
CREATE TABLE armaments (
    armament_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    weapon_name             TEXT NOT NULL,           -- 'M256 120mm smoothbore', 'AIM-120 AMRAAM'
    weapon_type             TEXT,                    -- 'cannon', 'missile', 'bomb', 'torpedo'
    caliber_mm              REAL,
    quantity                INTEGER,                 -- number of hardpoints/tubes/mounts
    linked_munition_id      TEXT REFERENCES platforms(platform_id),  -- if munition is its own platform
    notes                   TEXT
);
INSERT INTO "armaments" VALUES(1,'ah-64e-apache-guardian','30 mm M230E1 chain gun','cannon',30.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(2,'ah-64e-apache-guardian','16x AGM-114 Hellfire',NULL,NULL,16,NULL,NULL);
INSERT INTO "armaments" VALUES(3,'ah-64e-apache-guardian','76x Hydra 70 rockets',NULL,NULL,76,NULL,NULL);
INSERT INTO "armaments" VALUES(4,'northrop-b-2-spirit','Up to 18,000 kg of conventional or nuclear weapons (JDAMs, JSOW, JASSM, B61, B83, GBU-57 MOP)','bomb',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(5,'boeing-ch-47-chinook','Up to 3 × 7.62 mm machine guns (M240, M134 miniguns)','cannon',62.0,3,NULL,NULL);
INSERT INTO "armaments" VALUES(6,'eurofighter-ef-2000-typhoon','1 × 27 mm Mauser BK-27 cannon','cannon',27.0,1,NULL,NULL);
INSERT INTO "armaments" VALUES(7,'eurofighter-ef-2000-typhoon','AIM-120 AMRAAM, Meteor, IRIS-T, ASRAAM, Storm Shadow, Brimstone, etc. (13 hardpoints)','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(8,'general-dynamics-f-16-fighting-falcon','20 mm M61A1 Vulcan cannon','cannon',20.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(9,'general-dynamics-f-16-fighting-falcon','AIM-9/120/7 missiles, AGM-65/88, various bombs','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(10,'f-22a','1x 20mm M61A2 cannon','cannon',20.0,1,NULL,NULL);
INSERT INTO "armaments" VALUES(11,'f-22a','6x AIM-120 AMRAAM + 2x AIM-9 Sidewinder (air-to-air)','missile',NULL,6,NULL,NULL);
INSERT INTO "armaments" VALUES(12,'f-22a','2x 1,000 lb JDAM + 2x AIM-120 (air-to-ground)','bomb',NULL,2,NULL,NULL);
INSERT INTO "armaments" VALUES(13,'f-35a','1 × 25 mm GAU-22/A cannon','cannon',25.0,1,NULL,NULL);
INSERT INTO "armaments" VALUES(14,'f-35a','internal/external missiles and bombs (AIM-120, AIM-9X, JDAM, JASSM, etc.)','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(15,'boeing-fa-18e-super-hornet','1× 20 mm M61A2 Vulcan cannon','cannon',20.0,1,NULL,NULL);
INSERT INTO "armaments" VALUES(16,'boeing-fa-18e-super-hornet','11 hardpoints with up to 8,050 kg of AIM-120 AMRAAM, AIM-9 Sidewinder, AGM-88 HARM, JDAM bombs, etc.','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(17,'chengdu-j-20-20','PL-15/PL-21 AAMs (internal bays)','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(18,'chengdu-j-20-20','PL-10 short-range',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(19,'chengdu-j-20-20','precision-guided munitions',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(20,'kamov-ka-52','30mm 2A42 cannon, Vikhr ATGMs, rockets, Igla AAMs','cannon',30.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(21,'mq-9a-reaper','AGM-114 Hellfire missiles (up to 8), GBU-12 Paveway II, GBU-38 JDAM','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(22,'dassault-rafale','30 mm GIAT 30/M791 cannon, MICA/Meteor AAM, SCALP-EG, Exocet, ASMP-A, bombs','cannon',30.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(23,'sukhoi-su-57','30 mm GSh-30-1 cannon','cannon',30.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(24,'sukhoi-su-57','R-77M/R-37M AAMs','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(25,'sukhoi-su-57','Kh-69/Kh-38M ASM',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(26,'sukhoi-su-57','up to 10 t payload',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(27,'sikorsky-uh-60-black-hawk','2x 7.62mm MGs','cannon',62.0,2,NULL,NULL);
INSERT INTO "armaments" VALUES(28,'sikorsky-uh-60-black-hawk','optional Hellfire missiles, rockets, 30mm gun','cannon',30.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(29,'boevaya-mashina-pekhoty-3-bmp-3','100mm 2A70 gun/missile launcher, 30mm 2A72 cannon, 7.62mm PKT MG, 2x bow 7.62mm PKT','cannon',100.0,2,NULL,NULL);
INSERT INTO "armaments" VALUES(30,'fv4034-challenger-2','L30A1 120 mm rifled gun','cannon',120.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(31,'m142-high-mobility-artillery-rocket-system','1 pod with 6x GMLRS rockets or 1x ATACMS missile','missile',NULL,6,NULL,NULL);
INSERT INTO "armaments" VALUES(32,'iron-dome-kippat-barzel','Tamir interceptor missiles','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(33,'k2-k-2-heukpyo','CN08 120 mm L/55 smoothbore gun','cannon',120.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(34,'leopard-2a7','120 mm L/55 smoothbore gun, MG3 7.62 mm coaxial and roof MG','cannon',120.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(35,'m109a6-paladin','155mm M284 howitzer (39 rds)',NULL,155.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(36,'m1a2-system-enhancement-package-main-battle-tank','120mm M256 smoothbore gun, 12.7mm M2HB, 7.62mm M240 MGs','cannon',120.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(37,'infantry-fighting-vehicle-m2-bradley','25mm M242 Bushmaster chain gun, TOW ATGM, 7.62mm M240C MG','cannon',25.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(38,'panzerhaubitze-2000','155 mm L/52 howitzer',NULL,155.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(39,'mim-104f','Hit-to-kill kinetic impact + lethality enhancer (24 tungsten fragments)',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(40,'s-300-series-eg-s-300p-s-300v','48N6 / 5V55 missiles (4 per TEL)','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(41,'s-400-triumf','40N6 (400 km), 48N6DM (250 km), 9M96E2 (120 km) missiles','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(42,'m1126-infantry-carrier-vehicle','Protector RWS (.50 M2 MG / 40mm Mk19 / 7.62 M240), smoke grenades, Javelin (newer variants)','cannon',40.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(43,'object-148','125 mm 2A82-1M smoothbore gun','cannon',125.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(44,'object-148','12.7 mm Kord MG','cannon',7.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(45,'object-148','7.62 mm PKTM MG','cannon',62.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(46,'t-72-ural-object-172m','125 mm 2A46 smoothbore gun','cannon',125.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(47,'aim-120-advanced-medium-range-air-to-air-missile','Blast-fragmentation warhead',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(48,'agm-84-rgm-84-ugm-84-harpoon','227 kg high-explosive blast warhead',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(49,'agm-114-hellfire','Multi-purpose warhead (9 kg): HEAT, blast-frag, thermobaric variants',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(50,'gbu-313238-series','Mk 84/BLU-109 2000 lb bomb','bomb',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(51,'fgm-148-javelin','Tandem HEAT warhead (8.4 kg)',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(52,'3m-543m-14-kalibr','200-500 kg HE or nuclear warhead [Wikipedia](https://en.wikipedia.org/wiki/Kalibr_(missile_family))','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(53,'gbu-43b-massive-ordnance-air-blast','18,700 lb (8,500 kg) H-6 explosive (BLU-120/B warhead)',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(54,'scalp-eg-france-storm-shadow-uk','450 kg BROACH penetrator warhead',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(55,'bgm-109-tomahawk-land-attack-missile-tlam','1,000 lb (450 kg) unitary warhead',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(56,'project-22350','1x 130mm A-192M gun, UKSK VLS (Kalibr/Oniks/Zircon), Redut VLS SAMs, Paket-NK torpedoes, Palash CIWS','cannon',130.0,1,NULL,NULL);
INSERT INTO "armaments" VALUES(57,'ddg-51-arleigh-burke-class-guided-missile-destroyer','Mk 41 VLS (90-96 cells: Tomahawk, SM-2/3/6/ESSM, ASROC)',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(58,'ddg-51-arleigh-burke-class-guided-missile-destroyer','Mk 45 5-in gun','cannon',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(59,'ddg-51-arleigh-burke-class-guided-missile-destroyer','torpedoes','torpedo',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(60,'ddg-51-arleigh-burke-class-guided-missile-destroyer','CIWS',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(61,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','1x OTO Melara 76mm gun, SYLVER VLS (Aster 15/30, MdCN/SCALP), Exocet/Teseo A/S, MU90 torpedoes, NH90','cannon',76.0,1,NULL,NULL);
INSERT INTO "armaments" VALUES(62,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','[Military Factory](https://www.militaryfactory.com/ships/detail.php?ship_id=fremm-multipurpose-friga',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(63,'btiment-de-projection-et-de-commandement-bpc','2x Simbad Mistral SAM, 2x 20mm guns, 4x 12.7mm MG, 2x miniguns','cannon',20.0,2,NULL,NULL);
INSERT INTO "armaments" VALUES(64,'cvn-68-class-nuclear-powered-aircraft-carrier','RIM-7/162 Sea Sparrow missiles (2–3 launchers), Phalanx CIWS (3–4), RAM (later ships), aircraft (60+','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(65,'ohio-class','SSBN: 20 Trident II D5 SLBMs, Mk 48 torpedoes (4x 533mm tubes)','torpedo',533.0,4,NULL,NULL);
INSERT INTO "armaments" VALUES(66,'ohio-class','SSGN: 154 Tomahawk missiles, Mk 48 torpedoes','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(67,'type-055-destroyer','112 VLS cells (HHQ-9 SAM, YJ-18A ASM, CJ-10 LACM, ASW)','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(68,'type-055-destroyer','H/PJ-38 130mm gun','cannon',130.0,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(69,'type-055-destroyer','HHQ-10 SAM','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(70,'type-055-destroyer','CIWS',NULL,NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(71,'type-055-destroyer','torpedoes','torpedo',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(72,'type-26-city-class-frigate','1x 127mm Mk 45 gun','cannon',127.0,1,NULL,NULL);
INSERT INTO "armaments" VALUES(73,'type-26-city-class-frigate','48x Sea Ceptor CAMM',NULL,NULL,48,NULL,NULL);
INSERT INTO "armaments" VALUES(74,'type-26-city-class-frigate','24x Mk 41 VLS',NULL,NULL,24,NULL,NULL);
INSERT INTO "armaments" VALUES(75,'type-26-city-class-frigate','2x Phalanx CIWS',NULL,NULL,2,NULL,NULL);
INSERT INTO "armaments" VALUES(76,'type-26-city-class-frigate','2x 30mm guns','cannon',30.0,2,NULL,NULL);
INSERT INTO "armaments" VALUES(77,'ssn-774-class','12-40 Tomahawk missiles, Mk 48 torpedoes (4 tubes), Harpoon, mines','missile',NULL,NULL,NULL,NULL);
INSERT INTO "armaments" VALUES(78,'ddg-1000-class-guided-missile-destroyer','80 x PVLS cells (Tomahawk, ESSM, etc.)',NULL,NULL,80,NULL,NULL);
INSERT INTO "armaments" VALUES(79,'ddg-1000-class-guided-missile-destroyer','2 x 30mm guns','cannon',30.0,2,NULL,NULL);
CREATE TABLE categories (
    category_id     TEXT PRIMARY KEY,           -- 'air', 'land', 'sea', 'munition'
    category_name   TEXT NOT NULL,
    description     TEXT
);
INSERT INTO "categories" VALUES('air','Air','Fixed-wing aircraft, rotorcraft, and unmanned aerial systems');
INSERT INTO "categories" VALUES('land','Land','Ground combat vehicles, artillery, and infantry systems');
INSERT INTO "categories" VALUES('sea','Sea','Naval vessels including surface combatants and submarines');
INSERT INTO "categories" VALUES('munition','Munition','Missiles, bombs, torpedoes, mines, and ammunition');
CREATE TABLE changelog (
    change_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    table_name              TEXT NOT NULL,
    field_name              TEXT NOT NULL,
    old_value               TEXT,
    new_value               TEXT,
    changed_by              TEXT DEFAULT 'system',
    change_reason           TEXT,
    changed_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE conflicts (
    conflict_id             TEXT PRIMARY KEY,        -- 'gulf-war-1991', 'ukraine-2022'
    conflict_name           TEXT NOT NULL,
    start_year              INTEGER NOT NULL,
    end_year                INTEGER,                 -- NULL if ongoing
    region                  TEXT,
    description             TEXT
);
INSERT INTO "conflicts" VALUES('wwii-1939','World War II',1939,1945,'Global','Global conflict');
INSERT INTO "conflicts" VALUES('korea-1950','Korean War',1950,1953,'Korean Peninsula',NULL);
INSERT INTO "conflicts" VALUES('vietnam-1955','Vietnam War',1955,1975,'Southeast Asia',NULL);
INSERT INTO "conflicts" VALUES('yom-kippur-1973','Yom Kippur War',1973,1973,'Middle East',NULL);
INSERT INTO "conflicts" VALUES('falklands-1982','Falklands War',1982,1982,'South Atlantic',NULL);
INSERT INTO "conflicts" VALUES('iran-iraq-1980','Iran-Iraq War',1980,1988,'Middle East',NULL);
INSERT INTO "conflicts" VALUES('gulf-war-1991','Gulf War (Desert Storm)',1991,1991,'Middle East',NULL);
INSERT INTO "conflicts" VALUES('balkans-1991','Yugoslav Wars',1991,2001,'Balkans',NULL);
INSERT INTO "conflicts" VALUES('afghanistan-2001','War in Afghanistan',2001,2021,'Central Asia',NULL);
INSERT INTO "conflicts" VALUES('iraq-2003','Iraq War',2003,2011,'Middle East',NULL);
INSERT INTO "conflicts" VALUES('libya-2011','Libyan Civil War',2011,2020,'North Africa',NULL);
INSERT INTO "conflicts" VALUES('syria-2011','Syrian Civil War',2011,NULL,'Middle East',NULL);
INSERT INTO "conflicts" VALUES('ukraine-2022','Russo-Ukrainian War',2022,NULL,'Eastern Europe',NULL);
INSERT INTO "conflicts" VALUES('nagorno-karabakh-2020','Nagorno-Karabakh War',2020,2020,'South Caucasus',NULL);
INSERT INTO "conflicts" VALUES('gaza-2023','Israel-Hamas War',2023,NULL,'Middle East',NULL);
INSERT INTO "conflicts" VALUES('indo-pak-1971','Indo-Pakistani War',1971,1971,'South Asia',NULL);
INSERT INTO "conflicts" VALUES('six-day-1967','Six-Day War',1967,1967,'Middle East',NULL);
CREATE TABLE countries (
    country_code    TEXT PRIMARY KEY,           -- ISO 3166-1 alpha-2
    country_name    TEXT NOT NULL,
    region          TEXT                         -- 'NATO', 'Asia-Pacific', etc.
);
INSERT INTO "countries" VALUES('US','United States','NATO');
INSERT INTO "countries" VALUES('RU','Russia','CIS');
INSERT INTO "countries" VALUES('CN','China','Asia-Pacific');
INSERT INTO "countries" VALUES('GB','United Kingdom','NATO');
INSERT INTO "countries" VALUES('FR','France','NATO');
INSERT INTO "countries" VALUES('DE','Germany','NATO');
INSERT INTO "countries" VALUES('IL','Israel','Middle East');
INSERT INTO "countries" VALUES('IN','India','South Asia');
INSERT INTO "countries" VALUES('JP','Japan','Asia-Pacific');
INSERT INTO "countries" VALUES('KR','South Korea','Asia-Pacific');
INSERT INTO "countries" VALUES('TR','Turkey','NATO');
INSERT INTO "countries" VALUES('IT','Italy','NATO');
INSERT INTO "countries" VALUES('SE','Sweden','NATO');
INSERT INTO "countries" VALUES('UA','Ukraine','Europe');
INSERT INTO "countries" VALUES('AU','Australia','Asia-Pacific');
INSERT INTO "countries" VALUES('TW','Taiwan','Asia-Pacific');
INSERT INTO "countries" VALUES('SA','Saudi Arabia','Middle East');
INSERT INTO "countries" VALUES('PK','Pakistan','South Asia');
INSERT INTO "countries" VALUES('BR','Brazil','South America');
INSERT INTO "countries" VALUES('EG','Egypt','Middle East');
INSERT INTO "countries" VALUES('PL','Poland','NATO');
INSERT INTO "countries" VALUES('ES','Spain','NATO');
INSERT INTO "countries" VALUES('NL','Netherlands','NATO');
INSERT INTO "countries" VALUES('NO','Norway','NATO');
INSERT INTO "countries" VALUES('GR','Greece','NATO');
INSERT INTO "countries" VALUES('SU','Soviet Union','Historical');
INSERT INTO "countries" VALUES('CS','Czechoslovakia','Historical');
INSERT INTO "countries" VALUES('IR','Iran','Middle East');
INSERT INTO "countries" VALUES('KP','North Korea','Asia-Pacific');
INSERT INTO "countries" VALUES('ZA','South Africa','Africa');
CREATE TABLE economics (
    econ_id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL UNIQUE REFERENCES platforms(platform_id),

    unit_cost_usd           REAL,                   -- flyaway/unit cost in current USD
    unit_cost_year          INTEGER,                -- year of the cost figure
    unit_cost_adjusted_2024 REAL,                   -- inflation-adjusted to 2024 USD
    program_cost_usd        REAL,                   -- total program/development cost
    program_cost_year       INTEGER,
    development_cost_usd    REAL,                   -- R&D only
    maintenance_cost_per_hour REAL,                 -- cost per flight/operational hour
    cost_per_round_usd      REAL,                   -- munitions only
    cost_notes              TEXT,                    -- caveats, variant differences

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "economics" VALUES(1,'ah-64e-apache-guardian',35000000.0,NULL,NULL,64.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(2,'northrop-b-2-spirit',1157000000.0,1998,2230241717.79,44750000000.0,NULL,NULL,135000.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(3,'c-17a-globemaster-iii',202300000.0,1998,389954969.33,NULL,NULL,NULL,24000.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(4,'boeing-ch-47-chinook',38.0,NULL,NULL,NULL,NULL,NULL,6000.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(5,'eurofighter-ef-2000-typhoon',100000000.0,NULL,NULL,37000000000.0,NULL,NULL,70000.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(6,'general-dynamics-f-16-fighting-falcon',18800000.0,1998,36239018.4,NULL,NULL,NULL,7000.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(7,'f-22a',143000000.0,2009,209466666.67,67300000000.0,NULL,NULL,59116.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(8,'f-35a',82500000.0,2024,82500000.0,406500000000.0,NULL,NULL,35000.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(9,'boeing-fa-18e-super-hornet',67400000.0,NULL,NULL,4880000000.0,NULL,NULL,24000.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(10,'chengdu-j-20-20',100000000.0,2022,107345404.85,30000000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(11,'kamov-ka-52',16000000.0,2023,16498851.33,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(12,'mq-9a-reaper',30.0,2024,30.0,7400000000.0,NULL,NULL,3700.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(13,'dassault-rafale',130000000.0,2010,187281063.73,NULL,NULL,NULL,16500.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(14,'sukhoi-su-57',50.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(15,'sikorsky-uh-60-black-hawk',20000000.0,NULL,NULL,22600000000.0,NULL,NULL,6000.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(16,'boevaya-mashina-pekhoty-3-bmp-3',2000000.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(17,'fv4034-challenger-2',6500000.0,1999,12185560.86,1300000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(18,'m142-high-mobility-artillery-rocket-system',4900000.0,2024,4900000.0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(19,'iron-dome-kippat-barzel',100.0,NULL,NULL,2.6,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(20,'k2-k-2-heukpyo',8500000.0,2009,12450815.85,400000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(21,'leopard-2a7',16000000.0,2023,16498851.33,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(22,'m1a2-system-enhancement-package-main-battle-tank',4.3,NULL,NULL,4.6,NULL,NULL,15.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(23,'infantry-fighting-vehicle-m2-bradley',3166000.0,2000,5776754.94,5700000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(24,'panzerhaubitze-2000',17000000.0,2022,18248718.82,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(25,'mim-104f',4000000.0,2025,NULL,9800000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(26,'s-300-series-eg-s-300p-s-300v',300000000.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(27,'s-400-triumf',200000000.0,NULL,NULL,5430000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(28,'m1126-infantry-carrier-vehicle',4900000.0,2012,6705487.8,8000000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(29,'object-148',5.0,2015,6.63,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(30,'t-72-ural-object-172m',1200000.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(31,'aim-120-advanced-medium-range-air-to-air-missile',386000.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(32,'agm-84-rgm-84-ugm-84-harpoon',1.2,2015,1.59,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(33,'agm-114-hellfire',99600.0,2015,132043.54,7200000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(34,'gbu-313238-series',25000.0,2024,25000.0,10.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(35,'fgm-148-javelin',175000.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(36,'3m-543m-14-kalibr',6.5,2006,10.13,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(37,'gbu-43b-massive-ordnance-air-blast',170000.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(38,'scalp-eg-france-storm-shadow-uk',2000000.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(39,'bgm-109-tomahawk-land-attack-missile-tlam',2400000.0,NULL,NULL,11210000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(40,'project-22350',250000000.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(41,'ddg-51-arleigh-burke-class-guided-missile-destroyer',2500000000.0,2025,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(42,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq',760000000.0,2014,1008838191.8,12.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(43,'btiment-de-projection-et-de-commandement-bpc',950000000.0,2015,1259451476.79,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(44,'cvn-68-class-nuclear-powered-aircraft-carrier',4500000000.0,2009,6591608391.61,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(45,'ohio-class',2000000000.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(46,'type-26-city-class-frigate',1000000000.0,2017,1281925744.59,8000000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(47,'ssn-774-class',4300000000.0,2023,4434066294.72,347000000000.0,NULL,NULL,50000000.0,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "economics" VALUES(48,'ddg-1000-class-guided-missile-destroyer',4200000000.0,NULL,NULL,24000000000.0,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
CREATE TABLE media (
    media_id                INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    media_type              TEXT NOT NULL,            -- 'image', 'diagram', 'video', 'document'
    media_subtype           TEXT,                     -- 'profile', 'top-down', 'interior', 'action'
    url                     TEXT NOT NULL,
    local_path              TEXT,                     -- path in /images/ if downloaded
    caption                 TEXT,
    attribution             TEXT,                     -- photographer/source credit
    license                 TEXT,                     -- 'public-domain', 'cc-by-sa-4.0', etc.
    source_url              TEXT,                     -- page where media was found
    width_px                INTEGER,
    height_px               INTEGER,
    downloaded              BOOLEAN DEFAULT FALSE,
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "media" VALUES(1,'ah-64e-apache-guardian','image','profile','https://upload.wikimedia.org/wikipedia/commons/9/99/Boeing_AH-64D_Apache_06.jpg',NULL,'AH-64 Apache','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(2,'northrop-b-2-spirit','image','profile','https://upload.wikimedia.org/wikipedia/commons/7/77/B-2_Spirit_2.jpg',NULL,'B-2 Spirit','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(3,'c-17a-globemaster-iii','image','profile','https://upload.wikimedia.org/wikipedia/commons/a/a4/C-17_Globemaster_III_3.jpg',NULL,'C-17 Globemaster III','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(4,'boeing-ch-47-chinook','image','profile','https://upload.wikimedia.org/wikipedia/commons/0/03/CH-47_Chinook_helicopter_flyby.jpg',NULL,'CH-47 Chinook','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(5,'eurofighter-ef-2000-typhoon','image','profile','https://upload.wikimedia.org/wikipedia/commons/d/dd/Eurofighter_EF-2000_Typhoon.jpg',NULL,'Eurofighter Typhoon','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(6,'general-dynamics-f-16-fighting-falcon','image','profile','https://upload.wikimedia.org/wikipedia/commons/d/d5/Defense.gov_News_Photo_070720-F-5502S-003.jpg',NULL,'F-16 Fighting Falcon','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(7,'f-22a','image','profile','https://upload.wikimedia.org/wikipedia/commons/4/46/Lockheed_Martin_F-22A_Raptor_JSOH.jpg',NULL,'F-22 Raptor','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(8,'f-35a','image','profile','https://upload.wikimedia.org/wikipedia/commons/1/1d/Lockheed_Martin_F-35_%22Lightning_II%22.jpg',NULL,'F-35A Lightning II','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(9,'boeing-fa-18e-super-hornet','image','profile','https://upload.wikimedia.org/wikipedia/commons/d/de/US_Navy_071203-N-8923M-074_An_F-A-18F_Super_Hornet%2C_from_the_Red_Rippers_of_Strike_Fighter_Squadron_%28VFA%29_11%2C_makes_a_sharp_turn_above_the_flight_deck_aboard_the_Nimitz-class_nuclear-powered_aircraft_carrier_USS_Harry_S._Truman.jpg',NULL,'F/A-18E Super Hornet','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(10,'chengdu-j-20-20','image','profile','https://upload.wikimedia.org/wikipedia/commons/a/a2/J-20_at_Airshow_China_2016.jpg',NULL,'J-20 Mighty Dragon','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(11,'kamov-ka-52','image','profile','https://upload.wikimedia.org/wikipedia/commons/0/0c/Russian_Air_Force_Kamov_Ka-50.jpg',NULL,'Ka-52 Alligator','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(12,'mq-9a-reaper','image','profile','https://upload.wikimedia.org/wikipedia/commons/e/ea/MQ-9A_Reaper.jpg',NULL,'MQ-9 Reaper','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(13,'dassault-rafale','image','profile','https://upload.wikimedia.org/wikipedia/commons/6/64/Rafale_-_RIAT_2009_%283751416421%29.jpg',NULL,'Rafale','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(14,'sukhoi-su-57','image','profile','https://upload.wikimedia.org/wikipedia/commons/0/0e/Sukhoi_Design_Bureau%2C_054%2C_Sukhoi_T-50_%28Su-57_prototype%29_%2849581303977%29.jpg',NULL,'Su-57 Felon','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(15,'sikorsky-uh-60-black-hawk','image','profile','https://upload.wikimedia.org/wikipedia/commons/8/82/UH-60A_Black_Hawk.jpg',NULL,'UH-60 Black Hawk','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(16,'boevaya-mashina-pekhoty-3-bmp-3','image','profile','https://upload.wikimedia.org/wikipedia/commons/0/04/Army2016demo-011.jpg',NULL,'BMP-3','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(17,'fv4034-challenger-2','image','profile','https://upload.wikimedia.org/wikipedia/commons/3/30/Challenger_2_Main_Battle_Tank_patrolling_outside_Basra%2C_Iraq_MOD_45148325.jpg',NULL,'Challenger 2','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(18,'m142-high-mobility-artillery-rocket-system','image','profile','https://upload.wikimedia.org/wikipedia/commons/1/1c/M142_himars.jpg',NULL,'HIMARS M142','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(19,'iron-dome-kippat-barzel','image','profile','https://upload.wikimedia.org/wikipedia/commons/0/08/IDF_Iron_Dome_2021.jpg',NULL,'Iron Dome','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(20,'k2-k-2-heukpyo','image','profile','https://commons.wikimedia.org/wiki/File:K2_Black_Panther_(15373704976)_(cropped).jpg',NULL,'K2 Black Panther','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(21,'leopard-2a7','image','profile','https://upload.wikimedia.org/wikipedia/commons/a/a7/Leopard_2_A7V_313_Bad_Frankenhausen_2024.JPG',NULL,'Leopard 2A7','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(22,'m109a6-paladin','image','profile','https://upload.wikimedia.org/wikipedia/commons/3/3a/Kings_of_battle_keep_the_fire%3B_1-9_FA_fires_its_last_rounds_140910-A-CW513-046.jpg',NULL,'M109 Paladin','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(23,'m1a2-system-enhancement-package-main-battle-tank','image','profile','https://upload.wikimedia.org/wikipedia/commons/4/48/M1A2_Abrams%2C_August_14%2C_2014.JPG',NULL,'M1A2 Abrams','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(24,'infantry-fighting-vehicle-m2-bradley','image','profile','https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/M2_Bradley.jpg/960px-M2_Bradley.jpg',NULL,'M2 Bradley','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(25,'panzerhaubitze-2000','image','profile','https://upload.wikimedia.org/wikipedia/commons/3/37/Panzerhaubitze_2000.jpg',NULL,'Panzerhaubitze 2000','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(26,'mim-104f','image','profile','https://upload.wikimedia.org/wikipedia/commons/1/12/PATRIOT_PAC-3_MSE.png',NULL,'Patriot PAC-3','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(27,'s-300-series-eg-s-300p-s-300v','image','profile','https://upload.wikimedia.org/wikipedia/commons/e/e5/S-300_-_2009_Moscow_Victory_Day_Parade_%282%29.jpg',NULL,'S-300','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(28,'s-400-triumf','image','profile','https://upload.wikimedia.org/wikipedia/commons/2/2c/Russian_S-400_Triumf_missile_launcher.jpg',NULL,'S-400 Triumf','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(29,'m1126-infantry-carrier-vehicle','image','profile','https://upload.wikimedia.org/wikipedia/commons/c/c3/M1126_STRYKER_IFV.png',NULL,'Stryker ICV','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(30,'object-148','image','profile','https://upload.wikimedia.org/wikipedia/commons/d/dd/14T_Armata.jpg',NULL,'T-14 Armata','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(31,'t-72-ural-object-172m','image','profile','https://upload.wikimedia.org/wikipedia/commons/4/46/Tank_T-72.JPG',NULL,'T-72','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(32,'aim-120-advanced-medium-range-air-to-air-missile','image','profile','https://upload.wikimedia.org/wikipedia/commons/a/a0/20180328_AIM-120_Udvar-Hazy.jpg',NULL,'AIM-120 AMRAAM','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(33,'agm-84-rgm-84-ugm-84-harpoon','image','profile','https://upload.wikimedia.org/wikipedia/commons/2/2b/USS_Badger_%28FF-1071%29_Launching_Harpoon.jpg',NULL,'Harpoon','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(34,'agm-114-hellfire','image','profile','https://upload.wikimedia.org/wikipedia/commons/1/1b/Lockheed_Martin_Longbow_Hellfire.jpg',NULL,'Hellfire','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(35,'gbu-313238-series','image','profile','https://upload.wikimedia.org/wikipedia/commons/9/9b/Jdam_gps_guided_bomb.jpg',NULL,'JDAM (Joint Direct Attack Munition)','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(36,'fgm-148-javelin','image','profile','https://upload.wikimedia.org/wikipedia/commons/1/1b/FGM-148_Javelin_missile_launch.jpg',NULL,'Javelin','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(37,'3m-543m-14-kalibr','image','profile','https://upload.wikimedia.org/wikipedia/commons/3/38/3M-54E1.jpg',NULL,'Kalibr','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(38,'gbu-43b-massive-ordnance-air-blast','image','profile','https://upload.wikimedia.org/wikipedia/commons/4/42/MOABAFAM.JPG',NULL,'Mother of All Bombs (MOAB)','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(39,'scalp-eg-france-storm-shadow-uk','image','profile','https://upload.wikimedia.org/wikipedia/commons/3/3f/RAF_Museum%2C_Colindale%2C_London_-_DSC06025.JPG',NULL,'Storm Shadow / SCALP','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(40,'bgm-109-tomahawk-land-attack-missile-tlam','image','profile','https://upload.wikimedia.org/wikipedia/commons/e/e8/Tomahawk_Block_IV_cruise_missile_-crop.jpg',NULL,'Tomahawk','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(41,'project-22350','image','profile','https://upload.wikimedia.org/wikipedia/commons/a/a6/Admiral_Gorshkov_frigate_02.jpg https://upload.wikimedia.org/wikipedia/commons/a/a6/Admiral_Gorshkov_frigate_02.jpg',NULL,'Admiral Gorshkov-class frigate','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(42,'ddg-51-arleigh-burke-class-guided-missile-destroyer','image','profile','https://upload.wikimedia.org/wikipedia/commons/9/93/USS_Arleigh_Burke_%28DDG_51%29_steams_through_the_Mediterranean_Sea.jpg',NULL,'Arleigh Burke-class destroyer','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(43,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','image','profile','https://upload.wikimedia.org/wikipedia/commons/5/54/Nave_Bergamini_3.JPG',NULL,'FREMM multipurpose frigate','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(44,'btiment-de-projection-et-de-commandement-bpc','image','profile','https://commons.wikimedia.org/wiki/File:Bloody-Mistrals-2015022.jpg',NULL,'Mistral class','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(45,'cvn-68-class-nuclear-powered-aircraft-carrier','image','profile','https://upload.wikimedia.org/wikipedia/commons/8/81/USS_Nimitz_in_Victoria_Canada_036.jpg',NULL,'Nimitz-class aircraft carrier','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(46,'ohio-class','image','profile','https://upload.wikimedia.org/wikipedia/commons/e/e9/Ohio_class_submarine.jpg',NULL,'Ohio-class submarine','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(47,'type-055-destroyer','image','profile','https://upload.wikimedia.org/wikipedia/commons/1/1d/Type_055_destroyer.jpg',NULL,'Type 055 Renhai','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(48,'type-26-city-class-frigate','image','profile','https://upload.wikimedia.org/wikipedia/commons/5/5e/Type_26_frigate.jpg',NULL,'Type 26 frigate','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(49,'ssn-774-class','image','profile','https://upload.wikimedia.org/wikipedia/commons/b/bb/US_Navy_040730-N-1234E-002_PCU_Virginia_%28SSN_774%29_returns_to_the_General_Dynamics_Electric_Boat_shipyard.jpg',NULL,'Virginia-class submarine','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
INSERT INTO "media" VALUES(50,'ddg-1000-class-guided-missile-destroyer','image','profile','https://upload.wikimedia.org/wikipedia/commons/9/9a/USS_Zumwalt_%28DDG_1000%29.jpg',NULL,'Zumwalt destroyer','Wikimedia Commons','cc-by-sa-4.0',NULL,NULL,NULL,0,'2026-03-11 02:10:08');
CREATE TABLE operators (
    operator_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    country_code            TEXT NOT NULL REFERENCES countries(country_code),
    quantity                INTEGER,
    quantity_approx         BOOLEAN DEFAULT FALSE,
    service_entry_year      INTEGER,
    retirement_year         INTEGER,                 -- NULL if still active
    variant                 TEXT,                    -- specific variant operated
    branch                  TEXT,                    -- 'Air Force', 'Navy', 'Army', etc.
    notes                   TEXT,

    UNIQUE(platform_id, country_code, variant, branch)
);
INSERT INTO "operators" VALUES(1,'ah-64e-apache-guardian','US',750,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(2,'ah-64e-apache-guardian','IL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(3,'ah-64e-apache-guardian','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(4,'ah-64e-apache-guardian','NL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(5,'ah-64e-apache-guardian','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(6,'ah-64e-apache-guardian','IN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(7,'ah-64e-apache-guardian','EG',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(8,'northrop-b-2-spirit','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(9,'c-17a-globemaster-iii','US',222,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(10,'c-17a-globemaster-iii','GB',8,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(11,'c-17a-globemaster-iii','US',8,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(12,'c-17a-globemaster-iii','US',5,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(13,'c-17a-globemaster-iii','IN',11,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(14,'c-17a-globemaster-iii','SA',8,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(15,'c-17a-globemaster-iii','SA',8,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(16,'c-17a-globemaster-iii','SA',2,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(17,'c-17a-globemaster-iii','XX',3,0,NULL,NULL,NULL,NULL,'NATO');
INSERT INTO "operators" VALUES(18,'boeing-ch-47-chinook','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(19,'boeing-ch-47-chinook','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(20,'boeing-ch-47-chinook','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(21,'boeing-ch-47-chinook','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(22,'boeing-ch-47-chinook','IN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(23,'boeing-ch-47-chinook','JP',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(24,'boeing-ch-47-chinook','NL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(25,'boeing-ch-47-chinook','DE',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(26,'eurofighter-ef-2000-typhoon','GB',111,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(27,'eurofighter-ef-2000-typhoon','DE',138,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(28,'eurofighter-ef-2000-typhoon','IT',93,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(29,'eurofighter-ef-2000-typhoon','ES',69,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(30,'eurofighter-ef-2000-typhoon','SA',71,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(31,'eurofighter-ef-2000-typhoon','SA',12,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(32,'eurofighter-ef-2000-typhoon','SA',15,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(33,'eurofighter-ef-2000-typhoon','SA',22,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(34,'eurofighter-ef-2000-typhoon','US',15,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(35,'general-dynamics-f-16-fighting-falcon','US',1000,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(36,'general-dynamics-f-16-fighting-falcon','TR',232,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(37,'general-dynamics-f-16-fighting-falcon','IL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(38,'general-dynamics-f-16-fighting-falcon','TW',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(39,'general-dynamics-f-16-fighting-falcon','KR',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(40,'general-dynamics-f-16-fighting-falcon','GR',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(41,'general-dynamics-f-16-fighting-falcon','PL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(42,'general-dynamics-f-16-fighting-falcon','EG',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(43,'general-dynamics-f-16-fighting-falcon','PK',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(44,'general-dynamics-f-16-fighting-falcon','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(45,'f-22a','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(46,'f-35a','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(47,'f-35a','US',72,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(48,'f-35a','IL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(49,'f-35a','JP',105,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(50,'f-35a','NL',58,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(51,'f-35a','NO',52,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(52,'f-35a','IT',75,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(53,'f-35a','KR',60,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(54,'f-35a','PL',32,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(55,'boeing-fa-18e-super-hornet','US',NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(56,'boeing-fa-18e-super-hornet','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(57,'boeing-fa-18e-super-hornet','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(58,'kamov-ka-52','US',140,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(59,'kamov-ka-52','EG',46,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(60,'mq-9a-reaper','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(61,'mq-9a-reaper','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(62,'mq-9a-reaper','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(63,'mq-9a-reaper','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(64,'mq-9a-reaper','AU',16,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(65,'mq-9a-reaper','IT',6,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(66,'mq-9a-reaper','IN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(67,'mq-9a-reaper','NL',8,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(68,'dassault-rafale','AU',165,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(69,'dassault-rafale','EG',54,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(70,'dassault-rafale','IN',36,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(71,'dassault-rafale','SA',36,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(72,'dassault-rafale','GR',24,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(73,'dassault-rafale','PL',12,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(74,'dassault-rafale','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(75,'sukhoi-su-57','US',40,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(76,'sikorsky-uh-60-black-hawk','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(77,'sikorsky-uh-60-black-hawk','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(78,'sikorsky-uh-60-black-hawk','KR',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(79,'sikorsky-uh-60-black-hawk','TR',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(80,'boevaya-mashina-pekhoty-3-bmp-3','US',700,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(81,'boevaya-mashina-pekhoty-3-bmp-3','SA',390,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(82,'boevaya-mashina-pekhoty-3-bmp-3','EG',300,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(83,'boevaya-mashina-pekhoty-3-bmp-3','SA',225,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(84,'boevaya-mashina-pekhoty-3-bmp-3','XX',123,0,NULL,NULL,NULL,NULL,'Venezuela');
INSERT INTO "operators" VALUES(85,'boevaya-mashina-pekhoty-3-bmp-3','XX',118,0,NULL,NULL,NULL,NULL,'Azerbaijan');
INSERT INTO "operators" VALUES(86,'boevaya-mashina-pekhoty-3-bmp-3','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(87,'boevaya-mashina-pekhoty-3-bmp-3','KR',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(88,'fv4034-challenger-2','GB',227,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(89,'fv4034-challenger-2','SA',38,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(90,'fv4034-challenger-2','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(91,'m142-high-mobility-artillery-rocket-system','US',368,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(92,'m142-high-mobility-artillery-rocket-system','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(93,'m142-high-mobility-artillery-rocket-system','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(94,'m142-high-mobility-artillery-rocket-system','PL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(95,'m142-high-mobility-artillery-rocket-system','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(96,'m142-high-mobility-artillery-rocket-system','TW',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(97,'m142-high-mobility-artillery-rocket-system','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(98,'m142-high-mobility-artillery-rocket-system','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(99,'iron-dome-kippat-barzel','IL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(100,'iron-dome-kippat-barzel','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(101,'iron-dome-kippat-barzel','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(102,'k2-k-2-heukpyo','KR',260,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(103,'k2-k-2-heukpyo','PL',180,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(104,'leopard-2a7','DE',NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(105,'leopard-2a7','SA',NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(106,'leopard-2a7','NO',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(107,'m109a6-paladin','US',NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(108,'m109a6-paladin','GB',90,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(109,'m109a6-paladin','GR',418,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(110,'m109a6-paladin','XX',358,0,NULL,NULL,NULL,NULL,'Jordan');
INSERT INTO "operators" VALUES(111,'m109a6-paladin','IL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(112,'m109a6-paladin','EG',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(113,'m109a6-paladin','KR',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(114,'m109a6-paladin','TW',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(115,'m1a2-system-enhancement-package-main-battle-tank','US',2500,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(116,'m1a2-system-enhancement-package-main-battle-tank','US',75,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(117,'m1a2-system-enhancement-package-main-battle-tank','SA',218,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(118,'m1a2-system-enhancement-package-main-battle-tank','PL',250,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(119,'m1a2-system-enhancement-package-main-battle-tank','XX',575,0,NULL,NULL,NULL,NULL,'KSA');
INSERT INTO "operators" VALUES(120,'m1a2-system-enhancement-package-main-battle-tank','TW',108,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(121,'infantry-fighting-vehicle-m2-bradley','US',4000,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(122,'infantry-fighting-vehicle-m2-bradley','GB',300,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(123,'infantry-fighting-vehicle-m2-bradley','SA',400,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(124,'infantry-fighting-vehicle-m2-bradley','PL',89,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(125,'infantry-fighting-vehicle-m2-bradley','XX',32,0,NULL,NULL,NULL,NULL,'Lebanon');
INSERT INTO "operators" VALUES(126,'panzerhaubitze-2000','DE',139,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(127,'panzerhaubitze-2000','IT',64,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(128,'panzerhaubitze-2000','NL',49,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(129,'panzerhaubitze-2000','GB',39,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(130,'panzerhaubitze-2000','GR',25,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(131,'panzerhaubitze-2000','XX',23,0,NULL,NULL,NULL,NULL,'Hungary');
INSERT INTO "operators" VALUES(132,'panzerhaubitze-2000','XX',21,0,NULL,NULL,NULL,NULL,'Lithuania');
INSERT INTO "operators" VALUES(133,'panzerhaubitze-2000','SA',24,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(134,'panzerhaubitze-2000','PL',16,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(135,'mim-104f','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(136,'mim-104f','DE',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(137,'mim-104f','JP',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(138,'mim-104f','NL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(139,'mim-104f','IL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(140,'mim-104f','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(141,'mim-104f','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(142,'mim-104f','PL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(143,'mim-104f','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(144,'mim-104f','SE',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(145,'s-300-series-eg-s-300p-s-300v','US',NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(146,'s-300-series-eg-s-300p-s-300v','CN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(147,'s-300-series-eg-s-300p-s-300v','AU',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(148,'s-300-series-eg-s-300p-s-300v','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(149,'s-400-triumf','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(150,'s-400-triumf','CN',NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(151,'s-400-triumf','IN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(152,'s-400-triumf','TR',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(153,'s-400-triumf','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(154,'m1126-infantry-carrier-vehicle','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(155,'m1126-infantry-carrier-vehicle','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(156,'m1126-infantry-carrier-vehicle','EG',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(157,'object-148','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(158,'t-72-ural-object-172m','US',12000,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(159,'t-72-ural-object-172m','IN',2400,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(160,'t-72-ural-object-172m','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(161,'t-72-ural-object-172m','PL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(162,'aim-120-advanced-medium-range-air-to-air-missile','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(163,'aim-120-advanced-medium-range-air-to-air-missile','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(164,'aim-120-advanced-medium-range-air-to-air-missile','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(165,'aim-120-advanced-medium-range-air-to-air-missile','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(166,'aim-120-advanced-medium-range-air-to-air-missile','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(167,'aim-120-advanced-medium-range-air-to-air-missile','DE',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(168,'aim-120-advanced-medium-range-air-to-air-missile','JP',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(169,'aim-120-advanced-medium-range-air-to-air-missile','NL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(170,'aim-120-advanced-medium-range-air-to-air-missile','NO',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(171,'aim-120-advanced-medium-range-air-to-air-missile','PK',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(172,'agm-84-rgm-84-ugm-84-harpoon','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(173,'agm-84-rgm-84-ugm-84-harpoon','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(174,'agm-84-rgm-84-ugm-84-harpoon','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(175,'agm-84-rgm-84-ugm-84-harpoon','JP',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(176,'agm-84-rgm-84-ugm-84-harpoon','KR',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(177,'agm-84-rgm-84-ugm-84-harpoon','IN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(178,'agm-84-rgm-84-ugm-84-harpoon','IL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(179,'agm-84-rgm-84-ugm-84-harpoon','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(180,'agm-114-hellfire','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(181,'agm-114-hellfire','IL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(182,'agm-114-hellfire','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(183,'agm-114-hellfire','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(184,'agm-114-hellfire','EG',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(185,'agm-114-hellfire','IN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(186,'agm-114-hellfire','EG',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(187,'agm-114-hellfire','NL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(188,'agm-114-hellfire','NO',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(189,'agm-114-hellfire','PK',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(190,'gbu-313238-series','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(191,'gbu-313238-series','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(192,'gbu-313238-series','IL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(193,'gbu-313238-series','NL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(194,'gbu-313238-series','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(195,'fgm-148-javelin','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(196,'fgm-148-javelin','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(197,'fgm-148-javelin','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(198,'fgm-148-javelin','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(199,'fgm-148-javelin','AU',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(200,'fgm-148-javelin','PL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(201,'fgm-148-javelin','NO',NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(202,'3m-543m-14-kalibr','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(203,'3m-543m-14-kalibr','CN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(204,'3m-543m-14-kalibr','IN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(205,'3m-543m-14-kalibr','AU',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(206,'gbu-43b-massive-ordnance-air-blast','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(207,'scalp-eg-france-storm-shadow-uk','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(208,'scalp-eg-france-storm-shadow-uk','AU',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(209,'scalp-eg-france-storm-shadow-uk','IT',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(210,'scalp-eg-france-storm-shadow-uk','EG',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(211,'scalp-eg-france-storm-shadow-uk','GR',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(212,'scalp-eg-france-storm-shadow-uk','IN',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(213,'scalp-eg-france-storm-shadow-uk','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(214,'scalp-eg-france-storm-shadow-uk','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(215,'scalp-eg-france-storm-shadow-uk','SA',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(216,'scalp-eg-france-storm-shadow-uk','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(217,'bgm-109-tomahawk-land-attack-missile-tlam','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(218,'bgm-109-tomahawk-land-attack-missile-tlam','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(219,'bgm-109-tomahawk-land-attack-missile-tlam','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(220,'bgm-109-tomahawk-land-attack-missile-tlam','GB',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(221,'bgm-109-tomahawk-land-attack-missile-tlam','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(222,'bgm-109-tomahawk-land-attack-missile-tlam','NL',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(223,'project-22350','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(224,'ddg-51-arleigh-burke-class-guided-missile-destroyer','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(225,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','AU',8,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(226,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','IT',NULL,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(227,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','EG',3,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(228,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','XX',1,0,NULL,NULL,NULL,NULL,'Morocco');
INSERT INTO "operators" VALUES(229,'btiment-de-projection-et-de-commandement-bpc','AU',3,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(230,'btiment-de-projection-et-de-commandement-bpc','EG',2,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(231,'cvn-68-class-nuclear-powered-aircraft-carrier','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(232,'ohio-class','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(233,'type-26-city-class-frigate','GB',8,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(234,'type-26-city-class-frigate','US',6,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(235,'type-26-city-class-frigate','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(236,'type-26-city-class-frigate','NO',5,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(237,'ssn-774-class','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(238,'ssn-774-class','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "operators" VALUES(239,'ddg-1000-class-guided-missile-destroyer','US',NULL,0,NULL,NULL,NULL,NULL,NULL);
CREATE TABLE platform_conflicts (
    id                      INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    conflict_id             TEXT NOT NULL REFERENCES conflicts(conflict_id),
    role                    TEXT,                     -- 'air superiority', 'CAS', 'convoy escort'
    units_deployed          INTEGER,
    losses                  INTEGER,
    kills                   INTEGER,                  -- air-to-air, vehicle kills, etc.
    notes                   TEXT,
    source_url              TEXT,

    UNIQUE(platform_id, conflict_id, role)
);
INSERT INTO "platform_conflicts" VALUES(1,'ah-64e-apache-guardian','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war (1991)',NULL);
INSERT INTO "platform_conflicts" VALUES(2,'ah-64e-apache-guardian','balkans-1991',NULL,NULL,NULL,NULL,'kosovo',NULL);
INSERT INTO "platform_conflicts" VALUES(3,'ah-64e-apache-guardian','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan (2001-2021)',NULL);
INSERT INTO "platform_conflicts" VALUES(4,'ah-64e-apache-guardian','gaza-2023',NULL,NULL,NULL,NULL,'gaza',NULL);
INSERT INTO "platform_conflicts" VALUES(5,'ah-64e-apache-guardian','syria-2011',NULL,NULL,NULL,NULL,'yemen',NULL);
INSERT INTO "platform_conflicts" VALUES(6,'northrop-b-2-spirit','balkans-1991',NULL,NULL,NULL,NULL,'kosovo war (1999)',NULL);
INSERT INTO "platform_conflicts" VALUES(7,'northrop-b-2-spirit','afghanistan-2001',NULL,NULL,NULL,NULL,'war in afghanistan (2001-)',NULL);
INSERT INTO "platform_conflicts" VALUES(8,'northrop-b-2-spirit','iraq-2003',NULL,NULL,NULL,NULL,'iraq war (2003-)',NULL);
INSERT INTO "platform_conflicts" VALUES(9,'northrop-b-2-spirit','libya-2011',NULL,NULL,NULL,NULL,'libya (2011',NULL);
INSERT INTO "platform_conflicts" VALUES(10,'northrop-b-2-spirit','syria-2011',NULL,NULL,NULL,NULL,'yemen (2024)',NULL);
INSERT INTO "platform_conflicts" VALUES(11,'c-17a-globemaster-iii','afghanistan-2001',NULL,NULL,NULL,NULL,'operation enduring freedom',NULL);
INSERT INTO "platform_conflicts" VALUES(12,'c-17a-globemaster-iii','iraq-2003',NULL,NULL,NULL,NULL,'operation iraqi freedom',NULL);
INSERT INTO "platform_conflicts" VALUES(13,'boeing-ch-47-chinook','vietnam-1955',NULL,NULL,NULL,NULL,'vietnam war',NULL);
INSERT INTO "platform_conflicts" VALUES(14,'boeing-ch-47-chinook','falklands-1982',NULL,NULL,NULL,NULL,'falklands war',NULL);
INSERT INTO "platform_conflicts" VALUES(15,'boeing-ch-47-chinook','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war',NULL);
INSERT INTO "platform_conflicts" VALUES(16,'boeing-ch-47-chinook','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(17,'eurofighter-ef-2000-typhoon','libya-2011',NULL,NULL,NULL,NULL,'libya 2011',NULL);
INSERT INTO "platform_conflicts" VALUES(18,'eurofighter-ef-2000-typhoon','syria-2011',NULL,NULL,NULL,NULL,'operation shader (iraq/syria)',NULL);
INSERT INTO "platform_conflicts" VALUES(19,'eurofighter-ef-2000-typhoon','gaza-2023',NULL,NULL,NULL,NULL,'red sea 2024 [wikipedia](https://en.wikipedia.org/wiki/eurofighter_typhoon)',NULL);
INSERT INTO "platform_conflicts" VALUES(20,'general-dynamics-f-16-fighting-falcon','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war',NULL);
INSERT INTO "platform_conflicts" VALUES(21,'general-dynamics-f-16-fighting-falcon','balkans-1991',NULL,NULL,NULL,NULL,'balkans',NULL);
INSERT INTO "platform_conflicts" VALUES(22,'general-dynamics-f-16-fighting-falcon','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(23,'general-dynamics-f-16-fighting-falcon','libya-2011',NULL,NULL,NULL,NULL,'libya',NULL);
INSERT INTO "platform_conflicts" VALUES(24,'general-dynamics-f-16-fighting-falcon','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war',NULL);
INSERT INTO "platform_conflicts" VALUES(25,'general-dynamics-f-16-fighting-falcon','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war',NULL);
INSERT INTO "platform_conflicts" VALUES(26,'f-22a','syria-2011',NULL,NULL,NULL,NULL,'syria (2014',NULL);
INSERT INTO "platform_conflicts" VALUES(27,'f-22a','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan (2017)',NULL);
INSERT INTO "platform_conflicts" VALUES(28,'f-35a','afghanistan-2001',NULL,NULL,NULL,NULL,'us: afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(29,'f-35a','syria-2011',NULL,NULL,NULL,NULL,'yemen',NULL);
INSERT INTO "platform_conflicts" VALUES(30,'f-35a','gaza-2023',NULL,NULL,NULL,NULL,'gaza',NULL);
INSERT INTO "platform_conflicts" VALUES(31,'boeing-fa-18e-super-hornet','iraq-2003',NULL,NULL,NULL,NULL,'operation iraqi freedom',NULL);
INSERT INTO "platform_conflicts" VALUES(32,'boeing-fa-18e-super-hornet','afghanistan-2001',NULL,NULL,NULL,NULL,'operation enduring freedom (afghanistan)',NULL);
INSERT INTO "platform_conflicts" VALUES(33,'boeing-fa-18e-super-hornet','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war (2017 su-22 shootdown)',NULL);
INSERT INTO "platform_conflicts" VALUES(34,'boeing-fa-18e-super-hornet','gaza-2023',NULL,NULL,NULL,NULL,'red sea operations vs houthis (2023-2025)',NULL);
INSERT INTO "platform_conflicts" VALUES(35,'kamov-ka-52','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war',NULL);
INSERT INTO "platform_conflicts" VALUES(36,'kamov-ka-52','ukraine-2022',NULL,NULL,NULL,NULL,'russian invasion of ukraine',NULL);
INSERT INTO "platform_conflicts" VALUES(37,'mq-9a-reaper','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(38,'mq-9a-reaper','libya-2011',NULL,NULL,NULL,NULL,'libya',NULL);
INSERT INTO "platform_conflicts" VALUES(39,'mq-9a-reaper','syria-2011',NULL,NULL,NULL,NULL,'syria/isis',NULL);
INSERT INTO "platform_conflicts" VALUES(40,'dassault-rafale','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(41,'dassault-rafale','libya-2011',NULL,NULL,NULL,NULL,'libya (2011)',NULL);
INSERT INTO "platform_conflicts" VALUES(42,'dassault-rafale','syria-2011',NULL,NULL,NULL,NULL,'iraq/syria (vs isis)',NULL);
INSERT INTO "platform_conflicts" VALUES(43,'sukhoi-su-57','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war (2018)',NULL);
INSERT INTO "platform_conflicts" VALUES(44,'sukhoi-su-57','ukraine-2022',NULL,NULL,NULL,NULL,'russian invasion of ukraine (2022-present)',NULL);
INSERT INTO "platform_conflicts" VALUES(45,'sikorsky-uh-60-black-hawk','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war 1991',NULL);
INSERT INTO "platform_conflicts" VALUES(46,'sikorsky-uh-60-black-hawk','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(47,'boevaya-mashina-pekhoty-3-bmp-3','balkans-1991',NULL,NULL,NULL,NULL,'first chechen war',NULL);
INSERT INTO "platform_conflicts" VALUES(48,'boevaya-mashina-pekhoty-3-bmp-3','syria-2011',NULL,NULL,NULL,NULL,'yemen civil war (uae)',NULL);
INSERT INTO "platform_conflicts" VALUES(49,'boevaya-mashina-pekhoty-3-bmp-3','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war',NULL);
INSERT INTO "platform_conflicts" VALUES(50,'fv4034-challenger-2','balkans-1991',NULL,NULL,NULL,NULL,'kosovo',NULL);
INSERT INTO "platform_conflicts" VALUES(51,'fv4034-challenger-2','iraq-2003',NULL,NULL,NULL,NULL,'iraq war',NULL);
INSERT INTO "platform_conflicts" VALUES(52,'fv4034-challenger-2','ukraine-2022',NULL,NULL,NULL,NULL,'ukraine (2023-)',NULL);
INSERT INTO "platform_conflicts" VALUES(53,'m142-high-mobility-artillery-rocket-system','iraq-2003',NULL,NULL,NULL,NULL,'iraq war',NULL);
INSERT INTO "platform_conflicts" VALUES(54,'m142-high-mobility-artillery-rocket-system','afghanistan-2001',NULL,NULL,NULL,NULL,'war in afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(55,'m142-high-mobility-artillery-rocket-system','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war',NULL);
INSERT INTO "platform_conflicts" VALUES(56,'m142-high-mobility-artillery-rocket-system','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war',NULL);
INSERT INTO "platform_conflicts" VALUES(57,'iron-dome-kippat-barzel','gaza-2023',NULL,NULL,NULL,NULL,'gaza conflicts (2011-2025)',NULL);
INSERT INTO "platform_conflicts" VALUES(58,'leopard-2a7','afghanistan-2001',NULL,NULL,NULL,NULL,'none (precursor variants in afghanistan)',NULL);
INSERT INTO "platform_conflicts" VALUES(59,'m109a6-paladin','vietnam-1955',NULL,NULL,NULL,NULL,'vietnam war',NULL);
INSERT INTO "platform_conflicts" VALUES(60,'m109a6-paladin','yom-kippur-1973',NULL,NULL,NULL,NULL,'yom kippur war',NULL);
INSERT INTO "platform_conflicts" VALUES(61,'m109a6-paladin','iraq-2003',NULL,NULL,NULL,NULL,'iran-iraq war',NULL);
INSERT INTO "platform_conflicts" VALUES(62,'m109a6-paladin','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war (1991)',NULL);
INSERT INTO "platform_conflicts" VALUES(63,'m109a6-paladin','ukraine-2022',NULL,NULL,NULL,NULL,'russian invasion of ukraine (2022-)',NULL);
INSERT INTO "platform_conflicts" VALUES(64,'m1a2-system-enhancement-package-main-battle-tank','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war 1991',NULL);
INSERT INTO "platform_conflicts" VALUES(65,'m1a2-system-enhancement-package-main-battle-tank','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(66,'m1a2-system-enhancement-package-main-battle-tank','ukraine-2022',NULL,NULL,NULL,NULL,'ukraine 2023- (series)',NULL);
INSERT INTO "platform_conflicts" VALUES(67,'infantry-fighting-vehicle-m2-bradley','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war',NULL);
INSERT INTO "platform_conflicts" VALUES(68,'infantry-fighting-vehicle-m2-bradley','iraq-2003',NULL,NULL,NULL,NULL,'iraq war',NULL);
INSERT INTO "platform_conflicts" VALUES(69,'infantry-fighting-vehicle-m2-bradley','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war',NULL);
INSERT INTO "platform_conflicts" VALUES(70,'panzerhaubitze-2000','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan (isaf)',NULL);
INSERT INTO "platform_conflicts" VALUES(71,'panzerhaubitze-2000','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war',NULL);
INSERT INTO "platform_conflicts" VALUES(72,'mim-104f','iraq-2003',NULL,NULL,NULL,NULL,'iraq war 2003',NULL);
INSERT INTO "platform_conflicts" VALUES(73,'mim-104f','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war 2023+',NULL);
INSERT INTO "platform_conflicts" VALUES(74,'s-300-series-eg-s-300p-s-300v','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war (2022-)',NULL);
INSERT INTO "platform_conflicts" VALUES(75,'s-300-series-eg-s-300p-s-300v','nagorno-karabakh-2020',NULL,NULL,NULL,NULL,'nagorno-karabakh (2020)',NULL);
INSERT INTO "platform_conflicts" VALUES(76,'s-300-series-eg-s-300p-s-300v','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war (limited)',NULL);
INSERT INTO "platform_conflicts" VALUES(77,'s-400-triumf','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war (2022-)',NULL);
INSERT INTO "platform_conflicts" VALUES(78,'s-400-triumf','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war (2015-)',NULL);
INSERT INTO "platform_conflicts" VALUES(79,'m1126-infantry-carrier-vehicle','iraq-2003',NULL,NULL,NULL,NULL,'iraq war',NULL);
INSERT INTO "platform_conflicts" VALUES(80,'m1126-infantry-carrier-vehicle','afghanistan-2001',NULL,NULL,NULL,NULL,'war in afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(81,'m1126-infantry-carrier-vehicle','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war',NULL);
INSERT INTO "platform_conflicts" VALUES(82,'object-148','ukraine-2022',NULL,NULL,NULL,NULL,'ukraine war (limited testing',NULL);
INSERT INTO "platform_conflicts" VALUES(83,'t-72-ural-object-172m','iraq-2003',NULL,NULL,NULL,NULL,'iran-iraq war',NULL);
INSERT INTO "platform_conflicts" VALUES(84,'t-72-ural-object-172m','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf wars',NULL);
INSERT INTO "platform_conflicts" VALUES(85,'t-72-ural-object-172m','balkans-1991',NULL,NULL,NULL,NULL,'chechen wars',NULL);
INSERT INTO "platform_conflicts" VALUES(86,'t-72-ural-object-172m','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war',NULL);
INSERT INTO "platform_conflicts" VALUES(87,'t-72-ural-object-172m','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war',NULL);
INSERT INTO "platform_conflicts" VALUES(88,'aim-120-advanced-medium-range-air-to-air-missile','balkans-1991',NULL,NULL,NULL,NULL,'kosovo',NULL);
INSERT INTO "platform_conflicts" VALUES(89,'aim-120-advanced-medium-range-air-to-air-missile','syria-2011',NULL,NULL,NULL,NULL,'syria',NULL);
INSERT INTO "platform_conflicts" VALUES(90,'aim-120-advanced-medium-range-air-to-air-missile','ukraine-2022',NULL,NULL,NULL,NULL,'ukraine-related',NULL);
INSERT INTO "platform_conflicts" VALUES(91,'agm-84-rgm-84-ugm-84-harpoon','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war (2022)',NULL);
INSERT INTO "platform_conflicts" VALUES(92,'agm-84-rgm-84-ugm-84-harpoon','iraq-2003',NULL,NULL,NULL,NULL,'iran-iraq war',NULL);
INSERT INTO "platform_conflicts" VALUES(93,'agm-114-hellfire','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war',NULL);
INSERT INTO "platform_conflicts" VALUES(94,'agm-114-hellfire','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(95,'agm-114-hellfire','syria-2011',NULL,NULL,NULL,NULL,'syria',NULL);
INSERT INTO "platform_conflicts" VALUES(96,'agm-114-hellfire','balkans-1991',NULL,NULL,NULL,NULL,'kosovo',NULL);
INSERT INTO "platform_conflicts" VALUES(97,'agm-114-hellfire','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war',NULL);
INSERT INTO "platform_conflicts" VALUES(98,'gbu-313238-series','afghanistan-2001',NULL,NULL,NULL,NULL,'enduring freedom',NULL);
INSERT INTO "platform_conflicts" VALUES(99,'gbu-313238-series','ukraine-2022',NULL,NULL,NULL,NULL,'ukraine (2022-)',NULL);
INSERT INTO "platform_conflicts" VALUES(100,'fgm-148-javelin','iraq-2003',NULL,NULL,NULL,NULL,'iraq war (2003)',NULL);
INSERT INTO "platform_conflicts" VALUES(101,'fgm-148-javelin','afghanistan-2001',NULL,NULL,NULL,NULL,'war in afghanistan',NULL);
INSERT INTO "platform_conflicts" VALUES(102,'fgm-148-javelin','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war',NULL);
INSERT INTO "platform_conflicts" VALUES(103,'fgm-148-javelin','ukraine-2022',NULL,NULL,NULL,NULL,'russo-ukrainian war (2022-present)',NULL);
INSERT INTO "platform_conflicts" VALUES(104,'3m-543m-14-kalibr','syria-2011',NULL,NULL,NULL,NULL,'syrian civil war',NULL);
INSERT INTO "platform_conflicts" VALUES(105,'3m-543m-14-kalibr','ukraine-2022',NULL,NULL,NULL,NULL,'russian invasion of ukraine',NULL);
INSERT INTO "platform_conflicts" VALUES(106,'gbu-43b-massive-ordnance-air-blast','afghanistan-2001',NULL,NULL,NULL,NULL,'war in afghanistan (2017)',NULL);
INSERT INTO "platform_conflicts" VALUES(107,'scalp-eg-france-storm-shadow-uk','libya-2011',NULL,NULL,NULL,NULL,'libya (2011)',NULL);
INSERT INTO "platform_conflicts" VALUES(108,'scalp-eg-france-storm-shadow-uk','syria-2011',NULL,NULL,NULL,NULL,'syria/iraq (vs isis)',NULL);
INSERT INTO "platform_conflicts" VALUES(109,'scalp-eg-france-storm-shadow-uk','ukraine-2022',NULL,NULL,NULL,NULL,'ukraine (2023+)',NULL);
INSERT INTO "platform_conflicts" VALUES(110,'bgm-109-tomahawk-land-attack-missile-tlam','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war (1991)',NULL);
INSERT INTO "platform_conflicts" VALUES(111,'bgm-109-tomahawk-land-attack-missile-tlam','afghanistan-2001',NULL,NULL,NULL,NULL,'afghanistan (1998/2001)',NULL);
INSERT INTO "platform_conflicts" VALUES(112,'bgm-109-tomahawk-land-attack-missile-tlam','libya-2011',NULL,NULL,NULL,NULL,'libya (2011)',NULL);
INSERT INTO "platform_conflicts" VALUES(113,'bgm-109-tomahawk-land-attack-missile-tlam','syria-2011',NULL,NULL,NULL,NULL,'syria (2014/2017/2018)',NULL);
INSERT INTO "platform_conflicts" VALUES(114,'ddg-51-arleigh-burke-class-guided-missile-destroyer','iraq-2003',NULL,NULL,NULL,NULL,'desert fox/strike',NULL);
INSERT INTO "platform_conflicts" VALUES(115,'ddg-51-arleigh-burke-class-guided-missile-destroyer','syria-2011',NULL,NULL,NULL,NULL,'syria',NULL);
INSERT INTO "platform_conflicts" VALUES(116,'ddg-51-arleigh-burke-class-guided-missile-destroyer','gaza-2023',NULL,NULL,NULL,NULL,'red sea/houthis',NULL);
INSERT INTO "platform_conflicts" VALUES(117,'btiment-de-projection-et-de-commandement-bpc','libya-2011',NULL,NULL,NULL,NULL,'libya 2011)',NULL);
INSERT INTO "platform_conflicts" VALUES(118,'cvn-68-class-nuclear-powered-aircraft-carrier','gulf-war-1991',NULL,NULL,NULL,NULL,'gulf war',NULL);
INSERT INTO "platform_conflicts" VALUES(119,'cvn-68-class-nuclear-powered-aircraft-carrier','afghanistan-2001',NULL,NULL,NULL,NULL,'operation enduring freedom',NULL);
CREATE TABLE platform_statuses (
    status_id       TEXT PRIMARY KEY,           -- 'in_production', 'active_service', etc.
    status_name     TEXT NOT NULL,
    description     TEXT
);
INSERT INTO "platform_statuses" VALUES('in_production','In Production','Currently being manufactured');
INSERT INTO "platform_statuses" VALUES('active_service','Active Service','In operational use but no longer produced');
INSERT INTO "platform_statuses" VALUES('limited_service','Limited Service','Reduced numbers, being phased out');
INSERT INTO "platform_statuses" VALUES('retired','Retired','No longer in active military service');
INSERT INTO "platform_statuses" VALUES('prototype','Prototype','In development or testing phase');
INSERT INTO "platform_statuses" VALUES('cancelled','Cancelled','Program cancelled before production');
INSERT INTO "platform_statuses" VALUES('reserve','Reserve/Storage','In reserve or long-term storage');
CREATE TABLE platforms (
    platform_id             TEXT PRIMARY KEY,       -- e.g. 'f-35a', 'm1a2-abrams'
    common_name             TEXT NOT NULL,
    official_designation    TEXT,
    nato_reporting_name     TEXT,                   -- for Russian/Chinese systems
    category_id             TEXT NOT NULL REFERENCES categories(category_id),
    subcategory_id          TEXT NOT NULL REFERENCES subcategories(subcategory_id),
    manufacturer            TEXT NOT NULL,
    country_of_origin       TEXT NOT NULL REFERENCES countries(country_code),
    development_start_year  INTEGER,
    first_flight_year       INTEGER,               -- air platforms
    entered_service_year    INTEGER,
    production_start_year   INTEGER,
    production_end_year     INTEGER,                -- NULL if still in production
    units_built             INTEGER,
    units_built_approx      BOOLEAN DEFAULT FALSE,  -- TRUE if estimate
    status_id               TEXT REFERENCES platform_statuses(status_id),
    description             TEXT,                    -- brief operational summary
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "platforms" VALUES('ah-64e-apache-guardian','AH-64 Apache','AH-64E Apache Guardian',NULL,'air','helicopter-attack','Boeing','US',1972,1975,1986,1984,NULL,2700,0,'in_production','Proven tank-killer; >5M flight hours, >1.3M combat; high survivability vs 23mm hits; notable in Desert Storm (500+ Iraqi vehicles destroyed)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('northrop-b-2-spirit','B-2 Spirit','Northrop B-2 Spirit',NULL,'air','bomber','Northrop Grumman','US',1979,1989,1997,1988,2000,21,0,'active_service','Debut in Kosovo destroying 33% of targets in first 8 weeks; record 44.3 hour mission in Iraq; long-range precision strikes from US mainland.','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('c-17a-globemaster-iii','C-17 Globemaster III','C-17A Globemaster III',NULL,'air','transport','Boeing (McDonnell Douglas)','US',1980,1991,1995,1993,2015,279,0,'active_service','Tactical airlift, airdrop, medevac; one SAM hit (repaired); no combat losses','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('boeing-ch-47-chinook','CH-47 Chinook','Boeing CH-47 Chinook',NULL,'air','transport','Boeing Defense, Space & Security','US',1957,1961,1962,1962,NULL,1200,0,'in_production','Heavy-lift transport, resupply, MEDEVAC; Vietnam: 200+ lost; Afghanistan/Iraq: air assault, escorted by Apaches; high crash fatalities due to troop capacity','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('eurofighter-ef-2000-typhoon','Eurofighter Typhoon','Eurofighter EF-2000 Typhoon','Typhoon','air','fighter','Eurofighter Jagdflugzeug GmbH (Airbus, BAE Systems, Leonardo)','GB',1983,1994,2003,1998,NULL,608,1,'in_production','Combat debut Libya 2011 (recon/strikes); first kill 2021 (drone); ground attack roles in Syria/Iraq/Yemen [Wikipedia](https://en.wikipedia.org/wiki/Eurofighter_Typhoon)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('general-dynamics-f-16-fighting-falcon','F-16 Fighting Falcon','General Dynamics F-16 Fighting Falcon','Viper','air','fighter','General Dynamics / Lockheed Martin','US',1972,1974,1979,1976,NULL,4600,1,'in_production','Extensive SEAD/strike; Israel 44 kills in 1982; Pakistan 8-9 in Afghan War; USAF thousands of sorties in GWOT','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('f-22a','F-22 Raptor','F-22A',NULL,'air','fighter','Lockheed Martin / Boeing','US',1981,1997,2005,1997,2012,195,0,'active_service','Primarily used in strike roles; no confirmed air-to-air kills; air dominance and policing missions','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('f-35a','F-35A Lightning II','F-35A','Lightning II','air','fighter','Lockheed Martin','US',1997,2006,2016,2006,2044,1300,1,'in_production','First combat 2018 (Israel); Israeli F-35I air-to-air kill vs Yak-130 (2026); no confirmed combat losses; multiple training crashes','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('boeing-fa-18e-super-hornet','F/A-18E Super Hornet','Boeing F/A-18E Super Hornet',NULL,'air','fighter','Boeing (formerly McDonnell Douglas)','US',1992,1995,1999,1997,2027,300,1,'in_production','First combat Nov 2002; extensive strike, CAS, SEAD, tanker roles; notable Nov 2017 shootdown of Syrian Su-22 by VFA-87 F/A-18E','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('chengdu-j-20-20','J-20 Mighty Dragon','Chengdu J-20 (歼-20)','Fagin','air','fighter','Chengdu Aircraft Corporation (CAC) / AVIC','CN',2008,2011,2017,2015,NULL,300,1,'in_production','No combat use; training, patrols over East/South China Sea, Taiwan Strait; simulated strikes','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('kamov-ka-52','Ka-52 Alligator','Kamov Ka-52','Hokum B','air','helicopter-attack','Kamov / Progress Arsenyev','RU',1994,1997,2011,2008,NULL,200,1,'in_production','Heavy losses in Ukraine (~66 per Oryx as of 2025); used for CAS, anti-armor','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('mq-9a-reaper','MQ-9 Reaper','MQ-9A Reaper','None','air','drone-combat','General Atomics Aeronautical Systems, Inc.','US',2001,2001,2007,2002,NULL,300,0,'in_production','Hunter-killer ISR/strike role; first kill 2007; thousands of missions; combat losses: ~38 in Afghanistan by 2010, multiple to Houthis (15+ claimed by 2025), Black Sea 2023','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('dassault-rafale','Rafale','Dassault Rafale','Rafale','air','fighter','Dassault Aviation','FR',NULL,1986,2001,1992,NULL,300,1,'in_production','Omnirole operations, high sortie rates in Libya, strikes vs ISIS [Wikipedia](https://en.wikipedia.org/wiki/Dassault_Rafale)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('sukhoi-su-57','Su-57 Felon','Sukhoi Su-57','Felon','air','fighter','Sukhoi Company (UAC)','RU',1999,2010,2020,2019,NULL,42,1,'in_production','Limited combat: missile strikes from standoff; claims of air-to-air kills unverified; one damaged by drone (2024)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('sikorsky-uh-60-black-hawk','UH-60 Black Hawk','Sikorsky UH-60 Black Hawk',NULL,'air','helicopter-utility','Sikorsky Aircraft (Lockheed Martin)','US',1972,1974,1979,1977,NULL,5000,1,'in_production','Troop transport, MEDEVAC, special ops; notable losses in Mogadishu and Gulf War; stealth variant in OBL raid','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('boevaya-mashina-pekhoty-3-bmp-3','BMP-3','Boevaya Mashina Pekhoty 3 (BMP-3)','IFV M1990/1','land','ifv','Kurganmashzavod','XX',NULL,NULL,1987,1989,NULL,1840,1,'in_production','Used by Russia in Ukraine (hundreds lost to ATGM/drones, shifted to indirect fire); UAE in Yemen; vulnerable to modern ATGMs despite upgrades [Wikipedia](https://en.wikipedia.org/wiki/BMP-3)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('fv4034-challenger-2','Challenger 2','FV4034 Challenger 2','CR2','land','mbt','Vickers Defence Systems (now Rheinmetall BAE Systems Land / RBSL)','GB',1986,1990,1998,1994,2002,446,1,'active_service','Highly survivable in Iraq (no penetrations by enemy fire until friendly fire incident); some losses in Ukraine to drones and mines. No confirmed tank kills data.','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('m142-high-mobility-artillery-rocket-system','HIMARS M142','M142 High Mobility Artillery Rocket System',NULL,'land','mlrs','Lockheed Martin Missiles and Fire Control','US',1993,1998,2005,2003,NULL,750,1,'in_production','Extensively used for precision strikes on command posts, ammo depots, troop concentrations; notable in Ukraine for destroying Russian logistics and HQs; some losses to enemy fire','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('iron-dome-kippat-barzel','Iron Dome','Iron Dome (Kippat Barzel)',NULL,'land','sam','Rafael Advanced Defense Systems / Israel Aerospace Industries','IL',2007,2008,2011,2010,NULL,10,1,'in_production','5000+ intercepts, 90%+ success rate [Wikipedia](https://en.wikipedia.org/wiki/Iron_Dome) [Rafael](https://www.rafael.co.il/system/iron-dome/)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('k2-k-2-heukpyo','K2 Black Panther','K2 흑표 (K-2 Heukpyo)','None','land','mbt','Hyundai Rotem','KR',1995,2007,2014,2014,NULL,410,1,'in_production','No combat experience','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('leopard-2a7','Leopard 2A7','Leopard 2A7',NULL,'land','mbt','Krauss-Maffei Wegmann (KNDS)','DE',2010,NULL,2014,2014,NULL,300,1,'in_production','No confirmed combat use for 2A7; designed for high-intensity and urban ops with enhanced protection','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('m109a6-paladin','M109 Paladin','M109A6 Paladin',NULL,'land','artillery-sp','BAE Systems (formerly United Defense LP)','US',1984,NULL,1993,1992,1999,950,0,'active_service','Used extensively by US in Gulf War and Iraq; donated to Ukraine with losses reported; reliable indirect fire support platform','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('m1a2-system-enhancement-package-main-battle-tank','M1A2 Abrams','M1A2 System Enhancement Package Main Battle Tank',NULL,'land','mbt','General Dynamics Land Systems','US',1988,1990,1992,1992,NULL,1500,1,'in_production','Superior in open combat; urban upgrades (TUSK); low losses in GW; drone vulns recent','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('infantry-fighting-vehicle-m2-bradley','M2 Bradley','Infantry Fighting Vehicle M2 Bradley',NULL,'land','ifv','BAE Systems Land & Armaments (formerly United Defense, FMC Corp.)','US',1963,1978,1981,1981,1995,6724,1,'active_service','Proven effective vs tanks in Gulf War; high survivability in Ukraine; multiple losses to friendly fire/IEDs','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('panzerhaubitze-2000','Panzerhaubitze 2000','Panzerhaubitze 2000','PzH 2000','land','artillery-sp','KNDS Deutschland (Krauss-Maffei Wegmann / Rheinmetall)','DE',1987,NULL,1998,1998,NULL,384,1,'in_production','Proven highly effective in Afghanistan (Netherlands/Germany) and Ukraine (intensive use exceeding design limits, some losses)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('mim-104f','Patriot PAC-3','MIM-104F',NULL,'land','sam','Lockheed Martin Missiles and Fire Control','US',NULL,1997,1997,1999,NULL,2500,1,'in_production','High success vs TBMs in Iraq; intercepted Kinzhal hypersonic missiles, aircraft in Ukraine','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('s-300-series-eg-s-300p-s-300v','S-300','S-300 (series, e.g. S-300P, S-300V)','SA-10 Grumble','land','sam','Almaz-Antey (NPO Almaz)','SU',1967,NULL,1978,1975,2011,3000,1,'active_service','Destroyed Armenian units in 2020; heavy losses in Ukraine; high exercise success rates but mixed real-world performance vs drones/precision strikes [Wikipedia](https://en.wikipedia.org/wiki/S-300_missile_system), [CSIS](https://missilethreat.csis.org/defsys/s-300/)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('s-400-triumf','S-400 Triumf','S-400 Triumf','SA-21 Growler','land','sam','Almaz-Antey / NPO Almaz','RU',NULL,NULL,2007,2007,NULL,195,1,'in_production','Used for air defense in Ukraine/Syria; multiple losses claimed in Ukraine; Indian claims of intercepts vs Pakistan.','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('m1126-infantry-carrier-vehicle','Stryker ICV','M1126 Infantry Carrier Vehicle',NULL,'land','apc','General Dynamics Land Systems','US',1999,2000,2002,2002,NULL,1162,1,'in_production','Effective in urban/Counter-insurgency; high IED survivability; >27M combat miles; ongoing upgrades (DVH, 30mm cannon)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('object-148','T-14 Armata','Object 148',NULL,'land','mbt','Uralvagonzavod / Ural Design Bureau of Transport Machine-Building','RU',2010,2015,2024,2015,NULL,20,1,'limited_service','Tested in indirect fire role; withdrawn after trials; no confirmed combat losses or kills','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('t-72-ural-object-172m','T-72','T-72 Ural (Object 172M)',NULL,'land','mbt','Uralvagonzavod','SU',1968,1968,1973,1971,NULL,25000,1,'in_production','Widely used; notable for autoloader vulnerabilities leading to catastrophic kills; heavy losses in modern conflicts like Ukraine (Russia: 1,800+ visual confirmed losses) [Wikipedia](https://en.wikipedia.org/wiki/T-72)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('aim-120-advanced-medium-range-air-to-air-missile','AIM-120 AMRAAM','AIM-120 Advanced Medium-Range Air-to-Air Missile','AMRAAM','munition','aam','Raytheon (formerly Hughes)','US',1979,1981,1991,1988,NULL,14000,0,'active_service','16 confirmed kills; first kill 1992 vs Iraqi MiG-25; Pk 0.59 in BVR','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('agm-84-rgm-84-ugm-84-harpoon','Harpoon','AGM-84 / RGM-84 / UGM-84 Harpoon',NULL,'munition','ashm','McDonnell Douglas (now Boeing Defense, Space & Security)','US',1965,1977,1977,1977,NULL,7000,1,'in_production','US sank Iranian frigate Sahand and patrol boat Joshan (1988); Ukraine sank Russian tug (2022); reliable anti-ship record','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('agm-114-hellfire','Hellfire','AGM-114 Hellfire',NULL,'munition','agm','Lockheed Martin','US',1974,1978,1984,1982,NULL,71500,0,'in_production','~500 Iraqi tanks killed in Gulf War; first UAV kills; air-to-air use (Israel vs Cessna 2001); high precision, low collateral variants like R9X','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('gbu-313238-series','JDAM (Joint Direct Attack Munition)','GBU-31/32/38 series',NULL,'munition','bomb-guided','Boeing','US',1992,1993,1997,1997,NULL,550000,1,'in_production','651 dropped in Allied Force (96% reliability); widely used in GWOT; jamming issues noted in Ukraine [[Wikipedia](https://en.wikipedia.org/wiki/Joint_Direct_Attack_Munition)]','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('fgm-148-javelin','Javelin','FGM-148 Javelin',NULL,'munition','atgm','Javelin Joint Venture (Lockheed Martin / RTX)','US',1983,1991,1996,1994,NULL,50000,1,'in_production','Over 5,000 successful engagements claimed by manufacturer (2019); pivotal in Ukraine destroying thousands of Russian armored vehicles; 100% hit rate in early Ukraine use per Pentagon; effective top-attack against tanks.','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('3m-543m-14-kalibr','Kalibr','3M-54/3M-14 Kalibr','SS-N-27 Sizzler / SS-N-30A','munition','ssm','NPO Novator (OKB-8)','RU',1985,NULL,1994,NULL,NULL,240,0,'in_production','Syria (2015+: 100+ launches vs ISIL/rebels from Caspian/Med); Ukraine (2022+: hundreds vs infrastructure/cities, e.g. Vinnytsia 20 killed; some intercepted) [Wikipedia](https://en.wikipedia.org/wiki/Kalibr_(missile_family))','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('gbu-43b-massive-ordnance-air-blast','Mother of All Bombs (MOAB)','GBU-43/B Massive Ordnance Air Blast',NULL,'munition','bomb-unguided','Air Force Research Laboratory (AFRL); Dynetics','US',2002,2003,2003,2003,NULL,15,0,'active_service','First combat use 13 April 2017 against ISIS-K tunnel complex in Achin District, Nangarhar Province; reportedly killed 94 militants including 4 commanders. Only known operational use.','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('scalp-eg-france-storm-shadow-uk','Storm Shadow / SCALP','SCALP-EG (France); Storm Shadow (UK)',NULL,'munition','ssm','MBDA (formerly Matra BAe Dynamics)','FR',1994,2000,2003,1997,2025,2000,1,'active_service','High success rate (97% Libya); used for hardened targets, bunkers; some Russian claims of intercepts in Ukraine; strikes on ships, bridges, HQs','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('bgm-109-tomahawk-land-attack-missile-tlam','Tomahawk','BGM-109 Tomahawk Land Attack Missile (TLAM)',NULL,'munition','ssm','Raytheon Missiles & Defense (RTX)','US',1972,1983,1983,NULL,NULL,4000,1,'in_production','Over 2,300 fired in combat since 1991; high success rate (85%+ in Gulf War); first used Operation Desert Storm','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('project-22350','Admiral Gorshkov-class frigate','Project 22350',NULL,'sea','frigate','Severnaya Verf, Saint Petersburg [Wikipedia](https://en.wikipedia.org/wiki/Project_22350_frigate)','RU',2003,2010,2018,2006,NULL,10,0,'in_production','Zircon hypersonic missile tests; no combat losses/kills [Wikipedia](https://en.wikipedia.org/wiki/Russian_frigate_Admiral_Gorshkov)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('ddg-51-arleigh-burke-class-guided-missile-destroyer','Arleigh Burke-class destroyer','DDG-51 Arleigh Burke-class guided-missile destroyer',NULL,'sea','destroyer','Bath Iron Works (General Dynamics), Ingalls Shipbuilding (Huntington Ingalls); Lockheed Martin (Aegis)','US',1980,1988,1991,1988,NULL,74,1,'in_production','Tomahawk strikes, missile intercepts, carrier escort; no losses','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','FREMM multipurpose frigate','Frégate Européenne Multi-Mission / Fregata Europea Multi-Missione (Aquitaine-class / Bergamini-class)','None','sea','frigate','Naval Group (France) / Fincantieri (Italy) [Wikipedia](https://en.wikipedia.org/wiki/FREMM_multipurpose_frigate)','FR',2005,2010,2012,2007,NULL,25,1,'in_production','Deployed in exercises and operations but no combat engagements noted [Wikipedia](https://en.wikipedia.org/wiki/FREMM_multipurpose_frigate)','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('btiment-de-projection-et-de-commandement-bpc','Mistral class','Bâtiment de Projection et de Commandement (BPC)',NULL,'sea','amphibious','DCNS (Naval Group) / Chantiers de l''Atlantique','FR',1997,NULL,2006,2003,2014,5,0,'active_service','Primarily used for amphibious assault, command, humanitarian aid; Russian order cancelled and resold to Egypt','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('cvn-68-class-nuclear-powered-aircraft-carrier','Nimitz-class aircraft carrier','CVN-68 class nuclear-powered aircraft carrier',NULL,'sea','carrier','Newport News Shipbuilding','US',1967,1968,1975,1968,2006,10,0,'active_service','Primary role: power projection via carrier air wing; defensive armament only; no direct ship-to-ship combat losses','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('ohio-class','Ohio-class submarine','Ohio class',NULL,'sea','submarine-ssbn','General Dynamics Electric Boat','US',NULL,1976,1981,1976,1997,18,0,'active_service','Sea-based leg of US nuclear triad; SSGNs support special operations','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('type-055-destroyer','Type 055 Renhai','Type 055 destroyer','Renhai-class cruiser','sea','destroyer','Jiangnan Shipyard, Dalian Shipbuilding Industry Company','CN',2014,2017,2020,2014,NULL,10,1,'in_production','No combat experience; used in exercises and carrier escorts','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('type-26-city-class-frigate','Type 26 frigate','Type 26 City-class frigate',NULL,'sea','frigate','BAE Systems','GB',1998,2017,2028,2017,NULL,2,1,'in_production',NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('ssn-774-class','Virginia-class submarine','SSN-774 class',NULL,'sea','submarine-ssn','General Dynamics Electric Boat / HII Newport News Shipbuilding','US',1991,1999,2004,1999,2043,28,1,'in_production','No major combat engagements noted; used in deployments since 2009','2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "platforms" VALUES('ddg-1000-class-guided-missile-destroyer','Zumwalt destroyer','DDG 1000-class guided missile destroyer',NULL,'sea','destroyer','General Dynamics Bath Iron Works / Huntington Ingalls Industries','US',2001,2011,2016,2009,2019,3,0,'active_service','No combat engagements; developmental testing and exercises only','2026-03-11 02:10:08','2026-03-11 02:10:08');
CREATE TABLE sources (
    source_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    source_name             TEXT NOT NULL,            -- 'Wikipedia', 'GlobalSecurity.org', etc.
    source_url              TEXT NOT NULL,
    access_date             TEXT NOT NULL,            -- ISO 8601 date
    data_fields_sourced     TEXT,                     -- which fields this source covers
    reliability_rating      TEXT,                     -- 'primary', 'secondary', 'tertiary'
    notes                   TEXT
);
INSERT INTO "sources" VALUES(1,'ah-64e-apache-guardian','Wikipedia','https://en.wikipedia.org/wiki/Boeing_AH-64_Apache','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(2,'ah-64e-apache-guardian','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=29','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(3,'ah-64e-apache-guardian','US Army','https://www.army.mil/article/137579/ah_64e_apache_attack_helicopter','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(4,'ah-64e-apache-guardian','Boeing','https://www.boeing.com/defense/military-rotorcraft/ah-64-apache','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(5,'northrop-b-2-spirit','USAF Fact Sheet','https://www.af.mil/About-Us/Fact-Sheets/Display/Article/104482/b-2-spirit/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(6,'northrop-b-2-spirit','Wikipedia','https://en.wikipedia.org/wiki/Northrop_B-2_Spirit','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(7,'northrop-b-2-spirit','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=6','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(8,'c-17a-globemaster-iii','USAF Fact Sheet','https://www.af.mil/About-Us/Fact-Sheets/Display/Article/1529726/c-17-globemaster-iii/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(9,'c-17a-globemaster-iii','Wikipedia','https://en.wikipedia.org/wiki/Boeing_C-17_Globemaster_III','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(10,'c-17a-globemaster-iii','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=33','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(11,'c-17a-globemaster-iii','Boeing','https://www.boeing.com/defense/tankers-and-transports/c-17-globemaster/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(12,'boeing-ch-47-chinook','Wikipedia','https://en.wikipedia.org/wiki/Boeing_CH-47_Chinook','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(13,'boeing-ch-47-chinook','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=56','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(14,'boeing-ch-47-chinook','Boeing','https://www.boeing.com/defense/military-rotorcraft/h-47-chinook','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(15,'boeing-ch-47-chinook','US ANG Fact Sheet','https://www.127wg.ang.af.mil/About-127th-Wing/Fact-Sheets/Article/3694458/army-ch-47-chinook-helicopter/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(16,'eurofighter-ef-2000-typhoon','Wikipedia','https://en.wikipedia.org/wiki/Eurofighter_Typhoon','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(17,'eurofighter-ef-2000-typhoon','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=55','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(18,'general-dynamics-f-16-fighting-falcon','Wikipedia','https://en.wikipedia.org/wiki/General_Dynamics_F-16_Fighting_Falcon','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(19,'general-dynamics-f-16-fighting-falcon','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=22','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(20,'general-dynamics-f-16-fighting-falcon','USAF Fact Sheet','https://www.162wing.ang.af.mil/About-Us/Fact-Sheets/Display/Article/444447/f-16-fighting-falcon/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(21,'general-dynamics-f-16-fighting-falcon','Lockheed Martin','https://www.lockheedmartin.com/content/dam/lockheed-martin/aero/documents/F-16/F-16_Fast_Facts_February_2021.pdf','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(22,'f-22a','USAF Fact Sheet','https://www.af.mil/About-Us/Fact-Sheets/Display/Article/104506/f-22-raptor/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(23,'f-22a','Wikipedia','https://en.wikipedia.org/wiki/Lockheed_Martin_F-22_Raptor','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(24,'f-22a','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=20','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(25,'f-22a','GlobalSecurity','https://www.globalsecurity.org/military/systems/aircraft/f-22-specs.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(26,'f-22a','AN/APG-77','https://en.wikipedia.org/wiki/AN/APG-77','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(27,'f-35a','Wikipedia F-35','https://en.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(28,'f-35a','USAF Fact Sheet','https://www.af.mil/About-Us/Fact-Sheets/Display/Article/478441/f-35a-lightning-ii/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(29,'f-35a','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=23','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(30,'f-35a','Lockheed Martin','https://www.lockheedmartin.com/en-us/products/f-35.html','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(31,'f-35a','F-35 Operators Wiki','https://en.wikipedia.org/wiki/Lockheed_Martin_F-35_Lightning_II_operators','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(32,'f-35a','Wikimedia Commons','https://commons.wikimedia.org/wiki/Category:Lockheed_Martin_F-35_Lightning_II','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(33,'boeing-fa-18e-super-hornet','Wikipedia','https://en.wikipedia.org/wiki/Boeing_F/A-18E/F_Super_Hornet','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(34,'boeing-fa-18e-super-hornet','US Navy Fact File','https://www.navy.mil/Resources/Fact-Files/Display-FactFiles/Article/2383479/fa-18a-d-hornet-and-fa-18ef-super-hornet-strike-fighter/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(35,'boeing-fa-18e-super-hornet','Boeing','https://www.boeing.com/defense/fighters-and-bombers/fa-18-super-hornet-and-ea-18-growler','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(36,'boeing-fa-18e-super-hornet','Defense News','https://www.defensenews.com/naval/2023/02/23/boeing-will-close-super-hornet-production-line-in-2025/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(37,'chengdu-j-20-20','Wikipedia','https://en.wikipedia.org/wiki/Chengdu_J-20','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(38,'chengdu-j-20-20','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=860','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(39,'chengdu-j-20-20','19FortyFive 2026','https://www.19fortyfive.com/2026/02/sorry-f-22-and-f-35-chinas-j-20-mighty-dragon-stealth-fighter-is-getting-pumped-out-of-factories-in-big-numbers/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(40,'chengdu-j-20-20','Airforce Technology','https://www.airforce-technology.com/projects/chengdu-j20/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(41,'kamov-ka-52','Wikipedia','https://en.wikipedia.org/wiki/Kamov_Ka-52','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(42,'kamov-ka-52','Naval Technology','https://www.naval-technology.com/projects/kamovka52alligatorhe/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(43,'kamov-ka-52','Army Recognition','https://armyrecognition.com/military-products/air/helicopters/attack-helicopters/ka-52-alligator-hokum-b-kamov','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(44,'kamov-ka-52','Flugzeuginfo','http://www.flugzeuginfo.net/acdata_php/acdata_ka52_en.php','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(45,'kamov-ka-52','Oryx','https://www.oryxspioenkop.com/2022/02/attack-on-europe-documenting-equipment.html','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(46,'mq-9a-reaper','USAF Fact Sheet','https://www.af.mil/About-Us/Fact-Sheets/Display/Article/104470/mq-9-reaper/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(47,'mq-9a-reaper','Wikipedia','https://en.wikipedia.org/wiki/General_Atomics_MQ-9_Reaper','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(48,'mq-9a-reaper','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=468','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(49,'mq-9a-reaper','GlobalSecurity.org','https://www.globalsecurity.org/military/systems/aircraft/mq-9.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(50,'mq-9a-reaper','GA-ASI','https://www.ga-asi.com/remotely-piloted-aircraft/mq-9a','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(51,'dassault-rafale','Wikipedia','https://en.wikipedia.org/wiki/Dassault_Rafale','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(52,'dassault-rafale','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=60','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(53,'dassault-rafale','Dassault PDF','https://www.dassault-aviation.com/wp-content/blogs.dir/2/files/2023/06/RAFALE-Press-Release-Paris-Air-Show-2023.pdf','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(54,'dassault-rafale','Dassault site','https://www.dassault-aviation.com/en/defense/rafale/introduction/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(55,'dassault-rafale','AeroTime','https://www.aerotime.aero/articles/dassault-rafale-output-lags-demand-2025-deliveries','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(56,'dassault-rafale','Militarnyi','https://militarnyi.com/en/news/france-produces-300th-rafale-multi-role-fighter-jet/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(57,'sukhoi-su-57','Wikipedia','https://en.wikipedia.org/wiki/Sukhoi_Su-57','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(58,'sukhoi-su-57','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=782','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(59,'sukhoi-su-57','Army Recognition','https://armyrecognition.com/military-products/air/fighter/su-57','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(60,'sikorsky-uh-60-black-hawk','Military Factory','https://www.militaryfactory.com/aircraft/detail.php?aircraft_id=44','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(61,'sikorsky-uh-60-black-hawk','Wikipedia','https://en.wikipedia.org/wiki/Sikorsky_UH-60_Black_Hawk','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(62,'sikorsky-uh-60-black-hawk','US Army PDF','https://api.army.mil/e2/c/downloads/2020/09/25/671d7a5a/black-hawk-v3.pdf','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(63,'sikorsky-uh-60-black-hawk','Dsca sales','https://turdef.com/article/sale-of-36-uh-60m-black-hawk-for-2-billion-855-million','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(64,'boevaya-mashina-pekhoty-3-bmp-3','Wikipedia BMP-3','https://en.wikipedia.org/wiki/BMP-3','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(65,'boevaya-mashina-pekhoty-3-bmp-3','Military Factory BMP-3','https://www.militaryfactory.com/armor/detail.php?armor_id=12','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(66,'boevaya-mashina-pekhoty-3-bmp-3','Army Technology BMP-3','https://www.army-technology.com/projects/bmp-3/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(67,'fv4034-challenger-2','Wikipedia','https://en.wikipedia.org/wiki/Challenger_2','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(68,'fv4034-challenger-2','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=11','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(69,'fv4034-challenger-2','British Army','https://www.army.mod.uk/learn-and-explore/equipment/combat-vehicles/challenger-2/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(70,'m142-high-mobility-artillery-rocket-system','Wikipedia','https://en.wikipedia.org/wiki/M142_HIMARS','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(71,'m142-high-mobility-artillery-rocket-system','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=673','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(72,'m142-high-mobility-artillery-rocket-system','Lockheed Martin PDF','https://www.lockheedmartin.com/content/dam/lockheed-martin/mfc/pc/high-mobility-artillery-rocket-system/himars-product-card%20.pdf','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(73,'m142-high-mobility-artillery-rocket-system','GlobalSecurity','https://www.globalsecurity.org/military/systems/ground/himars.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(74,'iron-dome-kippat-barzel','Wikipedia','https://en.wikipedia.org/wiki/Iron_Dome','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(75,'iron-dome-kippat-barzel','CSIS','https://missilethreat.csis.org/defsys/iron-dome/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(76,'iron-dome-kippat-barzel','Rafael','https://www.rafael.co.il/system/iron-dome/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(77,'iron-dome-kippat-barzel','Army Recognition','https://armyrecognition.com/military-products/army/air-defense-systems/air-defense-vehicles/iron-dome','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(78,'k2-k-2-heukpyo','Wikipedia','https://en.wikipedia.org/wiki/K2_Black_Panther','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(79,'k2-k-2-heukpyo','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=289','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(80,'k2-k-2-heukpyo','Army Recognition','https://armyrecognition.com/military-products/army/main-battle-tanks/main-battle-tanks/k2-black-panther-main-battle-tank-hyundai-rotem-technical-data-sheet-description-information-identification-intelligence-pictures-photos-images-video-south-korea-korean-army-military-equipment','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(81,'leopard-2a7','Wikipedia','https://en.wikipedia.org/wiki/Leopard_2','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(82,'leopard-2a7','KNDS','https://knds.com/en/products/systems/leopard/leopard-2-a7','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(83,'leopard-2a7','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=37','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(84,'m109a6-paladin','Wikipedia','https://en.wikipedia.org/wiki/M109_howitzer','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(85,'m109a6-paladin','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=7','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(86,'m109a6-paladin','Army Technology','https://www.army-technology.com/projects/paladin-m109a7-155mm-artillery-system/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(87,'m1a2-system-enhancement-package-main-battle-tank','Wikipedia','https://en.wikipedia.org/wiki/M1_Abrams','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(88,'m1a2-system-enhancement-package-main-battle-tank','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=1','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(89,'m1a2-system-enhancement-package-main-battle-tank','Army Technology','https://www.army-technology.com/projects/abrams-m1a2-sepv3-main-battle-tank/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(90,'m1a2-system-enhancement-package-main-battle-tank','Army Recognition','https://armyrecognition.com/military-products/army/main-battle-tanks/main-battle-tanks/m1a2-sep-v3-main-battle-tank-technical-data-sheet-specifications-pictures-video-11710154','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(91,'infantry-fighting-vehicle-m2-bradley','Wikipedia','https://en.wikipedia.org/wiki/M2_Bradley','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(92,'infantry-fighting-vehicle-m2-bradley','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=5','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(93,'infantry-fighting-vehicle-m2-bradley','AFV Database','https://afvdatabase.com/usa/m2bradley.html','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(94,'infantry-fighting-vehicle-m2-bradley','Wikimedia Commons','https://commons.wikimedia.org/wiki/Category:M2_Bradleys','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(95,'panzerhaubitze-2000','Wikipedia','https://en.wikipedia.org/wiki/Panzerhaubitze_2000','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(96,'panzerhaubitze-2000','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=335','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(97,'panzerhaubitze-2000','KNDS','https://knds.com/en/products/systems/pzh-2000','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(98,'mim-104f','Wikipedia MIM-104 Patriot','https://en.wikipedia.org/wiki/MIM-104_Patriot','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(99,'mim-104f','Lockheed Martin PAC-3','https://www.lockheedmartin.com/en-us/products/pac-3-advanced-air-defense-missile.html','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(100,'mim-104f','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=78','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(101,'mim-104f','Reuters','https://www.reuters.com/business/aerospace-defense/us-army-awards-lockheed-martin-45-bln-contract-2024-06-28/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(102,'s-300-series-eg-s-300p-s-300v','Wikipedia','https://en.wikipedia.org/wiki/S-300_missile_system','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(103,'s-300-series-eg-s-300p-s-300v','CSIS Missile Threat','https://missilethreat.csis.org/defsys/s-300/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(104,'s-300-series-eg-s-300p-s-300v','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=453','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(105,'s-300-series-eg-s-300p-s-300v','MDAA','https://www.missiledefenseadvocacy.org/missile-threat-and-proliferation/todays-missile-threat/russia/russia-anti-access-area-denial/s-300p-air-and-missile-defense-system/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(106,'s-400-triumf','Wikipedia','https://en.wikipedia.org/wiki/S-400_missile_system','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(107,'s-400-triumf','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=909','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(108,'s-400-triumf','Army Technology','https://www.army-technology.com/projects/s-400-triumph-air-defence-missile-system/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(109,'m1126-infantry-carrier-vehicle','Wikipedia Stryker','https://en.wikipedia.org/wiki/Stryker','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(110,'m1126-infantry-carrier-vehicle','Wikipedia M1126','https://en.wikipedia.org/wiki/M1126_infantry_carrier_vehicle','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(111,'m1126-infantry-carrier-vehicle','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=10','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(112,'m1126-infantry-carrier-vehicle','Army Recognition','https://armyrecognition.com/military-products/army/armoured-personnel-carriers/wheeled-vehicles/stryker-m1126-icv-united-states-uk','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(113,'object-148','Wikipedia','https://en.wikipedia.org/wiki/T-14_Armata','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(114,'object-148','Military Factory','https://www.militaryfactory.com/armor/detail.php?armor_id=905','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(115,'object-148','GlobalSecurity.org','https://www.globalsecurity.org/military/world/russia/t-14.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(116,'object-148','19FortyFive','https://www.19fortyfive.com/2026/03/russias-t-14-armata-tank-is-frozen-in-time/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(117,'t-72-ural-object-172m','Wikipedia T-72','https://en.wikipedia.org/wiki/T-72','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(118,'t-72-ural-object-172m','Military Factory T-72','https://www.militaryfactory.com/armor/detail.php?armor_id=22','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(119,'t-72-ural-object-172m','Wikipedia operators','https://en.wikipedia.org/wiki/T-72_operators_and_variants','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(120,'aim-120-advanced-medium-range-air-to-air-missile','Wikipedia','https://en.wikipedia.org/wiki/AIM-120_AMRAAM','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(121,'aim-120-advanced-medium-range-air-to-air-missile','USAF Fact Sheet','https://www.af.mil/About-Us/Fact-Sheets/Display/Article/104576/aim-120-amraam/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(122,'aim-120-advanced-medium-range-air-to-air-missile','GlobalSecurity','https://www.globalsecurity.org/military/systems/munitions/aim-120.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(123,'aim-120-advanced-medium-range-air-to-air-missile','National Museum USAF','https://www.nationalmuseum.af.mil/Visit/Museum-Exhibits/Fact-Sheets/Display/Article/196742/hughes-aim-120-amraam/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(124,'aim-120-advanced-medium-range-air-to-air-missile','RTX','https://www.rtx.com/raytheon/what-we-do/air/amraam-missile','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(125,'agm-84-rgm-84-ugm-84-harpoon','Wikipedia','https://en.wikipedia.org/wiki/Harpoon_(missile','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(126,'agm-84-rgm-84-ugm-84-harpoon','US Navy Fact File','https://www.navy.mil/Resources/Fact-Files/Display-FactFiles/Article/2168358/harpoon-missile/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(127,'agm-84-rgm-84-ugm-84-harpoon','Boeing','https://www.boeing.com/content/dam/boeing/boeingdotcom/defense/weapons-weapons/images/harpoon_product_card.pdf','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(128,'agm-84-rgm-84-ugm-84-harpoon','Weaponsystems.net','https://weaponsystems.net/system/583-RGM-84+Harpoon','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(129,'agm-114-hellfire','Wikipedia','https://en.wikipedia.org/wiki/AGM-114_Hellfire','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(130,'agm-114-hellfire','CSIS','https://missilethreat.csis.org/missile/agm-114-hellfire/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(131,'agm-114-hellfire','US Navy','https://www.navy.mil/Resources/Fact-Files/Display-FactFiles/Article/2168362/agm-114bkmn-hellfire-missile/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(132,'agm-114-hellfire','Air & Space Forces','https://www.airandspaceforces.com/weapons/agm-114-hellfire/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(133,'gbu-313238-series','Wikipedia','https://en.wikipedia.org/wiki/Joint_Direct_Attack_Munition','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(134,'gbu-313238-series','GlobalSecurity','https://www.globalsecurity.org/military/systems/munitions/jdam.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(135,'gbu-313238-series','Defense News','https://www.defensenews.com/air/2024/05/28/boeing-wins-75-billion-contract-from-us-air-force-for-guided-bombs/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(136,'gbu-313238-series','USAF Museum','https://www.nationalmuseum.af.mil/Visit/Museum-Exhibits/Fact-Sheets/Display/Article/197589/gbu-3132-joint-direct-attack-munitions-jdam/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(137,'fgm-148-javelin','Wikipedia','https://en.wikipedia.org/wiki/FGM-148_Javelin','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(138,'fgm-148-javelin','Military Factory','https://www.militaryfactory.com/smallarms/detail.php?smallarms_id=391','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(139,'fgm-148-javelin','Lockheed Martin','https://www.lockheedmartin.com/en-us/products/javelin.html','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(140,'fgm-148-javelin','CSIS Missile Threat','https://missilethreat.csis.org/missile/fgm-148-javelin/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(141,'3m-543m-14-kalibr','Wikipedia','https://en.wikipedia.org/wiki/Kalibr_(missile_family','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(142,'3m-543m-14-kalibr','CSIS SS-N-27','https://missilethreat.csis.org/missile/ss-n-27-sizzler/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(143,'3m-543m-14-kalibr','CSIS SS-N-30A','https://missilethreat.csis.org/missile/ss-n-30a/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(144,'3m-543m-14-kalibr','Defence UA','https://en.defence-ua.com/news/what_is_the_real_price_of_russian_missiles_about_the_cost_of_kalibr_kh_101_and_iskander_missiles-4709.html','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(145,'gbu-43b-massive-ordnance-air-blast','Wikipedia','https://en.wikipedia.org/wiki/GBU-43/B_MOAB','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(146,'gbu-43b-massive-ordnance-air-blast','Air & Space Forces Magazine','https://www.airandspaceforces.com/weapons-platforms/gbu-43-moab/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(147,'gbu-43b-massive-ordnance-air-blast','AF.mil','https://www.af.mil/News/Features/Display/Article/143321/five-years-later-its-still-known-as-mother-of-all-bombs/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(148,'scalp-eg-france-storm-shadow-uk','Wikipedia','https://en.wikipedia.org/wiki/Storm_Shadow','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(149,'scalp-eg-france-storm-shadow-uk','Army Recognition','https://armyrecognition.com/military-products/army/missiles/cruise-missiles/storm-shadow-scalp-long-range-air-launched-attack-cruise-missile-data','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(150,'scalp-eg-france-storm-shadow-uk','GlobalSecurity','https://www.globalsecurity.org/military/world/europe/storm-shadow.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(151,'bgm-109-tomahawk-land-attack-missile-tlam','Wikipedia','https://en.wikipedia.org/wiki/Tomahawk_(missile','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(152,'bgm-109-tomahawk-land-attack-missile-tlam','NAVAIR','https://www.navair.navy.mil/product/Tomahawk','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(153,'bgm-109-tomahawk-land-attack-missile-tlam','US Navy Fact File','https://www.navy.mil/Resources/Fact-Files/Display-FactFiles/Article/2169229/tomahawk-cruise-missile/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(154,'bgm-109-tomahawk-land-attack-missile-tlam','CSIS Missile Threat','https://missilethreat.csis.org/missile/tomahawk/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(155,'bgm-109-tomahawk-land-attack-missile-tlam','GlobalSecurity.org','https://www.globalsecurity.org/military/systems/munitions/bgm-109-specs.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(156,'project-22350','Wikipedia Project 22350','https://en.wikipedia.org/wiki/Project_22350_frigate','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(157,'project-22350','Military Factory','https://www.militaryfactory.com/ships/detail.php?ship_id=admiral-gorshkov-417-guided-missile-frigate-russian-navy','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(158,'project-22350','GlobalSecurity','https://www.globalsecurity.org/military/world/russia/22350.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(159,'project-22350','Army Recognition','https://armyrecognition.com/military-products/navy/frigates/admiral-gorshkov-class-frigate-project-22350','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(160,'ddg-51-arleigh-burke-class-guided-missile-destroyer','Wikipedia','https://en.wikipedia.org/wiki/Arleigh_Burke-class_destroyer','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(161,'ddg-51-arleigh-burke-class-guided-missile-destroyer','US Navy Fact File','https://www.navy.mil/Resources/Fact-Files/Display-FactFiles/Article/2169871/destroyers-ddg-51/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(162,'ddg-51-arleigh-burke-class-guided-missile-destroyer','NAVSEA','https://www.navsea.navy.mil/Home/Team-Ships/PEO-Ships/DDG-51/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(163,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','Wikipedia FREMM','https://en.wikipedia.org/wiki/FREMM_multipurpose_frigate','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(164,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq','Military Factory FREMM','https://www.militaryfactory.com/ships/detail.php?ship_id=fremm-multipurpose-frigate-french-navy','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(165,'btiment-de-projection-et-de-commandement-bpc','Wikipedia','https://en.wikipedia.org/wiki/Mistral-class_landing_helicopter_dock','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(166,'btiment-de-projection-et-de-commandement-bpc','Seaforces.org','https://www.seaforces.org/marint/French-Navy/Amphibious-Ship/Mistral-class.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(167,'btiment-de-projection-et-de-commandement-bpc','Military Factory','https://www.militaryfactory.com/ships/detail.php?ship_id=FS-Mistral-L9013','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(168,'cvn-68-class-nuclear-powered-aircraft-carrier','Wikipedia','https://en.wikipedia.org/wiki/Nimitz-class_aircraft_carrier','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(169,'cvn-68-class-nuclear-powered-aircraft-carrier','US Navy Fact Sheet','https://cnrnw.cnic.navy.mil/Portals/82/CNRNW/Documents/NIMITZ%20Fact%20sheet.pdf?ver=mraTRIyokbYA6M_PiG2I7g%3D%3D','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(170,'cvn-68-class-nuclear-powered-aircraft-carrier','Military Factory','https://www.militaryfactory.com/ships/ship-classes/nimitz-class-aircraft-carriers.php','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(171,'ohio-class','Wikipedia','https://en.wikipedia.org/wiki/Ohio-class_submarine','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(172,'ohio-class','US Navy','https://www.csp.navy.mil/ohio/About/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(173,'ohio-class','Naval Technology','https://www.naval-technology.com/projects/ohio-class-submarine/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(174,'ohio-class','Military Factory','https://www.militaryfactory.com/ships/detail.php?ship_id=USS-Ohio-SSGN726','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(175,'type-055-destroyer','Wikipedia','https://en.wikipedia.org/wiki/Type_055_destroyer','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(176,'type-055-destroyer','Naval Technology','https://www.naval-technology.com/projects/type-055-class-destroyers/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(177,'type-055-destroyer','Military Factory','https://www.militaryfactory.com/ships/detail.php?ship_id=cns-type-055-destroyer-warship','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(178,'type-055-destroyer','Seaforces','https://www.seaforces.org/marint/China-Navy-PLAN/Destroyers/Type-055-Renhai-class-DDG.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(179,'type-055-destroyer','Global Times March 2026','https://www.globaltimes.cn/page/202603/1356602.shtml','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(180,'type-26-city-class-frigate','Wikipedia','https://en.wikipedia.org/wiki/Type_26_frigate','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(181,'type-26-city-class-frigate','Navy Lookout','https://www.navylookout.com/a-guide-to-the-type-26-frigate/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(182,'type-26-city-class-frigate','Seaforces','https://www.seaforces.org/marint/Royal-Navy/Frigate/City-Type-26-class.htm','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(183,'type-26-city-class-frigate','Naval Technology','https://www.naval-technology.com/news/early-type-26-frigates-mirror-timelines-ahead-of-late-2020s-entry/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(184,'ssn-774-class','Wikipedia','https://en.wikipedia.org/wiki/Virginia-class_submarine','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(185,'ssn-774-class','US Navy Fact File','https://www.navy.mil/Resources/Fact-Files/Display-FactFiles/article/2169558/attack-submarines-ssn/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(186,'ssn-774-class','Naval Technology','https://www.naval-technology.com/projects/nssn/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(187,'ddg-1000-class-guided-missile-destroyer','US Navy Fact File','https://www.navy.mil/Resources/Fact-Files/Display-FactFiles/Article/2391800/destroyers-ddg-1000/','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(188,'ddg-1000-class-guided-missile-destroyer','Wikipedia','https://en.wikipedia.org/wiki/Zumwalt-class_destroyer','2026-03-11','specifications, economics, operational data','secondary',NULL);
INSERT INTO "sources" VALUES(189,'ddg-1000-class-guided-missile-destroyer','Military Factory','https://www.militaryfactory.com/ships/detail.php?ship_id=USS-Zumwalt-DDG1000','2026-03-11','specifications, economics, operational data','secondary',NULL);
CREATE TABLE specifications (
    spec_id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL UNIQUE REFERENCES platforms(platform_id),

    -- Dimensions (metric)
    length_m                REAL,
    width_m                 REAL,                   -- wingspan for aircraft
    height_m                REAL,
    displacement_tons       REAL,                   -- ships
    weight_empty_kg         REAL,
    weight_max_kg           REAL,                   -- MTOW for aircraft, combat weight for vehicles

    -- Performance
    speed_max_kmh           REAL,
    speed_cruise_kmh        REAL,
    range_km                REAL,
    combat_radius_km        REAL,                   -- aircraft
    endurance_hours         REAL,
    ceiling_m               REAL,                   -- service ceiling for aircraft
    dive_depth_m            REAL,                   -- submarines

    -- Crew & Capacity
    crew_min                INTEGER,
    crew_max                INTEGER,
    troop_capacity          INTEGER,                -- APCs, transports
    cargo_capacity_kg       REAL,

    -- Powerplant
    powerplant_type         TEXT,                   -- 'turbofan', 'diesel', 'nuclear', etc.
    powerplant_model        TEXT,
    powerplant_count        INTEGER,
    power_output            TEXT,                   -- '130,000 shp' or '29,000 lbf x2'
    thrust_to_weight        REAL,                   -- aircraft

    -- Protection (land/sea)
    armor_type              TEXT,                   -- 'composite', 'reactive', 'steel', etc.
    armor_thickness_mm      REAL,                   -- equivalent RHA where applicable

    -- Sensors & Electronics
    radar_model             TEXT,
    radar_type              TEXT,                   -- 'AESA', 'PESA', 'mechanically scanned'
    ew_suite                TEXT,                   -- electronic warfare
    fire_control_system     TEXT,

    -- Additional specs as JSON for extensibility
    additional_specs_json   TEXT,                   -- JSON blob for niche specs

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "specifications" VALUES(1,'ah-64e-apache-guardian',17.73,14.63,3.87,NULL,5165.0,10433.0,293.0,265.0,476.0,480.0,NULL,6400.0,NULL,2,2,NULL,NULL,'Turboshaft','General Electric T700-GE-701D',2,'1,994 shp each',NULL,NULL,NULL,'AN/APG-78 Longbow','Millimeter-wave fire-control',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(2,'northrop-b-2-spirit',21.0,52.4,5.2,NULL,71700.0,170600.0,1010.0,900.0,11000.0,6000.0,NULL,15200.0,NULL,2,2,NULL,NULL,'Turbofan','General Electric F118-GE-100',4,'77 kN each',NULL,NULL,NULL,'AN/APQ-181','Multi-mode LPI radar',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(3,'c-17a-globemaster-iii',53.0,51.75,16.79,NULL,128140.0,265352.0,833.0,830.0,4480.0,NULL,NULL,13716.0,NULL,3,3,102,NULL,'Turbofan','Pratt & Whitney F117-PW-100',4,'40,440 lbf each',NULL,NULL,NULL,'AN/APS-133(V)','Weather/mapping',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(4,'boeing-ch-47-chinook',30.1,18.3,5.7,NULL,11148.0,24494.0,310.0,291.0,740.0,306.0,NULL,6096.0,NULL,3,3,33,NULL,'Turboshaft','Honeywell T55-GA-714A',2,'3,562 kW (4,777 shp) each',NULL,NULL,NULL,NULL,'CAAS digital cockpit; terrain-following radar on MH variants',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(5,'eurofighter-ef-2000-typhoon',15.96,10.95,5.28,NULL,11000.0,23500.0,2495.0,1852.0,2900.0,1389.0,NULL,16764.0,NULL,1,2,NULL,NULL,'Afterburning turbofan','Eurojet EJ200',2,'60 kN dry / 90 kN afterburner each',NULL,NULL,NULL,'Euroradar Captor / Captor-E (AESA)','Pulse Doppler / AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(6,'general-dynamics-f-16-fighting-falcon',15.06,9.96,4.88,NULL,8573.0,19187.0,2178.0,933.0,4217.0,546.0,NULL,15240.0,NULL,1,2,0,NULL,'Afterburning turbofan','GE F110-GE-129 or P&W F100-PW-229',1,'131 kN',NULL,NULL,NULL,'AN/APG-68 (early); AN/APG-83 SABR AESA (Block 70)','Multimode / AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(7,'f-22a',18.92,13.56,5.08,NULL,19700.0,38000.0,2414.0,1870.0,3220.0,850.0,NULL,20000.0,NULL,1,1,0,NULL,'Turbofan','Pratt & Whitney F119-PW-100',2,'35,000 lbf class each (afterburner)',NULL,NULL,NULL,'AN/APG-77','AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(8,'f-35a',15.7,10.7,4.4,NULL,13300.0,31800.0,1976.0,NULL,2200.0,1239.0,NULL,15000.0,NULL,1,1,NULL,NULL,'Afterburning turbofan','Pratt & Whitney F135-PW-100',1,'191 kN (43,000 lbf) with afterburner',NULL,NULL,NULL,'AN/APG-81','AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(9,'boeing-fa-18e-super-hornet',18.31,13.62,4.88,NULL,14552.0,29937.0,1908.0,893.0,2346.0,1033.0,NULL,15940.0,NULL,1,1,NULL,NULL,'Turbofan','General Electric F414-GE-400',2,'98 kN with afterburner each',NULL,NULL,NULL,'AN/APG-79','AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(10,'chengdu-j-20-20',21.2,13.01,4.69,NULL,17000.0,37000.0,2130.0,NULL,5500.0,2000.0,NULL,20000.0,NULL,1,2,NULL,NULL,'Afterburning turbofan','Shenyang WS-10C (current); WS-15 (upgrading)',2,'142-147 kN (WS-10C); 180 kN class (WS-15) with afterburner',NULL,NULL,NULL,'Type 1475/KLJ-5A or similar','AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(11,'kamov-ka-52',16.0,14.5,4.95,NULL,7700.0,10800.0,310.0,250.0,460.0,NULL,NULL,3600.0,NULL,2,2,0,NULL,'Turboshaft','Klimov VK-2500',2,'2400 shp each',NULL,NULL,NULL,'Arbalet / Crossbow','Multi-mode radar',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(12,'mq-9a-reaper',11.0,20.1,3.8,NULL,2223.0,4760.0,482.0,313.0,1850.0,NULL,NULL,15240.0,NULL,2,2,NULL,NULL,'Turboprop','Honeywell TPE331-10GD',1,'900 shp (671 kW)',NULL,NULL,NULL,'AN/APY-8 Lynx','Synthetic aperture radar (SAR)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(13,'dassault-rafale',15.27,10.9,5.34,NULL,10300.0,24500.0,1912.0,1.4,3700.0,1850.0,NULL,15835.0,NULL,1,2,0,NULL,'Turbofan','Snecma M88-4e',2,'75 kN afterburner each',NULL,NULL,NULL,'Thales RBE2-AA','AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(14,'sukhoi-su-57',20.1,14.1,4.6,NULL,18500.0,35000.0,2135.0,1400.0,3500.0,1250.0,NULL,20000.0,NULL,1,1,0,NULL,'Afterburning turbofan','Saturn AL-41F1',2,'142 kN with afterburner each',NULL,NULL,NULL,'N036 Byelka','AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(15,'sikorsky-uh-60-black-hawk',19.76,16.36,5.13,NULL,5675.0,9979.0,295.0,285.0,590.0,592.0,NULL,5800.0,NULL,2,4,11,NULL,'Turboshaft','General Electric T700-GE-701C/D',2,'1,902 shp each',NULL,NULL,NULL,'AN/APQ-174B (some variants)','Terrain-following radar',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(16,'boevaya-mashina-pekhoty-3-bmp-3',7.14,2.3,3.15,NULL,NULL,18700.0,70.0,NULL,600.0,NULL,NULL,NULL,NULL,3,3,7,NULL,'Diesel','UTD-29M',1,'500 hp',NULL,NULL,NULL,'N/A (BRM-3K variant: 1RL-133-1 TALL MIKE)','Surveillance (variant)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(17,'fv4034-challenger-2',11.55,3.52,2.49,NULL,NULL,62500.0,59.0,40.0,550.0,NULL,NULL,NULL,NULL,4,4,0,NULL,'Diesel','Perkins CV12-6A V12',1,'1200 hp (890 kW)',NULL,NULL,NULL,NULL,'None (thermal sights and laser rangefinders)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(18,'m142-high-mobility-artillery-rocket-system',7.8,2.4,2.9,NULL,13154.0,16283.0,85.0,NULL,480.0,NULL,NULL,NULL,NULL,3,3,NULL,NULL,'Diesel','Caterpillar 6.6L',1,'290-300 hp',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(19,'iron-dome-kippat-barzel',3.0,0.16,NULL,NULL,NULL,90.0,NULL,NULL,70.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'EL/M-2084','AESA S-band multi-mission radar',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(20,'k2-k-2-heukpyo',10.8,3.6,2.4,NULL,NULL,55000.0,70.0,50.0,450.0,NULL,NULL,NULL,4.1,3,3,0,NULL,'Diesel','MTU MT883 Ka-501 / DV27K',1,'1500 hp',NULL,NULL,NULL,'EHF L-band Pulsed Doppler','Fire control / MAWS',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(21,'leopard-2a7',10.97,3.75,3.0,NULL,55000.0,68000.0,70.0,NULL,450.0,NULL,NULL,NULL,NULL,4,4,0,NULL,'Diesel','MTU MB 873 Ka-501',1,'1,500 hp',NULL,NULL,NULL,NULL,'N/A (thermal optics: Attica, EMES 15)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(22,'m109a6-paladin',9.67,3.14,3.62,NULL,NULL,28850.0,64.0,NULL,344.0,NULL,NULL,NULL,NULL,4,4,0,NULL,'Diesel','Detroit Diesel 8V71T',1,'450 hp',NULL,NULL,NULL,NULL,'Inertial navigation and fire control sensors',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(23,'m1a2-system-enhancement-package-main-battle-tank',9.83,3.7,2.44,NULL,63000.0,66800.0,68.0,NULL,425.0,NULL,NULL,NULL,NULL,4,4,0,NULL,'Gas turbine','Honeywell AGT1500',1,'1500 shp',NULL,NULL,NULL,NULL,'Thermal sights (IFLIR/CITV)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(24,'infantry-fighting-vehicle-m2-bradley',6.55,3.2,2.97,NULL,NULL,27000.0,66.0,NULL,480.0,NULL,NULL,NULL,NULL,3,3,6,NULL,'Diesel','Cummins VTA-903T turbosupercharged',1,'500-600 hp (373-447 kW)',NULL,NULL,NULL,NULL,'N/A (thermal imaging, FLIR sensors)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(25,'panzerhaubitze-2000',11.7,3.58,3.4,57.0,NULL,57000.0,60.0,NULL,420.0,NULL,NULL,NULL,NULL,3,5,0,NULL,'Diesel','MTU MT881 Ka-500',1,'736 kW (1000 hp)',NULL,NULL,NULL,'Phased array muzzle velocity radar','Phased array',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(26,'mim-104f',5.2,0.255,NULL,NULL,NULL,315.0,5.0,NULL,40.0,NULL,NULL,20000.0,NULL,NULL,NULL,NULL,NULL,'Solid propellant rocket motor','Aerojet Rocketdyne',1,NULL,NULL,NULL,NULL,'Ka-band active seeker','Millimeter wave AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(27,'s-300-series-eg-s-300p-s-300v',7.5,0.5,NULL,NULL,NULL,1800.0,7200.0,NULL,150.0,NULL,NULL,30000.0,NULL,4,8,NULL,NULL,'Diesel (transporters)','MAZ-543/7910 truck',NULL,NULL,NULL,NULL,NULL,'64N6 Big Bird, 30N6 Flap Lid','Surveillance / Engagement',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(28,'s-400-triumf',NULL,NULL,NULL,NULL,NULL,NULL,17000.0,NULL,400.0,NULL,NULL,30000.0,NULL,4,NULL,NULL,NULL,'Turbocharged diesel',NULL,1,NULL,NULL,NULL,NULL,'91N6E Big Bird, 92N6E Grave Stone, 96L6E Cheese Board','Phased array acquisition, fire control, surveillance',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(29,'m1126-infantry-carrier-vehicle',6.95,2.72,2.64,NULL,16500.0,19000.0,100.0,NULL,500.0,NULL,NULL,NULL,NULL,2,2,9,NULL,'Diesel','Caterpillar C7',1,'350 hp',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(30,'object-148',10.8,3.5,3.3,NULL,NULL,48000.0,90.0,NULL,500.0,NULL,NULL,NULL,NULL,3,3,0,NULL,'Diesel','ChTZ 12N360 (A-85-3A)',1,'1500 hp (1100 kW)',NULL,NULL,NULL,NULL,'26.5–40 GHz AESA (for APS)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(31,'t-72-ural-object-172m',9.53,3.59,2.22,46.0,NULL,46000.0,60.0,NULL,483.0,NULL,NULL,NULL,NULL,3,3,0,NULL,'Diesel','V-46-6',1,'780 hp',NULL,NULL,NULL,NULL,'Optical rangefinder',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(32,'aim-120-advanced-medium-range-air-to-air-missile',3.66,0.53,NULL,NULL,NULL,152.0,4.0,NULL,50.0,NULL,NULL,NULL,NULL,0,0,NULL,NULL,'Solid rocket motor','HTPB',1,NULL,NULL,NULL,NULL,'Active radar seeker','Monopulse active radar homing',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(33,'agm-84-rgm-84-ugm-84-harpoon',4.63,0.9,0.34,NULL,NULL,690.0,850.0,850.0,220.0,NULL,NULL,NULL,NULL,0,0,NULL,NULL,'Turbojet + solid rocket booster','Teledyne CAE J402',1,'~3 kN',NULL,NULL,NULL,'AN/DSQ-48','Active radar homing',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(34,'agm-114-hellfire',1.63,0.18,NULL,NULL,NULL,49.0,1600.0,NULL,11.0,NULL,NULL,NULL,NULL,0,0,NULL,NULL,'Solid-propellant rocket motor',NULL,1,NULL,NULL,NULL,NULL,NULL,'Semi-active laser homing (primary); MMW radar (Longbow variant)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(35,'gbu-313238-series',3.88,0.64,0.36,NULL,280.0,960.0,1225.0,NULL,24.0,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(36,'fgm-148-javelin',1.12,0.127,NULL,NULL,11.8,22.3,500.0,NULL,2.5,NULL,NULL,150.0,NULL,1,2,NULL,NULL,'Solid rocket motor (two-stage: launch and flight)',NULL,2,NULL,NULL,NULL,NULL,NULL,'N/A (imaging infrared seeker)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(37,'3m-543m-14-kalibr',8.22,0.53,NULL,NULL,NULL,1800.0,3700.0,980.0,220.0,NULL,NULL,NULL,NULL,0,0,NULL,NULL,'Solid propellant booster + turbojet',NULL,2,'Unknown',NULL,NULL,NULL,NULL,'Active radar homing (terminal)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(38,'gbu-43b-massive-ordnance-air-blast',9.1,1.03,NULL,NULL,NULL,9800.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(39,'scalp-eg-france-storm-shadow-uk',5.1,3.0,NULL,NULL,NULL,1300.0,980.0,980.0,250.0,NULL,NULL,NULL,NULL,0,0,NULL,NULL,'Turbojet','Microturbo TRI 60-30',1,'5.4 kN',NULL,NULL,NULL,NULL,'Terrain reference (TERPROM); imaging infrared seeker (DSMAC)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(40,'bgm-109-tomahawk-land-attack-missile-tlam',6.25,2.67,0.53,NULL,1315.0,1588.0,885.0,885.0,1600.0,NULL,NULL,50.0,NULL,0,0,NULL,NULL,'Turbofan','Williams F107/F415',1,NULL,NULL,NULL,NULL,NULL,'INS, TERCOM, DSMAC, GPS (Block IV/V)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(41,'project-22350',135.0,16.0,4.5,5400.0,NULL,5400000.0,55.0,37.0,8330.0,NULL,NULL,NULL,NULL,NULL,210,NULL,NULL,'CODAG [Military Factory](https://www.militaryfactory.com/ships/detail.php?ship_id=admiral-gorshkov-417-guided-missile-frigate-russian-navy)','2x 10D49 diesel, 2x M90FR gas turbines [Military Factory](https://www.militaryfactory.com/ships/detail.php?ship_id=admiral-gorshkov-417-guided-missile-frigate-russian-navy)',4,'65000 hp [Military Factory](https://www.militaryfactory.com/ships/detail.php?ship_id=admiral-gorshkov-417-guided-missile-frigate-russian-navy)',NULL,NULL,NULL,'Poliment, Furke-4 5P-27 [Army Recognition](https://armyrecognition.com/military-products/navy/frigates/admiral-gorshkov-class-frigate-project-22350)','AESA, 3D air-search [Army Recognition](https://armyrecognition.com/military-products/navy/frigates/admiral-gorshkov-class-frigate-project-22350)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(42,'ddg-51-arleigh-burke-class-guided-missile-destroyer',153.9,18.0,9.3,8300.0,8300.0,9700.0,55.0,NULL,8140.0,NULL,NULL,NULL,NULL,300,359,NULL,NULL,'Gas turbine','General Electric LM2500-30',4,'100,000 shp',NULL,NULL,NULL,'AN/SPY-1D / AN/SPY-6(V)1 (Flight III)','Phased array (PESA/AESA)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(43,'frgate-europenne-multi-mission-fregata-europea-multi-missione-aq',142.0,19.8,NULL,6615.0,NULL,NULL,50.0,NULL,11265.0,NULL,NULL,NULL,NULL,108,199,NULL,NULL,'CODLOG (French) / CODLAG (Italian) [Military Factory](https://www.militaryfactory.com/ships/detail.php?ship_id=fremm-multipurpose-frigate-french-navy)','MTU Series 4000 diesel; GE-Avio LM2500 gas turbine [Wikipedia](https://en.wikipedia.org/wiki/FREMM_multipurpose_frigate); [Military Factory](https://www.militaryfactory.com/ships/detail.php?ship_id=fremm-multipurpose-frigate-french-navy)',1,'32 MW (Italian GT) [Wikipedia](https://en.wikipedia.org/wiki/FREMM_multipurpose_frigate)',NULL,NULL,NULL,'Héraklès (French) / Leonardo Kronos Grand Naval MFRA (Italian) [Wikipedia](https://en.wikipedia.org/wiki/FREMM_multipurpose_frigate)','PES/A (French) / AESA 3D C-band (Italian) [Wikipedia](https://en.wikipedia.org/wiki/FREMM_multipurpose_frigate)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(44,'btiment-de-projection-et-de-commandement-bpc',199.0,32.0,6.3,21300.0,16500000.0,21300000.0,35.0,NULL,10800.0,NULL,NULL,NULL,NULL,160,200,450,NULL,'Diesel-electric','Wärtsilä 16V32 / Vaasa 18V200',4,'3 x 6.2 MW + 1 x 3 MW',NULL,NULL,NULL,'MRR3D-NG, DRBN-38A','3D multi-role, navigation/landing',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(45,'cvn-68-class-nuclear-powered-aircraft-carrier',333.0,77.0,11.0,100000.0,NULL,NULL,56.0,NULL,20.0,NULL,NULL,NULL,NULL,3000,6400,NULL,NULL,'Nuclear','2 × A4W pressurized water reactors',2,'260,000 shp (194 MW)',NULL,NULL,NULL,'AN/SPS-48E 3D air search, AN/SPS-49(V) air search','3D air search radar, 2D long range air search radar',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(46,'ohio-class',170.7,12.8,11.3,18750.0,16764000.0,18750000.0,46.0,37.0,NULL,NULL,NULL,NULL,300.0,NULL,155,66,NULL,'Nuclear','S8G PWR',1,'60,000 shp',NULL,NULL,NULL,'BPS 15A / Sonars: BQQ-6, BQR-19, BQS-13, TB-16','Sonar suite',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(47,'type-055-destroyer',180.0,20.0,NULL,13000.0,NULL,NULL,56.0,NULL,9260.0,NULL,NULL,NULL,NULL,NULL,300,NULL,NULL,'COGAG gas turbine','QC-280',4,'28 MW each',NULL,NULL,NULL,'Type 346B Dragon Eye','AESA',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(48,'type-26-city-class-frigate',149.9,20.8,NULL,6900.0,NULL,NULL,48.0,33.0,13000.0,NULL,NULL,NULL,NULL,157,208,NULL,NULL,'CODLOG (Combined diesel-electric or gas)','Rolls-Royce MT30 gas turbine + 4 diesel generators + 2 electric motors',1,'36 MW (MT30) [Navy Lookout](https://www.navylookout.com/powering-the-stealthy-submarine-hunter-type-26-frigate-propulsion-system-in-focus/); [Rolls-Royce](https://www.rolls-royce.com/products-and-services/defence/naval/gas-turbines/mt30-marine-gas-turbine.aspx)',NULL,NULL,NULL,'Type 997 Artisan 3D','3D search radar',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(49,'ssn-774-class',115.0,10.4,NULL,7900.0,NULL,NULL,46.0,NULL,NULL,NULL,NULL,NULL,240.0,NULL,145,NULL,NULL,'Nuclear','S9G reactor',1,'30 MW',NULL,NULL,NULL,'AN/BPS-16','Surface search/navigation',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
INSERT INTO "specifications" VALUES(50,'ddg-1000-class-guided-missile-destroyer',186.0,24.6,NULL,15995.0,NULL,NULL,56.0,NULL,NULL,NULL,NULL,NULL,NULL,130,197,NULL,NULL,'Integrated electric drive (gas turbine generators)','Rolls-Royce MT30',2,'78 MW total',NULL,NULL,NULL,'AN/SPY-3','Multi-Function Radar (X-band AESA)',NULL,NULL,NULL,'2026-03-11 02:10:08','2026-03-11 02:10:08');
CREATE TABLE subcategories (
    subcategory_id  TEXT PRIMARY KEY,           -- 'fighter', 'tank', 'destroyer', etc.
    category_id     TEXT NOT NULL REFERENCES categories(category_id),
    subcategory_name TEXT NOT NULL,
    description     TEXT
);
INSERT INTO "subcategories" VALUES('fighter','air','Fighter','Air superiority and multirole combat aircraft');
INSERT INTO "subcategories" VALUES('bomber','air','Bomber','Strategic and tactical bombing aircraft');
INSERT INTO "subcategories" VALUES('transport','air','Transport','Military cargo and troop transport aircraft');
INSERT INTO "subcategories" VALUES('helicopter-attack','air','Attack Helicopter','Rotary-wing attack platforms');
INSERT INTO "subcategories" VALUES('helicopter-utility','air','Utility Helicopter','Multi-purpose rotary-wing aircraft');
INSERT INTO "subcategories" VALUES('drone-combat','air','Combat Drone','Armed unmanned aerial vehicles');
INSERT INTO "subcategories" VALUES('drone-recon','air','Reconnaissance Drone','Surveillance and ISR UAVs');
INSERT INTO "subcategories" VALUES('awacs','air','AWACS/AEW','Airborne early warning and control');
INSERT INTO "subcategories" VALUES('tanker','air','Tanker','Aerial refueling aircraft');
INSERT INTO "subcategories" VALUES('trainer','air','Trainer','Military training aircraft');
INSERT INTO "subcategories" VALUES('mbt','land','Main Battle Tank','Primary armored fighting vehicles');
INSERT INTO "subcategories" VALUES('ifv','land','Infantry Fighting Vehicle','Armored troop carriers with integral weapons');
INSERT INTO "subcategories" VALUES('apc','land','Armored Personnel Carrier','Troop transport vehicles with light armor');
INSERT INTO "subcategories" VALUES('artillery-sp','land','Self-Propelled Artillery','Mobile howitzers and gun systems');
INSERT INTO "subcategories" VALUES('artillery-towed','land','Towed Artillery','Towed howitzers and guns');
INSERT INTO "subcategories" VALUES('mlrs','land','MLRS','Multiple launch rocket systems');
INSERT INTO "subcategories" VALUES('sam','land','SAM System','Surface-to-air missile systems');
INSERT INTO "subcategories" VALUES('armored-car','land','Armored Car','Wheeled armored reconnaissance vehicles');
INSERT INTO "subcategories" VALUES('mrap','land','MRAP','Mine-resistant ambush protected vehicles');
INSERT INTO "subcategories" VALUES('engineer','land','Engineer Vehicle','Combat engineering and bridging vehicles');
INSERT INTO "subcategories" VALUES('small-arms','land','Small Arms','Infantry weapons and crew-served weapons');
INSERT INTO "subcategories" VALUES('carrier','sea','Aircraft Carrier','Fleet aircraft carriers and light carriers');
INSERT INTO "subcategories" VALUES('destroyer','sea','Destroyer','Multi-mission surface combatants');
INSERT INTO "subcategories" VALUES('frigate','sea','Frigate','Escort and patrol combatants');
INSERT INTO "subcategories" VALUES('corvette','sea','Corvette','Coastal combatants');
INSERT INTO "subcategories" VALUES('submarine-ssn','sea','Nuclear Attack Submarine','Nuclear-powered attack submarines');
INSERT INTO "subcategories" VALUES('submarine-ssbn','sea','Ballistic Missile Submarine','Nuclear ballistic missile submarines');
INSERT INTO "subcategories" VALUES('submarine-ssk','sea','Conventional Submarine','Diesel-electric attack submarines');
INSERT INTO "subcategories" VALUES('amphibious','sea','Amphibious','Landing ships and assault vessels');
INSERT INTO "subcategories" VALUES('patrol','sea','Patrol Craft','Coastal and offshore patrol vessels');
INSERT INTO "subcategories" VALUES('cruiser','sea','Cruiser','Large multi-mission surface combatants');
INSERT INTO "subcategories" VALUES('aam','munition','Air-to-Air Missile','Air-launched anti-aircraft missiles');
INSERT INTO "subcategories" VALUES('agm','munition','Air-to-Ground Missile','Air-launched surface attack missiles');
INSERT INTO "subcategories" VALUES('sam-missile','munition','Surface-to-Air Missile','Ground/sea-launched anti-aircraft missiles');
INSERT INTO "subcategories" VALUES('ssm','munition','Surface-to-Surface Missile','Land/sea-attack cruise missiles');
INSERT INTO "subcategories" VALUES('bm','munition','Ballistic Missile','Ballistic missiles (tactical to ICBM)');
INSERT INTO "subcategories" VALUES('ashm','munition','Anti-Ship Missile','Anti-ship cruise missiles');
INSERT INTO "subcategories" VALUES('bomb-guided','munition','Guided Bomb','Precision-guided munitions');
INSERT INTO "subcategories" VALUES('bomb-unguided','munition','Unguided Bomb','Gravity bombs');
INSERT INTO "subcategories" VALUES('torpedo','munition','Torpedo','Anti-submarine and anti-ship torpedoes');
INSERT INTO "subcategories" VALUES('atgm','munition','Anti-Tank Guided Missile','Anti-armor missiles');
INSERT INTO "subcategories" VALUES('artillery-round','munition','Artillery Round','Shells and projectiles');
CREATE INDEX idx_platforms_category ON platforms(category_id);
CREATE INDEX idx_platforms_subcategory ON platforms(subcategory_id);
CREATE INDEX idx_platforms_country ON platforms(country_of_origin);
CREATE INDEX idx_platforms_status ON platforms(status_id);
CREATE INDEX idx_platforms_manufacturer ON platforms(manufacturer);
CREATE INDEX idx_platforms_service_year ON platforms(entered_service_year);
CREATE INDEX idx_platforms_common_name ON platforms(common_name);
CREATE INDEX idx_specs_platform ON specifications(platform_id);
CREATE INDEX idx_econ_platform ON economics(platform_id);
CREATE INDEX idx_econ_unit_cost ON economics(unit_cost_usd);
CREATE INDEX idx_operators_platform ON operators(platform_id);
CREATE INDEX idx_operators_country ON operators(country_code);
CREATE INDEX idx_armaments_platform ON armaments(platform_id);
CREATE INDEX idx_armaments_munition ON armaments(linked_munition_id);
CREATE INDEX idx_platform_conflicts_platform ON platform_conflicts(platform_id);
CREATE INDEX idx_platform_conflicts_conflict ON platform_conflicts(conflict_id);
CREATE INDEX idx_media_platform ON media(platform_id);
CREATE INDEX idx_media_type ON media(media_type);
CREATE INDEX idx_sources_platform ON sources(platform_id);
CREATE INDEX idx_changelog_platform ON changelog(platform_id);
CREATE INDEX idx_changelog_date ON changelog(changed_at);
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('specifications',50);
INSERT INTO "sqlite_sequence" VALUES('economics',48);
INSERT INTO "sqlite_sequence" VALUES('armaments',79);
INSERT INTO "sqlite_sequence" VALUES('operators',239);
INSERT INTO "sqlite_sequence" VALUES('platform_conflicts',119);
INSERT INTO "sqlite_sequence" VALUES('media',50);
INSERT INTO "sqlite_sequence" VALUES('sources',189);
COMMIT;
