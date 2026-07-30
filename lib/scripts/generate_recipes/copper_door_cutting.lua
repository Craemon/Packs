#!/usr/bin/env lua

-- Generates stonecutter recipe for each copper door and trapdoor.

local waxStates = { "", "waxed_" }
local oxidationStages = { "", "exposed_", "oxidized_", "weathered_" }
local itemTypes = {
    { type = "door", count = 3 },
    { type = "trapdoor", count = 6 }
}

os.execute("mkdir -p data/crafting/recipe")

for _, waxState in ipairs(waxStates) do
    for _, oxidationStage in ipairs(oxidationStages) do
        for _, item in ipairs(itemTypes) do
            local itemId = string.format("%s%scopper_%s", waxState, oxidationStage, item.type)
            local fileName = string.format("data/crafting/recipe/%s.json", itemId)
            local file = io.open(fileName, "w")
            if file then
                file:write(string.format([[
{
  "type": "minecraft:stonecutting",
  "ingredient": [
    "minecraft:%s%scopper_block"
  ],
  "result": {
    "id": "minecraft:%s",
    "count": %d
  }
}
]], waxState, oxidationStage, itemId, item.count))
                file:close()
                print(string.format("Generated: %s.json", itemId))
            else
                error(string.format("Failed to write recipe JSON for: %s", itemId))
            end
        end
    end
end