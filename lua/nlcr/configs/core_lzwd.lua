return {
    -- Put workshop addon IDs (strings, not numbers, no tailing zeros)
    -- No need to putting lua-only addons (AddCSLuaFile does all the work)
    Connection = {
        --"1267236756", -- Helix content
        "1095903501", -- Episodic NPC Model Fix
        "104607228", -- Fire Extinguisher
        "737640184", -- Tank Track Tool
        "173482196", -- SProps Workshop Edition
        "2131057232", -- [ArcCW] Arctic's Customizable Weapons (Base Only)
        "2131058270", -- [ArcCW] Counter-Strike +
        "2180241115", -- [ArcCW] (Unofficial) Counter-Strike ++
        "2175261690", -- [ArcCW] FA:S1 Reanimated
        "131759821", -- VJ Base
        "213515639", -- Emplacements
        "160250458", -- Wiremod
        "420325009", -- MeshCloth
        "104691717", -- PAC3
        "1525218777", -- vFire - Dynamic Fire for Garry's Mod
        "1525572545", -- vFire Flamethrower
        "1615992780", -- ProWolf's Zone Tool
        "2458909924", -- Prop2Mesh
        "2414556240", -- Advanced Material 2
        "1771608619", -- Arctic's Vehicle Extension
        "1940264801", -- Multiple Advanced RT Cameras
        "104486597", -- NPC Tools
    },
    ConnectionMaps = {
        gm_bigcity_improved = {
            "815782148", -- gm_bigcity_improved
        },
        gm_freespace_13 = {
            "115510325", -- Freespace 13
        },
        gm_fork = {
            "326332456", -- gm_fork
        },
        gm_novenka = {
            "2049617805", -- gm_novenka
        },
        rp_darkscape = {
            "2272131829", -- Darkscape
        },
        rp_outercanals = {
            "119420070", -- rp_outercanals
        },
        -- "2436746696", -- GM Deep Blue | An Ocean Sandbox Map
        gm_excess_islands = {
            "115250988", -- gm_excess_islands
        },
        gm_goldencity_v2 = {
            "2501718455", -- gm_goldencity_v2
        },
        gm_boreas = {
            "1572373847", -- gm_boreas
        },
        gm_vyten = {
            "1449731878", -- gm_vyten
        },
        rp_apocalypse = {
            "104522041", -- rp_apocalypse
        },
        rp_apocalypse_remaster = {
            "2241746053", -- rp_apocalypse_remaster
        },
        gm_russia = {
            "2634728857", -- gm_russia
        },
        gm_goldencity_v2_day = {
            "2637442004", -- gm_goldencity_v2_day
        },
        gm_shambles = {
            "151544081", -- gm_Shambles
        },
        gm_shambles_day = {
            "191110821", -- gm_Shambles_day
        },
        rp_ineu_valley_2 = {
            "232486601", -- RP Ineu Valley 2
        },
        rp_ineu_valley = {
            "129218683", -- RP Ineu Valley
        },
        rp_c8_edit_v3b = {
            "788514527", -- rp_c8_edit_v3b
            "1406336883", -- C8 V3b Content Pack
        },
        rp_whiteforest_v1 = {
            "1092866261", -- rp_whiteforest_v1
        },
        gm_genesis = {
            "266666023", -- gm_genesis
        },
        gm_sn_waterside = {
            "380423212", -- gm_sn_waterside - SN Waterside
        },
        rp_suo = {
            "107278524", -- Rp_Suo
        },
        rp_salvation = {
            "446568070", -- rp_salvation
        },
        gm_valley = {
            "104483504", -- gm_Valley
        },
        gm_marsh = {
            "878761545", -- GM_MARSH
        },
        rp_limansk_cs = {
            "1832136981", -- ?????????????? (???????????? ????????)
        },
        gm_arid_valley_v2_day = {
            "510346779", -- GM Arid Valley V2 Day
        },
        gm_arid_valley_v2_night = {
            "510347812", -- GM Arid Valley V2 Night
        },
        rp_industrial17_v1 = {
            "171962560", -- rp_industrial17_v1
        },
        gm_vault = {
            "2668557938", -- GM Vault
        },
        rp_outercanals_winter = {
            "107641602", -- rp_outercanals_winter
        }
    },
    Deferred = {
        "422672588", -- Fortification Props Model Pack
        "430077474", -- ZONA Stalker Props Pack [1/4] [Base]
        "430106735", -- ZONA Stalker Props Pack [2/4]
        "430147227", -- ZONA Stalker Props Pack [3/4]
        "430453978", -- ZONA Stalker Props Pack [4/4]
        "669642096", -- Drones Rewrite
        "771487490", -- [simfphys] LUA Vehicles - Base
        "831680603", -- [simfphys] armed vehicles
        "733907245", -- Old Aperture Science Props - 1 / 2
        "733929512", -- Old Aperture Science Props - 2 / 2
        "1571918906", -- [LFS] - Planes
        "2152057074", -- [LFS] MI-8
        "2128302809", -- [LFS] MH-53J
        "310835919", -- Half-Life 2 Leak Props: Complete
        --"2015077130", -- Half-Life Alyx Buildings
        "2415018270", -- [Half Life: Alyx] Combine Props
        --"2088387376", -- Half-Life: Alyx - Interior prop's pack
        --"2062854187", -- Half-Life: Alyx - city 17 props
        "2043900984", -- [Half Life: Alyx] Infestation Control props
        --"2216838577", -- [Half Life: Alyx] Consumables Misc (Props)
        "2228994615", -- [Half Life: Alyx] Xen Pack (Props)
        --"2068660504", -- Half-Life: Alyx - Combine Animated Prop's Pack
        "2387653976", -- Half-Life: Alyx Inspired Combine Walkway Props
        "1551672122", -- Half-Life 2 Signs Prop Pack
        "1630133157", -- Half-Life 2 - Altered Combine Turrets & Cameras.
        "309312780", -- Half-Life 2 Beta: Map Props Pack
        "105586117", -- STALKER building props
        "2480467373", -- Black Mesa Marines Props
        "110607312", -- Black Mesa (2012 Mod Version) Lab Models
        "522292706", -- [UNSUPPORTED] Schnitzel's COMPLETE Office Prop Pack [UNSUPPORTED]
        "2546157752", -- Stockplus - More Construct Props
        --"2427426465", -- Enterable Razor Train
        "1920269234", -- Episode 1 Combine Train
        --"2574767607", -- Accurate Collision Models Pack (Half-Life 2, Episode 1, Episode 2)
        --"2560698881", -- Better Collision for Pods
        "195250334", -- Red Combine Skins.
        "2482496228", -- HL2 Combine prop pack
        "811578093", -- CCA Technology Props
        --"2100793947", -- Raising the Bar: Redux: Prop Models
        "284266415", -- Sci-fi Props Megapack
        --"566678693", -- Half-life 2+ SNPCs
        --"106466767", -- Neo Heavy Combine
        "1187432060", -- [VJ Base] Assault Synth SNPC
        "1358179694", -- [VJ Base] Combine Synth Soldier NPCs
        --"1416951128", -- Civilians NPCs (VJ)
        --"2051259080", -- [VJ] Headcrab Infection System
        "2548809283", -- Half-Life Resurgence
        --"1536251090", -- S.T.A.L.K.E.R. Anomalies
        --"2485183074", -- [VJ] S.T.A.L.K.E.R. "????????????????"
        "2052642961", -- SNPC Particle Resource Pack
        "2168210817", -- Half-Life Alyx: Antlions
        --"1470158687", -- Full Integrated Animation P.M. for NPCs HL2
        --"1839725372", -- [VJ] H??LF - LIFE ?? SNPCs
        --"173344427", -- Black Mesa SNPCs
        --"1934774464", -- [VJ] Black Mesa Source : XEN NPC
        --"1958369912", -- [vj] BLACK MESA : XEN NPC V2
        --"1163787295", -- [VJ]BLACK MESA Expand NPC:XEN&Vehicles
        --"1255758317", -- Black Mesa Expand NPC (Models pack2)
        --"1255726751", -- Black mesa expand npc (models pack1)
        "860373684", -- [simfphys] HL2 Pre-war vehicles Reworked
        --"1773030130", -- [VJ] Melee Weapons
        "2639959090", -- Manable Emplacements
        "2455542073", -- Soviet Electronics Prop Pack (SnowDrop Escape)
        --"2555075836", -- Combine Interface Remake [REPLACER]
        "2639090544", -- CONRED ?????????????? [BETA]
        "2512558788", -- Armored Combat Extended [OFFICIAL]
        "2434394990", -- Spacebuild 3 Enchancement Pack unofficial update 
        "822075881", -- Groundwatch
        "741788352", -- Airwatch
        "2726040766", -- [LFS] HAUNEBU
        "1863383098", -- [LFS] Huey Gunship
        "2146048057", -- [LFS] UH1 PACK
        "2430517668", -- [LFS/prop] Ceph Scout
        "2361275266", -- Stalker Vehicles Pack
        "2199678187", -- [simfphys] AGR
        "2126097529", -- [simfphys] IVECO pack
        "2163922384", -- [simfphys] BTR 80/80A
    }
}