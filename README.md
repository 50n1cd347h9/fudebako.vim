# fudebako.vim
pluginmanager for vim/neovim

# Installation
## Vim
### 1.
```bash
$ mkdir ~/.vim
$ cd ~/.vim
$ git clone https://github.com/shotaro-ada/fudebako.vim
$ mkdir -p ~/.vim/plugins
$ touch ~/.vim/vimrc
$ echo 'source $HOME/.vim/fudebako.vim/manager.vim' >> ~/.vim/vimrc
$ touch ~/.vim/repos.vim
```
### 2.
 Paste the url of any vim plugin on github into `repos.vim`.
```
https://github.com/lambdalisue/fern.vim.git
```


## Neovim
### 1.
```bash
$ mkdir -p ~/.config/nvim
$ cd ~/.config/nvim
$ git clone https://github.com/shotaro-ada/fudebako.vim
$ mkdir ~/.config/nvim/plugins
$ touch ~/.config/nvim/init.vim
$ echo 'source $HOME/.vim/fudebako.vim/manager.vim' >> ~/.config/nvim/init.vim
$ touch ~/.config/nvim/repos.vim
```
### 2.
 Paste the url of any vim plugin on github into `repos.vim`.
```
https://github.com/lambdalisue/fern.vim.git
```
