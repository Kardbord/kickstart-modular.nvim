return {
  -- See https://codecompanion.olimorris.dev/getting-started
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {

    -- Adapter config. Adapters are used for interactions.
    adapters = {

      http = {
        extend = {
          openrouter = {
            env = {
              api_key = function()
                return require("custom.secrets").from_pass_or_env('personal/openrouter/api-key', 'OPENROUTER_API_KEY')
              end
            }
          },
        },
      },

      acp = {
        extend = {
          opencode = {
            commands = {
              default = {
                "npx", "--yes", "opencode-ai", "acp"
              },
            },
            env = {
              OPENROUTER_API_KEY = require("custom.secrets").from_pass_or_env('personal/openrouter/api-key', 'OPENROUTER_API_KEY'),
            },
          },
        },
      }
    },

    -- Config for the various interaction types
    interactions = {

      -- Config for typical chat window interactions. HTTP or ACP adapters.
      -- :CodeCompanionChat
      chat = {
        adapter = "opencode",
      },

      -- Config for inline chat interactions. HTTP adapters only.
      -- :CodeCompanion
      inline = {
        adapter = {
          name = "openrouter",
          model = "deepseek/deepseek-v4-flash:floor"
        },
      },

      -- Config for CLI agent interactions.
      -- :CodeCompanionCLI
      cli = {
        agent = "opencode",
        agents = {
          opencode = {
            cmd = "npx",
            args = { "--yes", "opencode-ai" },
            description = "OpenCode CLI",
            provider = "terminal",
          },
        },
      },

      -- Config for Cmd interactions in the nvim command-line.
      -- :CodeCompanionCmd
      cmd = {
        adapter = {
          name = "openrouter",
          model = "deepseek/deepseek-v4-flash:floor"
        },
      },

      -- Non-interactive. Handles background tasks like compacting
      -- chat messages or generating titles for chats.
      background = {
        adapter = {
          name = "openrouter",
          model = "openrouter/free"
        },
      },
    },

    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = "DEBUG",
    },
  },
}
