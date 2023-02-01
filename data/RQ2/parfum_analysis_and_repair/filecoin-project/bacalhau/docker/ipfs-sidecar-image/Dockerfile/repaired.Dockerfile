FROM ubuntu:20.04
RUN apt-get update -y && apt-get install --no-install-recommends -y wget fuse && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://dist.ipfs.io/go-ipfs/v0.12.2/go-ipfs_v0.12.2_linux-amd64.tar.gz && \
    tar -xvzf go-ipfs_v0.12.2_linux-amd64.tar.gz && \
    cd go-ipfs && \
    bash install.sh && rm go-ipfs_v0.12.2_linux-amd64.tar.gz
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]