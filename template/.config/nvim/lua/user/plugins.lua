local function ensure_packer()
    local fn = vim.fn
    local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
    local is_installed = fn.empty(fn.glob(install_path)) == 0

    if is_installed then
        return
    end

    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd("packadd packer.nvim")

    -- Automatically set up your configuration after cloning packer.nvim
    require("packer").sync()
end

ensure_packer()

return require("packer").startup(function(use)
    -- Packer itself
    use "wbthomason/packer.nvim"

    -- LSP
    use {
        "VonHeikemen/lsp-zero.nvim",
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
            {"SirVer/ultisnips"},
        }
        -- Config in after/
    }

    -- Colorscheme
    use "ellisonleao/gruvbox.nvim"

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate", -- FIXME: Displays an error on first install
        -- Config in after/
    }

    -- Treesitter Playground
    use {
        "nvim-treesitter/playground",
        run = ":TSInstall query"
    }

    -- Treesitter textobjects
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        -- Confif in after/
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        -- Config in after/
    }

    -- Telescope file browser
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim"
        }
        -- Config in after/
    }

    -- fzf-native
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make"
    }

    -- Nvim Tree
    use {
        "nvim-tree/nvim-tree.lua",
        config = function() require("nvim-tree").setup() end,
        requires = { "nvim-tree/nvim-web-devicons" }
    }

    -- Automatically complete delimiter pairs
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end
    }

    -- Comment based on TS
    use {
        "numToStr/Comment.nvim",
        -- Config in after/
    }

    -- Keymaps help
    use {
        "folke/which-key.nvim",
        -- Config in after/
    }

    -- Use `jk` to exit to Normal mode
    use {
        "max397574/better-escape.nvim",
        -- Config in after/
    }

    -- Coloring utilities
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

    -- Org mode
    use {
        "nvim-orgmode/orgmode",
        requires = "nvim-treesitter/nvim-treesitter",
        -- Config in after/
    }

    -- NeoColumn
    use {
        "ecthelionvi/NeoColumn.nvim",
        -- Config in after/
    }

    -- Trouble
    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function() require("trouble").setup() end
    }

    -- Better `f` and `t`
    use {
        "phaazon/hop.nvim",
        branch = "v2",
        -- Config in after/
    }

    -- ts-rainbow2
    use "HiPhish/nvim-ts-rainbow2"

    -- Jump between classes, functions, etc. (requires LSP)
    use {
        "SmiteshP/nvim-navbuddy",
        requires = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim"
        }
    }

    -- Show indentation guides
    use "lukas-reineke/indent-blankline.nvim";

    -- Terminals
    use {
        "akinsho/toggleterm.nvim",
        config = function() require("toggleterm").setup() end
    }

    -- Surround text with delimiters
    use({
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup() end
    })

    -- Practising Vim motions
    use "ThePrimeagen/vim-be-good"

    -- Code assistant (Codeium)
    use "Exafunction/codeium.vim"

    -- Buffer deletion
    use "ojroques/nvim-bufdel"

    -- Rust Tools
    use "simrat39/rust-tools.nvim"

    -- Git signs
    use {
        "lewis6991/gitsigns.nvim",
        -- Config in after/
    }
end)
