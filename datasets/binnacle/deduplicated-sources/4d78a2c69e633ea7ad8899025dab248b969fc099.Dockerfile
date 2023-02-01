FROM ubuntu:18.04

USER root
ENV PATH="${PATH}:/root/.asdf/shims:/root/.asdf/bin"
RUN mkdir -p /root/app
WORKDIR /root/app

# prerequisite packages
RUN apt-get update -qq && \
    apt-get upgrade -qq -y && \
    apt-get install -qq -y \
            automake \
            autoconf \
            pkg-config \
            gcc-6 \
            build-essential \
            bison \
            libedit-dev \
            libreadline-dev \
            zlib1g-dev \
            libgdbm-dev \
            libcurl4-openssl-dev \
            libpng-dev \
            libssl-dev \
            libyaml-dev \
            libxslt-dev \
            libffi-dev \
            libgmp3-dev \
            libtool \
            libncurses-dev \
            libssh-dev \
            unixodbc-dev \
            libzip-dev \
            libbz2-dev \
            libevent-dev \
            libicu-dev \
            liblzma-dev \
            apt-transport-https \
            ca-certificates \
            gnupg2 \
            software-properties-common \
            bubblewrap \
            xorg-dev \
            vim \
            git \
            curl \
            wget \
            time \
            unzip && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y && \
    rm -rf /var/cache/debconf/*-old && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

# D
RUN curl -fsS https://dlang.org/install.sh | bash -s ldc

# Mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update
RUN apt-get install -qq -y mono-devel

# Pony
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E04F0923 B3B48BDA
RUN add-apt-repository "deb https://dl.bintray.com/pony-language/ponylang-debian  $(lsb_release -cs) main"
RUN apt-get install -qq -y ponyc

#Swift
RUN wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
RUN wget https://swift.org/builds/swift-5.0.1-release/ubuntu1804/swift-5.0.1-RELEASE/swift-5.0.1-RELEASE-ubuntu18.04.tar.gz
RUN tar xzf swift-5.0.1-RELEASE-ubuntu18.04.tar.gz
RUN mv swift-5.0.1-RELEASE-ubuntu18.04 /usr/share/swift
RUN rm swift-5.0.1-RELEASE-ubuntu18.04.tar.gz
RUN echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> ~/.bashrc

#Powershell
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN add-apt-repository universe
RUN apt-get install -y powershell

# apt languages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
            cython \
            fp-compiler \
            gfortran \
            ocaml \
            perl6 \
            sbcl \
            tcl \
            guile-2.2 \
            luajit

# asdf languages
RUN git clone https://github.com/asdf-vm/asdf.git /root/.asdf --branch v0.7.2
RUN chmod 755 $HOME/.asdf/asdf.sh
RUN echo "$HOME/.asdf/asdf.sh" >> ~/.bashrc
RUN asdf update

RUN asdf plugin-add java
RUN asdf plugin-add ruby
RUN asdf plugin-add clojure
RUN asdf plugin-add crystal
RUN asdf plugin-add dart https://github.com/baysao/asdf-dart.git
RUN asdf plugin-add dotnet-core
RUN asdf plugin-add erlang
RUN asdf plugin-add elixir
RUN asdf plugin-add elm
RUN asdf plugin-add golang
RUN asdf plugin-add haskell
RUN asdf plugin-add julia
RUN asdf plugin-add lua
RUN asdf plugin-add nim
RUN asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git \
&& bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
RUN asdf plugin-add perl https://github.com/BeijingPM/asdf-perl.git
RUN asdf plugin-add php
RUN asdf plugin-add python
RUN asdf plugin-add rust
RUN asdf plugin-add R

COPY .tool-versions /root/.
RUN asdf install
RUN asdf install
RUN asdf install

COPY . /root/app
CMD ./run.sh
