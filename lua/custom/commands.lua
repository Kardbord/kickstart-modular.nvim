vim.api.nvim_create_user_command('Update', function()
  local function log(msg)
    vim.notify(msg)
    vim.cmd('redraw')
  end

  log('Updating Treesitter parsers...')
  require('nvim-treesitter.install').update { with_sync = true }

  log('Updating Mason packages...')
  require('mason-registry').update()

  log('Cleaning unused plugins...')
  require('lazy').clean { show = false }

  log('Updating Lazy plugins...')
  require('lazy').update { show = false }

  log('Update complete.')
end, { desc = 'Update all plugins and dependencies (Treesitter, Mason, Lazy)' })
