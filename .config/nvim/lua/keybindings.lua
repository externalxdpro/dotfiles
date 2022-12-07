local opts = { noremap = true, silent = true }
local function map(mode, key, value)
	vim.keymap.set(mode, key, value, opts)
end

-- Base
-- Buffers
map('n', '<leader>bn', '<CMD>bnext<CR>')
map('n', '<leader>bp', '<CMD>bprevious<CR>')
map('n', '<leader>bk', '<CMD>bdelete<CR>')

-- Windows
map('n', '<leader>wh', '<C-w>h')
map('n', '<leader>wj', '<C-w>j')
map('n', '<leader>wk', '<C-w>k')
map('n', '<leader>wl', '<C-w>l')
map('n', '<leader>ws', '<CMD>split<CR>')
map('n', '<leader>wv', '<CMD>vsplit<CR>')
map('n', '<leader>w=', '<C-w>=')
map('n', '<leader>w+', '<CMD>resize -2<CR>')
map('n', '<leader>w-', '<CMD>resize +2<CR>')
map('n', '<leader>w<', '<CMD>vertical resize -2<CR>')
map('n', '<leader>w>', '<CMD>vertical resize +2<CR>')
map('n', '<leader>wc', '<CMD>q<CR>')

-- Indent
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Other
map('v', 'p', '"_dP')

-- Plugins
-- LazyGit
map('n', '<leader>gg', '<CMD>LazyGit<CR>')

-- Ranger
map('n', '<leader>od', '<CMD>Ranger<CR>')

-- Nerd Tree
map('n', '<leader>op', '<CMD>NERDTreeToggle<CR>')
