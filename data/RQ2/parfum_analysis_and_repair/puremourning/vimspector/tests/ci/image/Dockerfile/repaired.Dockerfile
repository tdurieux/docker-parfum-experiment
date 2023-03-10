FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL C.UTF-8
ARG GOARCH=amd64

RUN apt-get update && \
  apt-get install --no-install-recommends -y curl \
                     dirmngr \
                     apt-transport-https \
                     lsb-release \
                     ca-certificates \
                     software-properties-common && \
  curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get -y --no-install-recommends install gcc-8 \
                     g++-8 \
                     python3-dev \
                     python3-pip \
                     python3-venv \
                     ca-cacert \
                     locales \
                     language-pack-en \
                     libncurses5-dev libncursesw5-dev \
                     git \
                     tcl-dev \
                     tcllib \
                     gdb \
                     lldb \
                     nodejs \
                     pkg-config \
                     lua5.1 \
                     luajit && rm -rf /var/lib/apt/lists/*;

RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
  dpkg-reconfigure --frontend noninteractive tzdata

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 1 \
                        --slave   /usr/bin/g++ g++ /usr/bin/g++-8

RUN curl -f -LO https://golang.org/dl/go1.17.3.linux-${GOARCH}.tar.gz && \
    tar -C /usr/local -xzvf go1.17.3.linux-${GOARCH}.tar.gz && rm go1.17.3.linux-${GOARCH}.tar.gz

RUN update-alternatives --install /usr/local/bin/go go /usr/local/go/bin/go 1

# In order for love to work on arm64, we have to build it ourselves
RUN apt-get -y --no-install-recommends install lua5.1-dev \
                       luajit-5.1-dev \
                       libsdl2-dev \
                       libopenal-dev \
                       libfreetype6-dev \
                       libmodplug-dev \
                       libvorbis-dev \
                       libtheora-dev \
                       libmpg123-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -LO https://github.com/love2d/love/releases/download/11.3/love-11.3-linux-src.tar.gz && \
    tar zxvf love-11.3-linux-src.tar.gz && \
    cd love-11.3 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j $(nproc) && \
    make install && \
    cd .. && \
    rm -rf love-11.3 && \
    rm -f love-11.3-linux-src.tar.gz

RUN apt-get -y autoremove

## cleanup of files from setup
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG VIM_VERSION=v8.2.0716

ENV CONF_ARGS "--with-features=huge \
               --enable-python3interp \
               --enable-terminal \
               --enable-multibyte \
               --enable-fail-if-missing"

RUN mkdir -p $HOME/vim && \
    cd $HOME/vim && \
    git clone https://github.com/vim/vim && \
    cd vim && \
    git checkout ${VIM_VERSION} && \
    make -j 4 && \
    make install

# dotnet
RUN curl -f -sSL https://dot.net/v1/dotnet-install.sh \
        | bash /dev/stdin --channel 5.0 --install-dir /usr/share/dotnet && \
        update-alternatives --install /usr/bin/dotnet dotnet \
                                                      /usr/share/dotnet/dotnet 1

# clean up
RUN rm -rf ~/.cache && \
    rm -rf $HOME/vim
