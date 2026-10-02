#!/usr/bin/env lua

-- 1. Define params + modules
local lib_dir = os.getenv("LIB_DIR") or error("LIB_DIR environment variable is not set!")
package.path = lib_dir .. "/scripts/modules/?.lua;" .. package.path

local vanilla = require("vanilla")
local json = require("thirdparty.dkjson")

-- 2. Biomes
local biomes = {
    "badlands", "birch_forest", "cherry_grove", "cold_ocean", "dark_forest", "desert", "flower_forest", "forest",
    "frozen_peaks", "frozen_river", "grove", "jungle", "lukewarm_ocean", "mangrove_swamp", "meadow", "ocean",
    "pale_garden", "plains", "river", "snowy_plains", "sparse_jungle", "swamp", "taiga", "warm_ocean"
}

-- 3. Define dest_dir
local dest_dir = "data/custom_biomes/worldgen/biome"
os.execute("mkdir -p " .. dest_dir)

-- 4. Hostile mob removing function
local function rm_monsters(json_content)
    local data, _, err = json.decode(json_content, 1, nil)
    if err then
        io.stderr:write("JSON decode error: " .. tostring(err) .. "\n")
        return nil
    end

    if data and data.attributes and data.attributes["minecraft:gameplay/natural_mob_spawns"] then
        local mob_spawns = data.attributes["minecraft:gameplay/natural_mob_spawns"]
        if mob_spawns.argument and mob_spawns.argument.spawns_by_category then
            mob_spawns.argument.spawns_by_category.monster = nil
        end
    end
    return json.encode(data, { indent = true })
end

-- 5. Copy and edit Biomes
for _, biome in ipairs(biomes) do
    local relative_src = string.format("data/minecraft/worldgen/biome/%s.json", biome)
    local src_file = vanilla.get_path(relative_src)
    local dest_file = string.format("%s/%s_ominous.json", dest_dir, biome)

    local file, err = io.open(src_file, "r")
    if not file then
        io.stderr:write(string.format("Warning: Failed to read %s: %s\n", src_file, tostring(err)))
    else
        local content = file:read("*a")
        file:close()

        local updated_content = rm_monsters(content)
        if updated_content then
            local out_file, out_err = io.open(dest_file, "w")
            if not out_file then
                error(string.format("Failed to open %s for writing: %s", dest_file, tostring(out_err)))
            end

            out_file:write(updated_content)
            out_file:close()

            print(string.format("  [+] Created %s_ominous.json", biome))
        end
    end
end

print("Successfully generated ominous biomes!")