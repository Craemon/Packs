#!/usr/bin/env lua

-- 1. Define params + modules
local lib_dir = os.getenv("LIB_DIR") or error("LIB_DIR environment variable is not set!")
package.path = lib_dir .. "/scripts/modules/?.lua;" .. package.path

local vanilla = require("vanilla")
local files = require("files")
local json = require("thirdparty.dkjson")

-- 2. Biomes
local biomes = {
    "badlands", "birch_forest", "cherry_grove", "cold_ocean", "dark_forest", "desert", "flower_forest", "forest",
    "frozen_peaks", "frozen_river", "grove", "jungle", "lukewarm_ocean", "mangrove_swamp", "meadow", "ocean",
    "pale_garden", "plains", "river", "snowy_plains", "sparse_jungle", "swamp", "taiga", "warm_ocean"
}

-- 3. Hostile mob removing function
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

-- 4. Process Biomes
for _, biome in ipairs(biomes) do
    local relative_src = string.format("data/minecraft/worldgen/biome/%s.json", biome)
    local src_file = vanilla.get_path(relative_src)
    local dest_file = string.format("data/custom_biomes/worldgen/biome/%s_ominous.json", biome)

    local content, err = files.read(src_file)
    if not content then
        io.stderr:write(string.format("Warning: Failed to read %s: %s\n", src_file, tostring(err)))
    else
        local updated_content = rm_monsters(content)
        if updated_content then
            local ok, write_err = files.write(dest_file, updated_content)
            if not ok then
                error(write_err)
            end

            print(string.format("  [+] Created %s_ominous.json", biome))
        end
    end
end

print("Successfully generated ominous biomes!")