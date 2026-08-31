return {
  {
    'cavanaug/render-markdown-mermaid.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'MeanderingProgrammer/render-markdown.nvim',
    },
    ft = { 'markdown', 'mdx' },
    build = ':TSUpdate markdown markdown_inline',
    ---@module 'render-markdown-mermaid'
    ---@type render_markdown_mermaid.UserConfig
    opts = {
      cmd = { 'uvx', 'mermaid-ascii' },
      mode = 'unicode',
      placement = 'above',
      replace = false,
      debounce = 150,
      timeout = 10000,
      cache = true,
    },
  },
}
