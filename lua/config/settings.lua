-- Leader key principal : <space>
-- Permet les raccourcis du style <leader>e ou <leader>ff
vim.g.mapleader = ' '

-- Leader secondaire (rarement utilise)
vim.g.maplocalleader = ' '

-- Active les icones Nerd Font dans les plugins
-- necessite une police Nerd Font dans le terminal
vim.g.have_nerd_font = true

-- Affiche les numeros de ligne
vim.o.number = true

-- La statusline affiche deja le mode courant
vim.o.showmode = false

-- Active la souris dans Neovim
-- pratique pour resize les splits ou scroll
vim.o.mouse = 'a'

-- Partage le clipboard avec le systeme
-- copy/paste entre nvim et OS
vim.o.clipboard = 'unnamedplus'

-- Garde l'indentation visuelle sur les retours a la ligne
vim.o.breakindent = true

-- Sauvegarde l'historique undo sur disque
-- permet undo meme apres fermeture
vim.o.undofile = true

-- Recherche insensible a la casse
vim.o.ignorecase = true

-- Reactive la casse si majuscule utilisee
-- ex: "test" != "Test"
vim.o.smartcase = true

-- Garde toujours la colonne des diagnostics/gitsigns
-- evite les decalages visuels
vim.o.signcolumn = 'yes'

-- Temps avant certains evenements internes
-- impacte diagnostics/autocomplete/etc
vim.o.updatetime = 250

-- Temps max d'attente pour les keymaps
vim.o.timeoutlen = 300

-- Les splits verticaux s'ouvrent a droite
vim.o.splitright = true

-- Les splits horizontaux s'ouvrent en bas
vim.o.splitbelow = true

-- Surligne la ligne courante
vim.o.cursorline = true

-- Garde toujours quelques lignes visibles autour du curseur
vim.o.scrolloff = 10

-- Preview des substitutions pendant la saisie
vim.o.inccommand = 'split'

-- Demande confirmation avant fermeture buffer non sauvegarde
vim.o.confirm = true

-- Recharge automatiquement les fichiers modifies hors Neovim
-- utile avec Claude/OpenCode
vim.o.autoread = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
