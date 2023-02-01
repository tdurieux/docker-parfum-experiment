FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential git cmake software-properties-common \
    openssl libssl-dev pkg-config clang && rm -rf /var/lib/apt/lists/*;

RUN mkdir /src
WORKDIR /src

RUN mkdir /src/picoquic
COPY ./ /src/picoquic/

# Perl stuff is for the picotls test code
RUN echo install Test::TCP | perl -MCPAN -
RUN echo install Scope::Guard | perl -MCPAN -

RUN git clone https://github.com/h2o/picotls.git && \
    cd picotls && \
    git submodule init && \
    git submodule update && \
    cmake . && \
    make && \
    make check

RUN cd /src/picoquic && \
    cmake . && \
    make
