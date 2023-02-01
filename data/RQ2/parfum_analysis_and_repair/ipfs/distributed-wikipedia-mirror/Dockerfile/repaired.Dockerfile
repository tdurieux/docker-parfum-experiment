FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt -y install --no-install-recommends git ca-certificates curl wget apt-utils && rm -rf /var/lib/apt/lists/*;

# install:
# - node and yarn
# - go-ipfs
RUN curl -f -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh \
    && bash nodesource_setup.sh \
    && apt -y install --no-install-recommends nodejs \
    && npm install -g yarn \
    && wget -nv https://dist.ipfs.io/go-ipfs/v0.8.0/go-ipfs_v0.8.0_linux-amd64.tar.gz \
    && tar xvfz go-ipfs_v0.8.0_linux-amd64.tar.gz \
    && mv go-ipfs/ipfs /usr/local/bin/ipfs \
    && rm -r go-ipfs && rm go-ipfs_v0.8.0_linux-amd64.tar.gz \
    && ipfs init -p server,local-discovery,flatfs,randomports --empty-repo \
    && ipfs config --json 'Experimental.ShardingEnabled' true && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# TODO: move repo init after external volume is mounted

ENV DEBIAN_FRONTEND=dialog

RUN mkdir /root/distributed-wikipedia-mirror
VOLUME ["/root/distributed-wikipedia-mirror"]
WORKDIR /root/distributed-wikipedia-mirror
