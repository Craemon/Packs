#!/usr/bin/env lua

local unpack = table.unpack or unpack

local function contains(tbl, value)
    for _, val in ipairs(tbl) do
        if val == value then return true end
    end
    return false
end

-- permutations
local function stepDFS(items, current, results)
    current = current or {}
    results = results or {}

    -- base case
    if #current == #items then
        table.insert(results, { unpack(current) })
        return results
    end

    -- explore
    for _, item in ipairs(items) do
        if not contains(current, item) then
            table.insert(current, item)
            stepDFS(items, current, results)
            table.remove(current)
        end
    end

    return results
end

local function getPermutations(items)
    if #items == 0 then return {} end
    return stepDFS(items)
end

-- main recipe generation

os.execute("mkdir -p data/crafting/recipe")

local items = { "C", "D", "E", "F" }
local perms = getPermutations(items)

for i, p in ipairs(perms) do
    local top, bottom, left, right = p[1], p[2], p[3], p[4]
    local fileName = string.format("data/crafting/recipe/budding_amethyst_%02d.json", i)
    local file = io.open(fileName, "w")

    if file then
        file:write(string.format([[
{
  "type": "minecraft:crafting_shaped",
  "group": "budding_amethyst",
  "pattern": [
    " %s ",
    "%sB%s",
    " %s "
  ],
  "key": {
    "B": "minecraft:amethyst_block",
    "C": "minecraft:small_amethyst_bud",
    "D": "minecraft:medium_amethyst_bud",
    "E": "minecraft:large_amethyst_bud",
    "F": "minecraft:amethyst_cluster"
  },
  "result": {
    "id": "minecraft:budding_amethyst",
    "count": 1
  }
}
]], top, left, right, bottom))
        file:close()
        print(string.format("Generated: budding_amethyst_%02d.json", i))
    else
        error(string.format("Failed to write recipe JSON for index: %d", i))
    end
end