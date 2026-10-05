#!/usr/bin/env lua

-- 1. Define params + modules
local lib_dir = os.getenv("LIB_DIR") or error("LIB_DIR environment variable is not set!")
package.path = lib_dir .. "/scripts/modules/?.lua;" .. package.path

local vanilla = require("vanilla")
local files = require("files")
local texture = require("texture")

-- 2. Horse types with chests
local horses = { "donkey", "mule" }

-- 3. Overlay texture
local overlay_file = string.format("%s/assets/textures/entity/horse/xmas_chest_overlay.png", lib_dir)

-- 4. Loop through horses
for _, horse_type in ipairs(horses) do
    local base_path = string.format("assets/minecraft/textures/entity/horse/%s.png", horse_type)
    local base_file = vanilla.get_path(base_path)
    local dest_file = string.format("assets/minecraft/textures/entity/horse/%s.png", horse_type)

    local ok, err = texture.merge(base_file, overlay_file, dest_file)
    if not ok then
        io.stderr:write(string.format("Warning: Failed to process %s: %s\n", horse_type, tostring(err)))
    else
        print(string.format("  [+] Merged %s and %s -> %s", base_file, overlay_file, dest_file))
    end
end

print("Successfully generated Christmas horse textures!")