local opts = { noremap = true, silent = true }
local function map(mode, key, value)
	vim.keymap.set(mode, key, value, opts)
end

-- Base
-- Buffers
map('n', '<leader>bn', '<CMD>bnext<CR>')
map('n', '<leader>bp', '<CMD>bprevious<CR>')
map('n', '<leader>bk', '<CMD>bdelete<CR>')

-- Indent
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Windows
map('n', '<leader>wh', '<C-w>h')
map('n', '<leader>wj', '<C-w>j')
map('n', '<leader>wk', '<C-w>k')
map('n', '<leader>wl', '<C-w>l')

-- Other
map('v', 'p', '"_dP')

-- Plugins
-- Vimagit
map('n', '<leader>gg', '<CMD>LazyGit<CR>')

-- Ranger
map('n', '<leader>od', '<CMD>Ranger<CR>')

-- Nerd Tree
map('n', '<leader>op', '<CMD>NERDTreeToggle<CR>')
