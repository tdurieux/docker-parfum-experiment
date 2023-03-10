FROM alpine AS builder
WORKDIR /etc/app
RUN apk add --no-cache git build-base cmake pkgconfig openssl
RUN git clone --depth 1 https://github.com/neovim/neovim neovim
WORKDIR /etc/app/neovim
RUN make CMAKE_BUILD_TYPE=Release
RUN make install