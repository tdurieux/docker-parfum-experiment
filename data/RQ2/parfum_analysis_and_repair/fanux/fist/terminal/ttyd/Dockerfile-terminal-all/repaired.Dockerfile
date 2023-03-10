FROM centos:7.6.1810
# install tty
RUN yum install -y wget &&  yum install -y bind-utils && \
    wget https://github.com/tsl0922/ttyd/releases/download/1.4.2/ttyd_linux.x86_64 && \
    chmod +x ttyd_linux.x86_64 && \
    mv ttyd_linux.x86_64 /usr/bin/ttyd && rm -rf /var/cache/yum

# install golang
RUN cd /root && wget https://dl.google.com/go/go1.12.linux-amd64.tar.gz && \
	tar zxvf go1.12.linux-amd64.tar.gz && \
	rm -rf go1.12.linux-amd64.tar.gz && mkdir /root/work
ENV GOROOT=/root/go GOPATH=/root/work PATH=$PATH:/root/go/bin:/root/work/bin

# ENV APISERVER="https://127.0.0.1:6443"
# ENV USER_TOKEN="xxx"
# ENV NAMESPACE="default"
# ENV USER_NAME="fanux"
# ENV TERMINAL_ID="UUID"

# install kubectl
RUN wget https://dl.k8s.io/v1.13.3/kubernetes-client-linux-amd64.tar.gz && \
    tar zxvf kubernetes-client-linux-amd64.tar.gz && \
    cp kubernetes/client/bin/kubectl /usr/bin && \
    rm -rf kubernetes-client-linux-amd64.tar.gz kubernetes

# install zsh
RUN yum install -y git && \
	yum -y install zsh && sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" && rm -rf /var/cache/yum

# RUN cd /bin && wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz && \
#	tar zxvf nvim-linux64.tar.gz && cp /bin/nvim-linux64/bin/nvim /bin/nvim-linux64/bin/vim && ls /bin/nvim-linux64/bin/vim
# ENV PATH=$PATH:/bin/nvim-linux64/bin

RUN yum install -y  ncurses-devel ruby ruby-devel lua lua-devel luajit \
	luajit-devel ctags git python python-devel \
	python3 python3-devel tcl-devel \
	perl perl-devel perl-ExtUtils-ParseXS \
	perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
	perl-ExtUtils-Embed  \
        gcc-c++ cmake make  && \
	wget https://github.com/vim/vim/archive/v8.1.0994.tar.gz && \
	tar zxvf v8.1.0994.tar.gz  && cd vim-8.1.0994/src && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-features=huge \
            --enable-multibyte \
					--enable-pythoninterp=yes \
					--with-python-config-dir=/lib64/python2.7/config \
					--enable-python3interp=yes \
					--with-python3-config-dir=/lib64/python3.5/config \
            --enable-gui=gtk2 \
            --enable-cscope \
				--prefix=/usr/local \
   && make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 && make install && rm -rf /var/cache/yum
RUN update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1 && \
     update-alternatives --set editor /usr/local/bin/vim 
ENV PATH=$PATH:/usr/local/bin

# install vim and vim plugins
COPY .vimrc /root/.vimrc
RUN  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim  && go get github.com/golang/lint || true

# RUN vim +PluginInstall +qall -e || true && \
#	&& git clone https://github.com/Valloric/YouCompleteMe ~/.vim/bundle/YouCompleteMe \
#	&& cd ~/.vim/bundle/YouCompleteMe && \
#        ./install.py --clangd-completer --go-completer --ts-completer

# vim +PluginInstall +qall && vim +GoInstallBinaries &&
# or using ttyd -p 8080 bash
# or using ttyd -p 8080 zsh
COPY start-terminal.sh .
CMD ["sh","./start-terminal.sh"]

