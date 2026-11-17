# dotfiles

### installation:
this repository uses stow to manage dotfiles
`sudo apt install stow`

```
cd dotfiles
./install.sh
```

### requirements
- `stow`: links each folder into `$HOME` (`install.sh`)
- Neovim 0.12+, tmux 3.4+, Ghostty, git
- `make` and a C compiler: build telescope-fzf-native and the tree-sitter parsers
- `ripgrep` (`rg`): telescope live grep
- `node`/`npm`, `curl`, `tar`, `unzip`: Mason installs LSP servers and the tree-sitter CLI with these
- LaTeX (optional): `latexmk`, `texlive-*`, `zathura` + `zathura-pdf-poppler`
- images in nvim (optional): ImageMagick for non-PNG formats, `mmdc` for Mermaid; `:checkhealth snacks` shows what is missing
