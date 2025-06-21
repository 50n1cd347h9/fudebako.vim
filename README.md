# fudebako.vim
pluginmanager for vim/neovim

# Installation
## Vim
```bash
mkdir ~/.vim
cd ~/.vim

# install pyyaml
python3 -m venv venv
source venv/bin/activate
pip install pyyaml

git clone https://github.com/shotaro-ada/fudebako.vim
mkdir -p pack
mkdir -p pack/delayed/opt

touch vimrc
echo 'source $HOME/.vim/fudebako.vim/manager.vim' >> ~/.vim/vimrc
touch plugins.yaml
```


## Neovim
```bash
mkdir -p ~/.config/nvim
cd ~/.config/nvim
touch init.lua

# install pyyaml
python3 -m venv venv
source venv/bin/activate
pip install pyyaml

git clone https://github.com/50n1cd347h9/fudebako.vim
mkdir pack
mkdir -p pack/delayed/opt

# insert following line to init.lua
# vim.cmd("source " .. vim.fn.stdpath("config") .. "/fudebako.vim/manager.vim")
sed -i \
 '1i vim.cmd("source " .. vim.fn.stdpath("config") .. "/fudebako.vim/manager.vim")' \
 init.lua

touch plugins.yaml

# plugins.yaml
plugins:
  - "https://github.com/rebelot/kanagawa.nvim.git"
  #- "https://github.com/folke/tokyonight.nvim.git"
  - "https://github.com/nvim-treesitter/nvim-treesitter.git"

delayed:
  - url: "https://github.com/tpope/vim-surround"
    filetype:
      - "python"
      - "ruby"

  - url: "https://github.com/lambdalisue/vim-fern"
    cmd:
      - "Fern"
