# vim-go-ide
Get started with Go development in minutes!

### 0. What is this?

Quite simply this is a vim configuration which will setup all the necessary Go development environment (and plugins), without overwriting your current Vim settings. Basically, you will be able to use amazing [vim-go plugin](https://github.com/fatih/vim-go) (plus number of others), without affecting your system's Vim configuration.

### 1. Install runtime:

Fork the repo, and then clone it anywhere. Once done, just run installation script:

    git clone git@github.com:farazdagi/vim-go-ide.git 
    cd vim-go-ide
    make 

**NOTE:** You system's Vim configuration will NOT be changed i.e. it is safe to install.

**REQUIREMENT:** vim-go-ide uses [pathogen](https://github.com/tpope/vim-pathogen) to manage plugins. You need to have pathogen installed on your machine (see https://github.com/farazdagi/vim-go-ide/issues/12).

**REQUIREMENT:** vim-go-ide needs vim8 with python3 and lua support (`brew install vim --with-python3 --with-lua`)

### 2. Run your newly installed Vim configuration:

Remember that your system's Vim config files remain untouched? During installation `.vimrc.go` is created. Let's use it:

    vim -u ~/.vimrc.go

And btw, nothing prevents you from creation of a handy alias in your `.bashrc`:

    alias vimgo='vim -u ~/.vimrc.go'

### 3. Setup necessary go tools (godep, gocode, godoc etc):

In order for the [amazing vim-go](https://github.com/fatih/vim-go) to be most useful, run `:GoInstallBinaries` from w/i the Vim.

### 4. End-result:

![Screenshot](https://raw.githubusercontent.com/ngalayko/vim-go-ide/master/screenshot.png)

Yep, that's it! 

### 5. Where to go from here?

- You can also read a corresponding [blog post](http://farazdagi.com/blog/2015/vim-as-golang-ide/).
- You are highly advised to review [vim-go docs](https://github.com/fatih/vim-go) (just typing `:help vim-go` is also good enough).
- Review list of plugins installed (see [bin/install](https://github.com/ngalayko/vim-go-ide/blob/master/bin/install)), and default configuration that comes with this setup (see [vimrc folder](https://github.com/farazdagi/vim-go-ide/tree/master/vimrc)).
- You can also define your custom settings in `~/.vim_go_runtime/custom_config.vim` the runtime will try to load this file - so feel free to remap keys as you see necessary!

### 6. Update plugin list

Just alter plugin list in [install script](https://github.com/ngalayko/vim-go-ide/blob/master/bin/install)

