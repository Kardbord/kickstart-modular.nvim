vim.api.nvim_create_user_command('LspEnable', function(opts)
  vim.cmd('lsp enable' .. (opts.args and ' ' .. opts.args or ''))
end, { desc = 'Enable LSP config for current buffer (alias for :lsp enable)', bang = true, nargs = '?' })

vim.api.nvim_create_user_command('LspDisable', function(opts)
  vim.cmd('lsp disable' .. (opts.args and ' ' .. opts.args or ''))
end, { desc = 'Disable LSP config for current buffer (alias for :lsp disable)', bang = true, nargs = '?' })

vim.api.nvim_create_user_command('LspStop', function(opts)
  vim.cmd('lsp stop' .. (opts.args and ' ' .. opts.args or ''))
end, { desc = 'Stop LSP client(s) for current buffer (alias for :lsp stop)', bang = true, nargs = '?' })

vim.api.nvim_create_user_command('LspRestart', function(opts)
  vim.cmd('lsp restart' .. (opts.args and ' ' .. opts.args or ''))
end, { desc = 'Restart LSP client(s) for current buffer (alias for :lsp restart)', bang = true, nargs = '?' })

vim.api.nvim_create_user_command('LspInfo', function()
  vim.cmd('checkhealth vim.lsp')
end, { desc = 'Show LSP client and server status (alias for :checkhealth vim.lsp)' })

vim.api.nvim_create_user_command('LspLog', function()
  local log_path = vim.lsp.log.get_filename()
  if log_path then
    vim.cmd('edit ' .. vim.fn.shellescape(log_path))
  else
    vim.notify('No LSP log file found')
  end
end, { desc = 'Open the LSP log file' })

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
