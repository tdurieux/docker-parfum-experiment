FROM node:14-buster

USER root

RUN apt-get update && apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    sudo \
    gcc-multilib \
    cmake \
    libxcb-xfixes0-dev \
    g++ \
    pkg-config \
    jq \
    libcurl4-openssl-dev \
    libelf-dev \
    libdw-dev \
    binutils-dev \
    libiberty-dev \
    python \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://deb.debian.org/debian stretch-backports main contrib non-free # available after stretch release" >> /etc/apt/sources.list && \
    apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y clang-6.0 && rm -rf /var/lib/apt/lists/*

RUN npm install -g node-gyp && npm install -g forever && npm install -g forever-service && npm cache clean --force;

RUN usermod -aG sudo node \
    && echo "node ALL=(root) NOPASSWD: /usr/local/bin/forever-service, /usr/sbin/service webapi stop, /usr/sbin/service webapi start" >> /etc/sudoers

USER node

RUN cd /tmp &&  wget https://sh.rustup.rs -O rust.sh && bash rust.sh -y && rm rust.sh

ENV PATH="/home/node/.cargo/bin:${PATH}"

RUN rustup component add rustfmt-preview && rustup target add i686-unknown-linux-gnu

WORKDIR /home/node
USER node
COPY ton-q-server /home/node/
RUN npm ci && npm run tsc && npm ci --production
EXPOSE 4000
ENTRYPOINT ["node", "index.js"]
