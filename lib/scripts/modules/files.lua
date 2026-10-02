local M = {}

--- Reads raw string/bytes content from any absolute or relative path on disk.
-- @param path string Target file path to read
-- @return string|nil content, string|nil error_message
function M.read(path)
    local file, err = io.open(path, "r")
    if not file then
        return nil, string.format("Failed to open file for reading [%s]: %s", path, tostring(err))
    end

    local content = file:read("*a")
    file:close()
    return content
end

--- Writes raw string/bytes content directly to a destination path,
-- automatically creating intermediate directories if necessary.
-- @param dest_path string Target file path in the workspace
-- @param content string Raw string or binary content to write
-- @return boolean success, string|nil error_message
function M.write(dest_path, content)
    dest_path = dest_path:gsub("^/", "")

    local dir = dest_path:match("(.+)/[^/]+$")
    if dir then
        os.execute("mkdir -p " .. dir)
    end

    local file, err = io.open(dest_path, "w")
    if not file then
        return false, string.format("Failed to open path for writing [%s]: %s", dest_path, tostring(err))
    end

    file:write(content)
    file:close()
    return true
end

return M