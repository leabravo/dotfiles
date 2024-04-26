# My Humble NeoVim Configuration

## Resources

- [https://neovim.io/doc/user/lua-guide.html#lua-guide-modules](Official Nvim Lua Guide)
- Run the nvim command `:h rtp` to check the runtime path and where nvim fetches the configurations

## Packages

### Packer for package management

[https://github.com/wbthomason/packer.nvim](Packer repo)

- Install ripgrep, it's a dep for greping.

### Catppuccin for coloring

### Treesitter for more coloring

[https://github.com/nvim-treesitter/nvim-treesitter](Nvim-Treesitter repo)

- Do :InspectTree to get your mind blown.

### Undotree for undoing

[https://github.com/mbbill/undotree](Undotree repo)

## Programming

### Python

- Install pyenv
- Pyenv set python version
- python -m pip install pipx --force
- python -m pipx install poetry
- initialize project with poetry
- configura pyproject.toml to create .venv within project
