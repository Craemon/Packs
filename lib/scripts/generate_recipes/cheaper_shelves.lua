#!/usr/bin/env lua

-- Generates cheaper shelf recipe for each wood type.

local woodTypes = {
    { "acacia", "log" },
    { "bamboo", "block" },
    { "birch", "log" },
    { "cherry", "log" },
    { "crimson", "stem" },
    { "dark_oak", "log" },
    { "jungle", "log" },
    { "mangrove", "log" },
    { "oak", "log" },
    { "pale_oak", "log" },
    { "spruce", "log" },
    { "warped", "stem" }
}

os.execute("mkdir -p data/minecraft/recipe")

for rowIndex, row in ipairs(woodTypes) do
    local woodType = row[1]
    local blockType = row[2]
    local fileName = string.format("data/minecraft/recipe/%s_shelf.json", woodType)

    local file = io.open(fileName, "w")
    if file then
        file:write(string.format([[
{
    "type": "minecraft:crafting_shaped",
    "category": "misc",
    "group": "shelf",
    "pattern": [
        "LLL",
        "   ",
        "LLL"
    ],
    "key": {
        "L": "minecraft:stripped_%s_%s"
    },
    "result": {
        "id": "minecraft:%s_shelf",
        "count": 12
    }
}
]], woodType, blockType, woodType))
        file:close()
        print(string.format("Generated: %s_shelf.json", woodType))
    else
        error(string.format("Failed to write recipe JSON for: %s", woodType))
    end
end