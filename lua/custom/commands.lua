vim.api.nvim_create_user_command('Update', function()
  local function log(msg)
    vim.notify(msg)
    vim.cmd('redraw')
  end

  log('Updating Treesitter parsers...')
  require('nvim-treesitter.install').update { with_sync = true }

  log('Updating Mason packages...')
  local registry = require 'mason-registry'
  registry.refresh(function()
    local installed = registry.get_installed_packages()
    for _, pkg in ipairs(installed) do
      if not pkg:is_installing() then
        local installed_version = pkg:get_installed_version()
        local latest_version = pkg:get_latest_version()
        if installed_version ~= latest_version then
          log(('  Updating %s (%s -> %s)'):format(pkg.name, installed_version or '?', latest_version))
          pkg:install({ version = latest_version, force = true })
        end
      end
    end
  end)

  log('Cleaning unused plugins...')
  require('lazy').clean { show = false }

  log('Updating Lazy plugins...')
  require('lazy').update { show = false }

  log('Update complete.')
end, { desc = 'Update all plugins and dependencies (Treesitter, Mason, Lazy)' })
