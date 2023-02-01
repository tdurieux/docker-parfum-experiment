FROM debian:stretch

WORKDIR /home/homo

COPY . /home/homo/homo/

COPY docker/entrypoint /usr/bin/entrypoint

# Use bash as the default shell
SHELL ["/bin/bash", "-c"]

# Golang env
ENV GOLANG_VERSION 1.12.6
ENV GOLANG_TAR_BALL go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/$GOLANG_TAR_BALL
ENV GOLANG_DOWNLOAD_SHA256 dbcf71a3c1ea53b8d54ef1b48c85a39a6c9a935d01fc8291ff2b92028e59913c
ENV GOPATH /home/homo/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# supervisor config
RUN mkdir -p "/var/log/supervisor" && chmod -R 777 "/var/log/supervisor" && chmod 777 "/run"

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install system dependence
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl openssl libssl-dev git wget libbz2-dev sudo \
                 tar bzip2 gcc automake autoconf libtool build-essential \
                 bison swig python-dev libpulse-dev portaudio19-dev libwebkit2gtk-4.0-dev supervisor libgl1-mesa-dri locales ttf-wqy-microhei && \
    rm -rf /var/lib/apt/lists/*

# Add Chinese support
RUN sed -ie 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen
RUN locale-gen

ENV LANG zh_CN.UTF-8

# Add user homo to sudo
RUN useradd -m homo && echo "homo:homo" | chpasswd && adduser homo sudo

# Install PocketSphinx
RUN \
    cd homo && \
    make deps && \
    sudo ldconfig

# Install Golang
RUN wget $GOLANG_DOWNLOAD_URL && \
    echo "$GOLANG_DOWNLOAD_SHA256  $GOLANG_TAR_BALL" | sha256sum -c - && \
    sudo tar -C /usr/local -xzf $GOLANG_TAR_BALL && \
    rm $GOLANG_TAR_BALL

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN go env

# Build homo webview
RUN \
    cd homo && \
    make gen && \
    make webview

# Install python 3.6.8
RUN \
    wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz && \
    tar xvf Python-3.6.8.tgz && \
    cd Python-3.6.8 && \
    ./configure --enable-optimizations \
                --without-ensurepip \
                --with-ssl && \
    make -j 8 && \
    sudo make altinstall && \
    cd .. && \
    rm -rf Python-3.6.8 Python-3.6.8.tgz

RUN python3.6 -V

# Install pip for python 3.6
RUN curl https://bootstrap.pypa.io/get-pip.py | sudo -H python3.6

# Install python dependencies
RUN \
    pip install virtualenv && \
    cd homo/nlu && \
    virtualenv --python=python3.6 env3.6 && \
    source env3.6/bin/activate && \
    pip install -r requirements.txt

RUN chown homo:homo -R "/home/homo"

USER homo

ENV HOME /home/homo

VOLUME ["/home/homo/homo/conf", "/home/homo/homo/sphinx/en-us", "/home/homo/homo/sphinx/cmusphinx-zh-cn-5.2", "/home/homo/homo/nlu/data/rasa", "/home/homo/homo/nlu/models"]

ENTRYPOINT ["/usr/bin/entrypoint"]

CMD ["/usr/bin/supervisord"]
