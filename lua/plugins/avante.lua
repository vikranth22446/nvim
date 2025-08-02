return { 
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      debug = true,
      provider = "copilot",
      auto_suggestions_provider = nil,

      -- OpenAI Config 
    },
      keys = {
    {
      "<S-CR>",
      function()
        require("avante").chat.toggle()
      end,
      mode = { "n", "i" },
      desc = "Toggle Avante Chat",
    },
  },

    build = "make",
    dependencies = {
      "zbirenbaum/copilot.lua", -- Required for copilot provider
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-tree/nvim-web-devicons",
      -- Optional:
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
    },
  }
}
