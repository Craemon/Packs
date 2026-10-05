#!/usr/bin/env lua

-- 1. Define params + modules
local lib_dir = os.getenv("LIB_DIR") or error("LIB_DIR environment variable is not set!")
package.path = lib_dir .. "/scripts/modules/?.lua;" .. package.path

local vanilla = require("vanilla")
local files = require("files")
local texture = require("texture")

-- 2. Boat types
local chestBoats = {
    { "acacia", "boat" },
    { "bamboo", "raft" },
    { "birch", "boat" },
    { "cherry", "boat" },
    { "dark_oak", "boat" },
    { "jungle", "boat" },
    { "mangrove", "boat" },
    { "oak", "boat" },
    { "pale_oak", "boat" },
    { "poplar", "boat" },
    { "spruce", "boat" }
}

-- 3. Loop through boats
for _, row in ipairs(chestBoats) do
    local woodType = row[1]
    local vehicleType = row[2]

    local overlay_file = string.format("%s/assets/textures/item/chest_%s_xmas_overlay.png", lib_dir, vehicleType)
    local base_path = string.format("assets/minecraft/textures/item/%s_chest_%s.png", woodType, vehicleType)
    local base_file = vanilla.get_path(base_path)
    local dest_file = string.format("assets/minecraft/textures/item/%s_chest_%s.png", woodType, vehicleType)

    local ok, err = texture.merge(base_file, overlay_file, dest_file)
    if not ok then
        io.stderr:write(string.format("Warning: Failed to process %s_%s: %s\n", woodType, vehicleType, tostring(err)))
    else
        print(string.format("  [+] Merged %s and %s -> %s", base_file, overlay_file, dest_file))
    end
end

print("Successfully generated Christmas chest boat item textures!")