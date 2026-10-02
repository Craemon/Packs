#!/usr/bin/env lua

-- 1. Define params + modules
local lib_dir = os.getenv("LIB_DIR") or error("LIB_DIR environment variable is not set!")
package.path = lib_dir .. "/scripts/modules/?.lua;" .. package.path

local vanilla = require("vanilla")

local ratio = tonumber(arg[1]) or 8.0
local ratio_str = (math.type(ratio) == "integer") and string.format("%.1f", ratio) or tostring(ratio)

-- 2. Resolve paths and create dest_dir
local src_file = vanilla.get_path("data/minecraft/dimension_type/the_nether.json")

local dest_dir = "data/minecraft/dimension_type"
local dest_file = dest_dir .. "/the_nether.json"

os.execute("mkdir -p " .. dest_dir)

-- 3. Copy action
local copy_cmd = string.format("cp %q %q", src_file, dest_file)
local success = os.execute(copy_cmd)

if not success then
    error(string.format("Failed to get %s!", src_file))
end

-- 4. Edit dimension coordinate_scale
local file, err = io.open(dest_file, "r")
if not file then
    error(string.format("Failed to open %s for reading: %s", dest_file, tostring(err)))
end

local content = file:read("*a")
file:close()

-- Match `"coordinate_scale": <number>` and replace the value with ratio_str
local updated_content, replacements = content:gsub('("coordinate_scale"%s*:%s*)[%d%.]+', '%1' .. ratio_str)

if replacements == 0 then
    io.stderr:write(string.format("Warning: 'coordinate_scale' field was not found in %s\n", dest_file))
end

local out_file, out_err = io.open(dest_file, "w")
if not out_file then
    error(string.format("Failed to open %s for writing: %s", dest_file, tostring(out_err)))
end

out_file:write(updated_content)
out_file:close()

print(string.format("Successfully set coordinate_scale to %s in %s", ratio_str, dest_file))