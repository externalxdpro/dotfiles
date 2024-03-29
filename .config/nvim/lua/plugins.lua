-- Reloads Neovim whenever you save plugins.lua
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup END
]])

-- Auto install packer if not installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
      end
    return false
end

local packer_bootstrap = ensure_packer()

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

return packer.startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'nvim-lua/plenary.nvim'         -- Useful lua functions used by lots of plugins

    -- Productivity
    use 'kdheepak/lazygit.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-orgmode/orgmode'
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'windwp/nvim-autopairs'         -- Autopairs, integrates with both cmp and treesitter
    use 'numToStr/Comment.nvim'

    -- File Management
    use {
        'francoiscabrol/ranger.vim',    -- Have to install on system as well e.g. sudo pacman -S ranger
        requires = { 'rbgrouleff/bclose.vim', opt = true, cmd = { 'Bclose', 'Bclose!' } }
    }
    use 'preservim/nerdtree'

    -- Completion
    use 'hrsh7th/nvim-cmp'              -- The completion plugin
    use 'hrsh7th/cmp-buffer'            -- Buffer completions
    use 'hrsh7th/cmp-path'              -- Path completions
    use 'saadparwaiz1/cmp_luasnip'      -- Snippet completions

    -- Snippets
    use 'L3MON4D3/LuaSnip'              -- Snippet engine
    use 'rafamadriz/friendly-snippets'  -- A bunch of snippets to use

    -- Telescope
    use 'nvim-telescope/telescope.nvim' -- Fuzzy finder

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- Colour schemes
    use 'RRethy/nvim-base16'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
