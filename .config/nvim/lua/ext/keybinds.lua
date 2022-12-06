local function map(mode, key, value)
	vim.keymap.set(mode, key, value, { silent = true })
end

-- Nerd Tree
map('n', '<leader>op', '<CMD>NERDTreeToggle<CR>')
