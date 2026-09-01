#!/usr/bin/env lua

-- Generates recipes for horse armor.

local materials = {
    { "copper", "copper_ingot" },
    { "diamond", "diamond" },
    { "golden", "gold_ingot" },
    { "iron", "iron_ingot" },
}

os.execute("mkdir -p data/craemon/recipe")

for rowIndex, row in ipairs(materials) do
    local material = row[1]
    local ingredient = row[2]
    local fileName = string.format("data/craemon/recipe/%s_horse_armor.json", material)

    local file = io.open(fileName, "w")
    if file then
        file:write(string.format([[
{
    "type": "minecraft:crafting_shaped",
    "category": "equipment",
    "pattern": [
        "# #",
        "###",
        "# #"
    ],
    "key": {
        "#": "minecraft:%s"
    },
    "result": {
        "id": "minecraft:%s_horse_armor",
        "count": 1
    }
}
]], ingredient, material))
        file:close()
        print(string.format("Generated: %s_horse_armor.json", material))
    else
        error(string.format("Failed to write recipe JSON for: %s", material))
    end
end