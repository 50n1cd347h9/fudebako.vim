cd ..
sed -i \
 '1i vim.cmd("source " .. vim.fn.stdpath("config") .. "/fudebako.vim/manager.vim")' \
 init.lua
mkdir -p pack/delayed/opt
touch plugins.yaml
