local M = {}

local lib_dir = os.getenv("LIB_DIR") or error("LIB_DIR environment variable is not set!")
local mc_version = os.getenv("GLOBAL_MINECRAFT_VERSION") or error("GLOBAL_MINECRAFT_VERSION environment variable is not set!")

-- Resolve path based on env vars
function M.get_path(relative_path)
    relative_path = relative_path:gsub("^/", "")
    return string.format("%s/vanilla/%s/%s", lib_dir, mc_version, relative_path)
end

return M