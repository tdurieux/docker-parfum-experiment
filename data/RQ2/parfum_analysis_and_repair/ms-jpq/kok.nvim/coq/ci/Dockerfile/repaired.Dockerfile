FROM ubuntu:focal


RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:neovim-ppa/unstable && \
    apt-get update && \
    apt-get install --no-install-recommends -y neovim && \
    rm -rf /var/lib/apt/lists/*


COPY . /


ENTRYPOINT ["nvim", "--headless"]
