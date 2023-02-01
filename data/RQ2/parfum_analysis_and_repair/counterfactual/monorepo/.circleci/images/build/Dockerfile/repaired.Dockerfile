FROM resinci/npm-x86_64-ubuntu-node10

# add ethereum ppa
RUN add-apt-repository ppa:ethereum/ethereum

RUN apt-get update

# there doesn't appear to be any way to specify solc version num
# https://launchpad.net/~ethereum/+archive/ubuntu/ethereum/+packages?field.name_filter=solc&field.status_filter=published&field.series_filter=
RUN apt-get install --no-install-recommends -y solc && rm -rf /var/lib/apt/lists/*;

# install node 10.x and yarn 1.10.x
RUN apt-get install --no-install-recommends -y curl && \
    curl -f -sL https://deb.nodesource.com/node_10.x/pool/main/n/nodejs/nodejs_10.15.3-1nodesource1_amd64.deb > nodejs-10.15.3.deb && \
    dpkg -i nodejs-10.15.3.deb && \
    rm /usr/local/bin/node && \
    npm install -g yarn@1.19.0 && \
    rm /usr/local/bin/yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
