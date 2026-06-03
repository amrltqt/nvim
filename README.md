# Neovim config

Configuration Neovim personnelle, basee sur une structure simple avec
`lazy.nvim`.

## Prerequis

- Neovim 0.11 ou plus recent
- `git`
- `ripgrep` et `fd` pour Telescope
- Une Nerd Font si tu veux les icones
- Pour Python: `python3`, puis optionnellement `uv`, `poetry` ou `pipenv`

## Installation

```sh
git clone <ton-repo-github> ~/.config/nvim
nvim
```

Au premier demarrage, `lazy.nvim` s'installe automatiquement puis installe les
plugins declares dans `lua/plugins/`.

## Organisation

- `init.lua`: point d'entree minimal.
- `lua/config/settings.lua`: options globales, keymaps de base et autocmds.
- `lua/config/lazy.lua`: bootstrap de `lazy.nvim` et import des plugins.
- `lua/plugins/editor.lua`: theme, navigation fichiers, Telescope, Git signs.
- `lua/plugins/cmp.lua`: completion et snippets.
- `lua/plugins/lsp.lua`: Mason et configuration LSP.
- `lua/plugins/treesitter.lua`: parsing et coloration syntaxique avancee.
- `lua/utils/`: petits helpers partages.

## Maintenance

- Lancer `:Lazy sync` apres un changement de machine ou une mise a jour du
  depot.
- Garder `lazy-lock.json` versionne pour retrouver les memes revisions de
  plugins partout.
- Mettre a jour les plugins avec `:Lazy update`, puis committer le lockfile si
  tout fonctionne.
- Verifier l'etat LSP avec `:checkhealth vim.lsp` et `:LspInfo`.

## Raccourcis principaux

- `<leader>e`: ouvrir/fermer l'arborescence sur le fichier courant.
- `<leader>r`: rafraichir l'arborescence.
- `<leader>ff`: chercher un fichier.
- `<leader>fg`: rechercher dans le projet.
- `<leader>fb`: lister les buffers.
- `gd`: aller a la definition.
- `K`: afficher la documentation LSP.
- `<leader>rn`: renommer via LSP.
- `<leader>ca`: actions de code.
- `<leader>f`: formatter le buffer via LSP.
