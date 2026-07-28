#!/usr/bin/env lua

local rawId = os.getenv("PACK_ID") or "unknown-pack"
local cleanId = string.gsub(rawId, "%-", "_")
local name = os.getenv("PACK_NAME") or "Unknown Pack"

local iconId = arg[1] or "minecraft:dirt"
local description = arg[2] or "Unknown description!"

os.execute("mkdir -p data/craemon/advancement")

local fileName = string.format("data/craemon/advancement/%s.json", cleanId)

local file = io.open(fileName, "w")
if file then
    file:write(string.format([[
{
    "display": {
        "icon": {
            "id": "%s"
        },
        "title": "%s",
        "description": "%s",
        "frame": "task",
        "show_toast": false,
        "announce_to_chat": false
    },
    "parent": "craemon:crafting",
    "criteria": {
        "tick": {
            "trigger": "minecraft:tick"
        }
    }
}
]], iconId, name, description))
        file:close()
        print(string.format("Generated: %s", fileName))
else
    error(string.format("Failed to write advancement JSON for: %s", fileName))
end