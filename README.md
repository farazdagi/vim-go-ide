# vim-go-ide
Get started with Go development in minutes!

### 1. Install runtime:

    git clone git@github.com:farazdagi/vim-go-ide.git ~/.vim_go_runtime
    sh ~/.vim_go_runtime/bin/install

**NOTE:** You system's Vim configuration will NOT be changed i.e. it is safe to install.

### 2. Run your newly installed Vim configuration:

Remember that your system's Vim config files remain untouched? During installation `.vimrc.go` is created. Let's use it:

    vim -u ~/.vimrc.go

And btw, nothing prevents you from creation of a handy alias in your `.zshrc`:

    alias vimgo='vim -u ~/.vimrc.go'

### 3. Setup necessary go tools (godep, gocode, godoc etc):

In order for the [amazing vim-go](https://github.com/fatih/vim-go) to be most useful, run `:GoInstallBinaries` from w/i the Vim.

### 4. End-result:

![Screenshot](https://raw.githubusercontent.com/farazdagi/vim-go-ide/master/screenshot.png)

Yep, that's it!
