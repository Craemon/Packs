#!/usr/bin/env lua

-- 1. Define params + modules
local lib_dir = os.getenv("LIB_DIR") or error("LIB_DIR environment variable is not set!")
package.path = lib_dir .. "/scripts/modules/?.lua;" .. package.path

local vanilla = require("vanilla")
local files = require("files")
local texture = require("texture")

-- 2. Llama types
local llamas = { "brown", "creamy", "gray", "white" }

-- 3. Overlay texture
local overlay_file = string.format("%s/assets/textures/entity/llama/xmas_chest_overlay.png", lib_dir)

-- 4. Loop through llamas
for _, color in ipairs(llamas) do
    local base_path = string.format("assets/minecraft/textures/entity/llama/llama_%s.png", color)
    local base_file = vanilla.get_path(base_path)
    local dest_file = string.format("assets/minecraft/textures/entity/llama/llama_%s.png", color)

    local ok, err = texture.merge(base_file, overlay_file, dest_file)
    if not ok then
        io.stderr:write(string.format("Warning: Failed to process %s: %s\n", color, tostring(err)))
    else
        print(string.format("  [+] Merged %s and %s -> %s", base_file, overlay_file, dest_file))
    end
end

print("Successfully generated Christmas llama textures!")