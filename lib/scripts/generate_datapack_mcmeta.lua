#!/usr/bin/env lua5.5

local data_format = os.getenv("GLOBAL_DATAPACK_VERSION") or "107.1"
local mc_version = os.getenv("GLOBAL_MINECRAFT_VERSION") or "26.2"
local pack_version = os.getenv("PACK_VERSION") or "1.0.0"
local author = os.getenv("PACK_AUTHOR") or "Craemon"

local major, minor = data_format:match("([^.]+).?([^.]*)")
major = tonumber(major) or 107
minor = tonumber(minor) or 0

local desc_string = string.format("§e by §3 %s §e version §2 %s (%s)", author, mc_version, pack_version)

local file = io.open("pack.mcmeta", "w")
if file then
    file:write(string.format([[
{
  "pack": {
    "description": "%s",
    "min_format": [%d,%d],
    "max_format": [%d,%d]
  }
}
]], desc_string, major, minor, major, minor))
    file:close()
    print("Generated data pack.mcmeta successfully.")
else
    error("Failed to write data pack.mcmeta")
end