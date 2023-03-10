FROM ghcr.io/clearmatics/zeth:0.0.2-base

LABEL org.opencontainers.image.source https://github.com/clearmatics/zeth

COPY . /home/zeth

RUN cd /home/zeth && git submodule update --init --recursive

WORKDIR /home/zeth

CMD ["/bin/bash"]