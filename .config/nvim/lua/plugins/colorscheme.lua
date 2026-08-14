return {
    -- Tell LazyVim to load a different colorscheme on startup
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "habamax", -- or "default", or the name of another installed theme
        },
    },

    -- Disable tokyonight
    { "folke/tokyonight.nvim", enabled = false },
}
