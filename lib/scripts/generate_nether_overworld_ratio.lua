#!/usr/bin/env lua

-- 1. Define params + modules
local lib_dir = os.getenv("LIB_DIR") or error("LIB_DIR environment variable is not set!")
package.path = lib_dir .. "/scripts/modules/?.lua;" .. package.path

local vanilla = require("vanilla")
local files = require("files")

local ratio = tonumber(arg[1]) or 8.0
local ratio_str = (math.type(ratio) == "integer") and string.format("%.1f", ratio) or tostring(ratio)

local rel_path = "data/minecraft/dimension_type/the_nether.json"
local src_file = vanilla.get_path(rel_path)

-- 2. Read vanilla content
local content, err = files.read(src_file)
if not content then error(err) end

-- 3. Match `"coordinate_scale": <number>` and replace the value with ratio_str
local updated_content, replacements = content:gsub('("coordinate_scale"%s*:%s*)[%d%.]+', '%1' .. ratio_str)

if replacements == 0 then
    io.stderr:write(string.format("Warning: 'coordinate_scale' field was not found in %s\n", src_file))
end

-- 4. Write modified output
local ok, write_err = files.write(rel_path, updated_content)
if not ok then error(write_err) end

print(string.format("Successfully set coordinate_scale to %s in %s", ratio_str, rel_path))