FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -yf neovim && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /root/.config/nvim

COPY test.init.vim /root/.config/nvim/init.vim
