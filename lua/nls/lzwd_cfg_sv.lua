print("LzWD > Config init")

-- Put workshop addon IDs (strings, not numbers, no tailing zeros)
-- No need to putting lua-only addons (AddCSLuaFile does all the work)
LzWDAddons = {
    "1095903501", -- Episodic NPC Model Fix
    "104607228", -- Fire Extinguisher
    "422672588", -- Fortification Props Model Pack
    "206166550", -- Sabre-aN's Headcrab Zombie Mod
    "173482196", -- SProps Workshop Edition
    "737640184", -- Tank Track Tool
    "430077474", -- ZONA Stalker Props Pack [1/4] [Base]
    "430106735", -- ZONA Stalker Props Pack [2/4]
    "430147227", -- ZONA Stalker Props Pack [3/4]
    "430453978", -- ZONA Stalker Props Pack [4/4]
    "2131057232", -- [ArcCW] Arctic's Customizable Weapons (Base Only)
    "2131058270", -- [ArcCW] Counter-Strike +
    "2180241115", -- [ArcCW] (Unofficial) Counter-Strike ++
    "2175261690", -- [ArcCW] FA:S1 Reanimated
    "669642096", -- Drones Rewrite
    "771487490", -- [simfphys] LUA Vehicles - Base
    "831680603", -- [simfphys] armed vehicles
    "733907245", -- Old Aperture Science Props - 1 / 2
    "733929512", -- Old Aperture Science Props - 2 / 2
    "1571918906", -- [LFS] - Planes
    "2152057074", -- [LFS] MI-8
    "2128302809", -- [LFS] MH-53J
    "310835919", -- Half-Life 2 Leak Props: Complete
    "2015077130", -- Half-Life Alyx Buildings
    "2415018270", -- [Half Life: Alyx] Combine Props
    "2019244401", -- Half-Life: Alyx JerryCan 
    "2088387376", -- Half-Life: Alyx - Interior prop's pack
    "2062854187", -- Half-Life: Alyx - city 17 props
    "2043900984", -- [Half Life: Alyx] Infestation Control props
    "2216838577", -- [Half Life: Alyx] Consumables Misc (Props)
    "2228994615", -- [Half Life: Alyx] Xen Pack (Props)
    "2068660504", -- Half-Life: Alyx - Combine Animated Prop's Pack
    "2387653976", -- Half-Life: Alyx Inspired Combine Walkway Props
    "1551672122", -- Half-Life 2 Signs Prop Pack
    "1630133157", -- Half-Life 2 - Altered Combine Turrets & Cameras.
    "309312780", -- Half-Life 2 Beta: Map Props Pack
    "105586117", -- STALKER building props
    "2480467373", -- Black Mesa Marines Props
    "110607312", -- Black Mesa (2012 Mod Version) Lab Models
    "522292706", -- [UNSUPPORTED] Schnitzel's COMPLETE Office Prop Pack [UNSUPPORTED]
    "2546157752", -- Stockplus - More Construct Props
    "2427426465", -- Enterable Razor Train
    "1920269234", -- Episode 1 Combine Train
    --"2574767607", -- Accurate Collision Models Pack (Half-Life 2, Episode 1, Episode 2)
    --"2560698881", -- Better Collision for Pods
    "195250334", -- Red Combine Skins.
    "2482496228", -- HL2 Combine prop pack
    "811578093", -- CCA Technology Props
    "2100793947", -- Raising the Bar: Redux: Prop Models
    "284266415", -- Sci-fi Props Megapack
    "104477476", -- Misc Props Pack

    -- For resources, lua installed locally
    "160250458", -- Wiremod
    "420325009", -- MeshCloth
    "104691717", -- PAC3
    "1525218777", -- vFire - Dynamic Fire for Garry's Mod
    "1525572545", -- vFire Flamethrower
    "1615992780", -- ProWolf's Zone Tool
}

print("LzWD > Config init finished")