
DIRNAME?=${HOME}/.vim.go

all: move_to_home install_plugins

install_plugins:
	@(cd ${DIRNAME} && ./bin/install && mv vimrc.go ${HOME}/.vimrc.go)

move_to_home:
	mkdir ${DIRNAME}
	cp -r * ${DIRNAME}

