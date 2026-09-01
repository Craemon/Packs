#!/usr/bin/env lua

-- Generates item tags for each coral variant (dead and alive).

local livingStates = { "", "dead_" }
local coralTypes = { "brain", "bubble", "fire", "horn", "tube" }

local tagDir = "data/craemon/tags/item"
os.execute("mkdir -p " .. tagDir)

for _, livingState in ipairs(livingStates) do
    for _, coralType in ipairs(coralTypes) do
        local tagId = string.format("%s%s_corals", livingState, coralType)
        local coralItem = string.format("minecraft:%s%s_coral", livingState, coralType)
        local coralFanItem = string.format("minecraft:%s%s_coral_fan", livingState, coralType)

        local fileName = string.format("%s/%s.json", tagDir, tagId)
        local file = io.open(fileName, "w")

        if file then
            file:write(string.format([[
{
  "values": [
    "%s",
    "%s"
  ]
}
]], coralItem, coralFanItem))
            file:close()
            print(string.format("Generated Tag: %s.json", tagId))
        else
            error(string.format("Failed to write tag JSON for: %s", tagId))
        end
    end
end