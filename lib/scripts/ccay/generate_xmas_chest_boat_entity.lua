#!/usr/bin/env lua

-- 1. Define params + modules
local lib_dir = os.getenv("LIB_DIR") or error("LIB_DIR environment variable is not set!")
package.path = lib_dir .. "/scripts/modules/?.lua;" .. package.path

local vanilla = require("vanilla")
local files = require("files")
local texture = require("texture")

-- 2. Boat types
local chestBoats = { "acacia", "bamboo", "birch", "cherry", "dark_oak", "jungle", "mangrove", "oak", "pale_oak", "poplar", "spruce" }

-- 3. Overlay texture
local overlay_file = string.format("%s/assets/textures/entity/chest_boat/xmas_overlay.png", lib_dir)

-- 4. Loop through boats
for _, boat in ipairs(chestBoats) do
    local base_path = string.format("assets/minecraft/textures/entity/chest_boat/%s.png", boat)
    local base_file = vanilla.get_path(base_path)
    local dest_file = string.format("assets/minecraft/textures/entity/chest_boat/%s.png", boat)

    local ok, err = texture.merge(base_file, overlay_file, dest_file)
    if not ok then
        io.stderr:write(string.format("Warning: Failed to process %s: %s\n", boat, tostring(err)))
    else
        print(string.format("  [+] Merged %s and %s -> %s", base_file, overlay_file, dest_file))
    end
end

print("Successfully generated Christmas chest boat textures!")