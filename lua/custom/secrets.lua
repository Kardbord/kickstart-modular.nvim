local M = {}

---Coerce string values 'true'/'false' (case-insensitive) to booleans.
---All other values pass through unchanged.
---@param value string|nil
---@return string|boolean|nil
local function coerce_bool(value)
  if value == nil then return nil end
  local lower = value:lower()
  if lower == 'true' then return true end
  if lower == 'false' then return false end
  return value
end

---Retrieve a secret from gopass, returning nil on failure.
---@param key string The gopass store path (e.g. "openrouter/api-key")
---@return string|boolean|nil
function M.from_pass(key)
  local handle = io.popen(('gopass show %q 2>/dev/null'):format(key))
  if not handle then
    return nil
  end

  local value = handle:read '*l'

  -- Close and check exit status
  local ok = handle:close()
  if not ok then
    -- gopass exited with error; ignore the output
    return nil
  end

  -- Reject empty or whitespace-only values
  if not value or not value:match '%S' then
    return nil
  end

  return coerce_bool(value)
end

local function is_empty_or_whitespace(str)
    -- Return true if str is nil, "", or only whitespace characters
    if type(str) ~= "string" then return false end
    return str:match("^%s*$") == str
end

---Retrieve a secret from the environment, returning nil on failure.
---@param key string The name of the environment variable to check
---@return string|boolean|nil
function M.from_env(key)
  local value = os.getenv(key)
  if is_empty_or_whitespace(value) then return nil end
  return value
end

---Retrieve a secret from gopass. If it is nil, fallback to the
---environment key. Return nil on failure of both.
---@param gopasskey string The gopass store path (e.g. "openrouter/api-key").
---@param envkey string The name of the environment variable to check.
---@return string|boolean|nil
function M.from_pass_or_env(gopasskey, envkey)
  local value = M.from_pass(gopasskey)
  if value ~= nil then return value end
  value = M.from_env(envkey)
  if value == nil then
    vim.notify(
      ('secrets: could not find gopass key %q or env var %q'):format(gopasskey, envkey),
      vim.log.levels.WARN
    )
  end
  return value
end

return M
