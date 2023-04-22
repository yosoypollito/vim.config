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
        -- Codeium
        { 'Exafunction/codeium.vim',
            config = function ()
                -- Change '<C-g>' here to any keycode you like.
                vim.keymap.set('i', '<S-Tab>', function () return vim.fn['codeium#Accept']() end, { expr = true })
                vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
                vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
                vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
            end
        },
        --Markdown previewer
        'iamcco/markdown-preview.nvim',
        --Splits animation size
        'beauwilliams/focus.nvim',
        -- Theme
        { "ellisonleao/gruvbox.nvim", priority = 1000 },
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
        -- {'neoclide/coc.nvim', branch = 'release'},
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
        'mattn/emmet-vim',
        -- lsp
        'neovim/nvim-lspconfig',
        -- Auto complete
        'hrsh7th/nvim-cmp', -- Autocompletion plugin
        'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
        'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
        'L3MON4D3/LuaSnip', -- Snippets plugin
        -- Prettier
        'sbdchd/neoformat',
        -- React refactor
        "napmn/react-extract.nvim",
    })
-- Configs --
-- disable codeium default binding
vim.g.codeium_disable_bindings = 1

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

require("react-extract").setup()

--Vim config
vim.cmd('source ~/AppData/Local/nvim/config.vim')

--THEME
vim.o.background = "dark" -- or "light" for light mode
require("gruvbox").setup({
        italic = {
            strings = false,
            comments = false,
            operators = false,
            folds = false,
        },
    })
vim.cmd([[colorscheme gruvbox]])

-- LSP CONFIGURATION
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
-- If you want to add a lsp server just search https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md what you need and put the string name of lsp server
local servers = { 'tsserver', 'tailwindcss', 'jsonls'}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        -- on_attach = my_custom_on_attach,
        capabilities = capabilities,
    }
end

-- Especific eslint configuration needed for https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
lspconfig.eslint.setup({
        --- ...
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    command = "EslintFixAll",
                })
        end,
    })

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
            ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
            ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
            -- C-b (back) C-f (forward) for snippet placeholder navigation.
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
}),
  sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
  },
}
