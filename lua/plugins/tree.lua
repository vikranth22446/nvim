return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        require("nvim-tree").setup {}
    end,
    requires = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy=false,
}