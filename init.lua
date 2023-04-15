-- Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.shell = "cmd.exe"

require("lazy").setup({
        --Splits animation size
        'beauwilliams/focus.nvim',
        -- Theme
        "morhetz/gruvbox",
        -- Colorizer
        "NvChad/nvim-colorizer.lua",
        -- Files tree
        "nvim-tree/nvim-tree.lua",
        "nvim-tree/nvim-web-devicons",
        -- Status Line
        'nvim-lualine/lualine.nvim',
        --Syntax
         'sheerun/vim-polyglot',
        -- Top Line bar
        {
            "utilyre/barbecue.nvim",
            name = "barbecue",
            version = "*",
            dependencies = {
                "SmiteshP/nvim-navic",
                "nvim-tree/nvim-web-devicons", -- optional dependency
            },
            opts = {
                -- configurations go here
            },
        },
        -- Find files, grep etc..
        {
            'nvim-telescope/telescope.nvim', tag = '0.1.1',
            -- or                              , branch = '0.1.1',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        -- auto complete
        {'neoclide/coc.nvim', branch = 'release'},
        -- Auto pairs () {} []
        'windwp/nvim-autopairs',
        -- move between splits
        'christoomey/vim-tmux-navigator',
        -- Close tags
        {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
        'windwp/nvim-ts-autotag',
        -- Comment
        "terrortylor/nvim-comment",
        -- Git diff show
        'mhinz/vim-signify',
        -- indent line
        'yggdroot/indentline',
        -- emmet
        'mattn/emmet-vim'
    })
-- Configs --

require('telescope').setup({
        pickers = {

            find_files = {
                hidden = true,
                theme = 'dropdown'
            },
            live_grep = {
                additional_args = function(opts)
                    return {"--hidden"}
                end
            },
        }
    })

-- Inits --

vim.g.gruvbox_contrast_dark = "hard"
vim.cmd('colorscheme gruvbox')

-- Splits resizer
require("focus").setup()
-- Commenter 
require('nvim_comment').setup()

--Colorizer
require 'colorizer'.setup()

-- File Tree
require('config.nvimtree')

-- Maps
require('config.maps')

-- Status Line
require('lualine').setup({
        options = { theme = 'gruvbox-material' }
    })

-- AutoTag and rename tags
require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt" , "vim" },
    })

require('nvim-treesitter.configs').setup({
        ensure_installed = { "c", "cpp", "typescript", "javascript", "tsx" },
        autotag = {
            enable = true,
        }
    })

--Vim config
vim.cmd('source ~/AppData/Local/nvim/config.vim')
