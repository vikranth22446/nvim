return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>fp', function()
          builtin.find_files({
            find_command = { "fd", "--type", "f", "--type", "d", "--hidden", "--exclude", ".git" }
          })
        end, { desc = "Find files and directories" })

        vim.keymap.set('n', '<C-p>', builtin.git_files, {desc="Git search"})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, {desc="Find Word"})
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>fg', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, {desc="Grep word"})
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {desc="help"})
    end
}
