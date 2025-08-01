return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },  -- optional for snippet support
  version = "1.*",  -- pin to latest stable release if you like
  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
  keymap = { preset = 'super-tab' },
  completion = { documentation = { auto_show = false } },
  opts_extend = { "sources.default" }
}