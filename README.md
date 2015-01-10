# vim-go-ide
Set of scripts to turn your Vim into light-weight Go editor.

### 1. Install runtime:

    git clone git@github.com:farazdagi/vim-go-ide.git ~/.vim_go_runtime
    sh ~/.vim_go_runtime/install

**NOTE:** You default Vim configuration will NOT be changed, everything is installed into `~/.vim_go_runtime` and `~/.vimrc.go`.

### 2. Run your newly installed Vim configuration:

Remember that your system Vim's config files remain untouched? That's why you have to specify with `vimrc` file to use:

    vim -u ~/.vimrc.go

Nothing prevents you to create alias in your `.zshrc`:

   alias vimgo='vim -u ~/.vimrc.go'

### 3. Finish installation:

In order for the [amazing vim-go](https://github.com/fatih/vim-go) to be most useful, run `:GoInstallBinaries` from w/i the Vim.

### 4. End-result:



Yep, that's it!
