local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"},
                           {"\nPress any key to exit..."}}, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.keymap.set("", "<Space>", "<Nop>")
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    
    spec = {{
        import = "plugins"
    }, 
    {
        "lewis6991/gitsigns.nvim",
        event = "User FilePost"
    },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
    },
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    {
      'terrortylor/nvim-comment',
      config = function()
        require("nvim_comment").setup({ create_mappings = false })
      end
    },
    {
      "ray-x/lsp_signature.nvim",
      event = "InsertEnter",
      opts = {
        -- cfg options
      },
    },
{
  "folke/zen-mode.nvim",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
},    


    {
        "karb94/neoscroll.nvim",
        opts = {},
    },
    { "sitiom/nvim-numbertoggle" },
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = {
            style = "moon"
        }
    }},
    install = {
        colorscheme = {"habamax"}
    },
    -- automatically check for plugin updates
    checker = {
        enabled = true,
        notify = false
    }
})

vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>", {desc="File Tree"})
vim.keymap.set("n", "<leader>fmp", ":silent !black %<cr>")
vim.keymap.set("n", "<leader>fmd", vim.lsp.buf.format)

vim.cmd [[colorscheme tokyonight-moon]]
require('bufferline').setup{}
vim.keymap.set("n", "<leader>n", ":bn<cr>", { desc = "Next Buffer", nowait = true })
vim.keymap.set("n", "<leader>p", ":bp<cr>", { desc = "Previous Buffer", nowait = true })

-- vim.keymap.set("n", "<leader>n", ":bn<cr>", {desc ="Next Pane"})
-- vim.keymap.set("n", "<leader>p", ":bp<cr>", {desc="Previous Pane"})
-- vim.keymap.set("n", "<leader>x", ":bd<cr>", {desc="Close Window"})
vim.keymap.set({"n", "v"}, "<leader>/", ":CommentToggle<cr>", {desc="Comment"})
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])

vim.lsp.config['ruff'] = {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', '.git' },
}
vim.lsp.enable('ruff')
vim.lsp.enable('pyright')
vim.lsp.config["*"] = {
  on_attach = function(_, bufnr)
    local map = function(keys, func)
      vim.keymap.set("n", keys, func, { buffer = bufnr })
    end

    -- Hover docs
    map("K", vim.lsp.buf.hover)

    -- Function signature help
    map("<C-k>", vim.lsp.buf.signature_help)

    -- Rename, go to definition, etc. (optional)
    map("gd", vim.lsp.buf.definition)
    map("gr", vim.lsp.buf.references)

    -- Optional: diagnostics in virtual text
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      severity_sort = true,
      update_in_insert = true,  
    })
  end,
}
vim.keymap.set({ "n", "i", "v" }, "<D-s>", "<Cmd>w<CR>", { desc = "Save" })
vim.keymap.set({ "n", "i", "v" }, "<D-z>", "<Cmd>undo<CR>", { desc = "Undo" })
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save file" })

vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<D-a>", "ggVG", { desc = "Select All" })
vim.keymap.set("n", "<D-h>", ":%s//g<Left><Left>", { desc = "Replace" })
vim.keymap.set("n", "<D-q>", "<Cmd>qa<CR>", { desc = "Quit Neovim" })
vim.keymap.set("n", "<D-x>", "dd", { desc = "Cut line" })
vim.keymap.set("n", "<D-c>", "yy", { desc = "Copy line" })
vim.keymap.set("n", "<D-v>", "p", { desc = "Paste" })

vim.opt.nu = true
vim.opt.relativenumber = false
local augroup = vim.api.nvim_create_augroup("numbertoggle", {})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
   pattern = "*",
   group = augroup,
   callback = function()
      if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
         vim.opt.relativenumber = true
      end
   end,
})

-- vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
--    pattern = "*",
--    group = augroup,
--    callback = function()
--       if vim.o.nu then
--          vim.opt.relativenumber = false
--          -- Conditional taken from https://github.com/rockyzhang24/dotfiles/commit/03dd14b5d43f812661b88c4660c03d714132abcf
--          -- Workaround for https://github.com/neovim/neovim/issues/32068
--          if not vim.tbl_contains({"@", "-"}, vim.v.event.cmdtype) then
--             vim.cmd "redraw"
--          end
--       end
--    end,
-- })

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- Add current file to Harpoon marks
vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon add file" })

-- Toggle the Harpoon quick menu popup
vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon menu" })

-- Jump to Harpoon files (1-4 example)
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "Harpoon file 4" })


vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.mouse = 'a'

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.opt.winborder = 'rounded'
vim.keymap.set('n', '<S-Up>', 'Vk', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Down>', 'Vj', { noremap = true, silent = true })

vim.keymap.set('v', '<S-Up>', 'k', { noremap = true, silent = true })
vim.keymap.set('v', '<S-Down>', 'j', { noremap = true, silent = true })-- In visual mode, extend selection up/down with Shift+Up/Down

vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, silent = true })

-- Indent left with Shift+Tab in visual mode, stay in visual mode
vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

require('claude')
