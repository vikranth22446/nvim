return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    -- Optional: custom configuration
    vim.g.Illuminate_delay = 200
    vim.cmd [[hi def link IlluminatedWordText Visual]]
  vim.cmd [[hi def link IlluminatedWordRead Visual]]
  vim.cmd [[hi def link IlluminatedWordWrite Visual]]

  -- Custom keymaps for navigation
  vim.keymap.set("n", "<leader>m", require("illuminate").goto_next_reference, { desc = "Next Reference" })
  vim.keymap.set("n", "<leader>M", require("illuminate").goto_prev_reference, { desc = "Previous Reference" })

  end,
}


