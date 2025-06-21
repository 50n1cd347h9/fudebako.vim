# fudebako.vim
pluginmanager for vim/neovim

# Installation
## Vim
### 1.
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
### 2.
 Paste the url of any vim plugin on github into `repos.vim`.
```
https://github.com/lambdalisue/fern.vim.git
```


## Neovim
### 1.
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
```
### 2.
 Paste the url of any vim plugin on github into `repos.vim`.
```
https://github.com/lambdalisue/fern.vim.git
```
