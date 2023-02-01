FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

# Neovim
RUN apt update && apt install --no-install-recommends -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src
RUN git clone https://github.com/neovim/neovim.git

WORKDIR /usr/local/src/neovim
RUN make && make install

# zsh
RUN apt install --no-install-recommends -y zsh && rm -rf /var/lib/apt/lists/*;

# Node
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Python
RUN apt install --no-install-recommends -y python python3 python3-pip && rm -rf /var/lib/apt/lists/*;
# RUN pip3 install neovim

# bat & ripgrep
# RUN apt install -y bat
# RUN apt install -y ripgrep

# Workaround for https://github.com/sharkdp/bat/issues/938
RUN apt install --no-install-recommends -y -o Dpkg::Options::="--force-overwrite" bat ripgrep && rm -rf /var/lib/apt/lists/*;

# fd
RUN apt install --no-install-recommends -y fd-find && rm -rf /var/lib/apt/lists/*;

# vim plugin
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN mkdir -p /root/.config/nvim
RUN echo "call plug#begin('~/.vim/plugged') \n\
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'} \n\
Plug 'neoclide/coc.nvim', {'branch': 'release'} \n\
call plug#end() \n\
\n\
let g:coc_global_extensions = ['coc-fzf-preview'] \n" >> /root/.config/nvim/init.vim

RUN nvim -c "PlugInstall" -c "qa!"
RUN nvim -c "CocInstall -sync coc-fzf-preview" -c "qa!"

ENTRYPOINT ["nvim"]
