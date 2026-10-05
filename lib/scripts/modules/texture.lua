local M = {}

--- Merges multiple PNG layers (ordered bottom-to-top) into a single output image.
-- @param layers table Array of file paths: { base_path, layer1_path, layer2_path, ... }
-- @param dest_path string Destination path for the final merged image
-- @return boolean success, string|nil error_message
function M.merge_layers(layers, dest_path)
    if not layers or #layers < 2 then
        return false, "At least 2 layers are required to perform a merge"
    end

    -- Ensure destination directory exists
    local dir = dest_path:match("(.+)/[^/]+$")
    if dir then
        os.execute("mkdir -p " .. dir)
    end

    -- Escape paths for shell execution
    local escaped_layers = {}
    for i, path in ipairs(layers) do
        escaped_layers[i] = string.format("%q", path)
    end

    -- ImageMagick 7 composite command
    local input_chain = table.concat(escaped_layers, " ")
    local cmd = string.format("magick %s -composite %q", input_chain, dest_path)

    local ok = os.execute(cmd)
    if not ok then
        return false, string.format("Failed to merge %d layers into %s", #layers, dest_path)
    end

    return true
end

--- Convenience wrapper for 2-layer merges
function M.merge(base_path, overlay_path, dest_path)
    return M.merge_layers({ base_path, overlay_path }, dest_path)
end

return M