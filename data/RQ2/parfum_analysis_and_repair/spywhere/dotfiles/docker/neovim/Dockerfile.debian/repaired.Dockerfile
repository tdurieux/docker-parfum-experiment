FROM debian:bullseye-slim AS builder

WORKDIR /etc/app
RUN apt update && apt install -y --no-install-recommends git ca-certificates libtool-bin cmake autotools-dev pkg-config debhelper unzip && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth 1 https://github.com/neovim/neovim neovim
WORKDIR /etc/app/neovim
RUN make CMAKE_BUILD_TYPE=Release
RUN make install
