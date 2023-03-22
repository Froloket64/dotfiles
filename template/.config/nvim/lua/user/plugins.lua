local function ensure_packer()
    local fn = vim.fn
    local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        vim.cmd("packadd packer.nvim")
        return true
    end

    return false
end

return require("packer").startup(function(use)
    -- Plugins
    -- Packer itself
    use "wbthomason/packer.nvim"

    -- LSP
    use {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},
            {"williamboman/mason.nvim"},
            {"williamboman/mason-lspconfig.nvim"},

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"},
            {"hrsh7th/cmp-nvim-lua"},

            -- Snippets
            {"L3MON4D3/LuaSnip"},
            {"rafamadriz/friendly-snippets"},
        }
    }

    -- Colorscheme
    use "ellisonleao/gruvbox.nvim"

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.1",
        requires = { "nvim-lua/plenary.nvim" }
    }

    -- Nvim Tree
    use {
        "nvim-tree/nvim-tree.lua",
        config = function() require("nvim-tree").setup() end,
        requires = { "nvim-tree/nvim-web-devicons" }
    }

    -- Autopairs
    use { 
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end
    }

    -- Comment.nvim
    use {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    }

    -- Which-key
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
        end
    }

    -- Better escape
    use {
        "max397574/better-escape.nvim",
        -- Config in after/
    }

    -- Colortils
    use {
        "max397574/colortils.nvim",
        cmd = "Colortils",
        config = function() require("colortils").setup() end,
    }

    -- Lualine
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        -- Config in after/
    }

    -- Barbar
    use {
        "romgrk/barbar.nvim",
        requires = "nvim-web-devicons"
    }

    -- Split term
    use "vimlab/split-term.vim"

    -- Automatically set up your configuration after cloning packer.nvim
    if ensure_packer() then
        require("packer").sync()
    end
end)
