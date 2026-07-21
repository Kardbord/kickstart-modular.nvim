local M = {}

---Retrieve a secret from gopass, returning nil on failure.
---@param key string The gopass store path (e.g. "openrouter/api-key")
---@return string|nil
function M.from_pass(key)
  local handle = io.popen(('gopass show %q 2>/dev/null'):format(key))
  if not handle then
    return nil
  end
  local value = handle:read '*l'
  handle:close()
  return value
end

return M
