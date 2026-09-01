#!/usr/bin/env lua

-- Generates recipe for each coral block dead and alive.

local livingStates = { "", "dead_" }
local coralTypes = { "brain", "bubble", "fire", "horn", "tube" }

os.execute("mkdir -p data/craemon/recipe")

for _, livingState in ipairs(livingStates) do
    for _, coralType in ipairs(coralTypes) do
        local itemId = string.format("%s%s_coral_block", livingState, coralType)
        local tagIdentifier = string.format("#craemon:%s%s_corals", livingState, coralType)
        local fileName = string.format("data/craemon/recipe/%s.json", itemId)
        local file = io.open(fileName, "w")

        if file then
            file:write(string.format([[
{
  "type": "minecraft:crafting_shaped",
  "category": "building",
  "group": "coral_blocks",
  "pattern": [
    "###",
    "###",
    "###"
  ],
  "key": {
    "#": "%s"
  },
  "result": {
    "count": 1,
    "id": "minecraft:%s"
  }
}
]], tagIdentifier, itemId))
            file:close()
            print(string.format("Generated: %s.json", itemId))
        else
            error(string.format("Failed to write recipe JSON for: %s", itemId))
        end
    end
end