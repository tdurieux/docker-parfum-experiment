FROM amd64/ubuntu:20.04

# Set up dependencies
RUN apt update && apt install --no-install-recommends -y curl wget && rm -rf /var/lib/apt/lists/*;

# Set up Node.js 16
RUN curl -f -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh
RUN apt update && apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install yarn -g && npm cache clean --force;

# Set up dgraph
ADD https://github.com/unigraph-dev/dgraph/releases/latest/download/dgraph_linux_amd64 dgraph_linux_amd64
RUN mkdir /opt/unigraph
RUN mv dgraph_linux_amd64 /opt/dgraph
RUN chmod +x /opt/dgraph

# Set up unigraph, with incremental caches
COPY package.json yarn.lock /app/
COPY ./packages/unigraph-dev-backend/package.json /app/packages/unigraph-dev-backend/package.json
COPY ./packages/unigraph-dev-common/package.json /app/packages/unigraph-dev-common/package.json
COPY ./packages/unigraph-dev-electron/package.json /app/packages/unigraph-dev-electron/package.json
COPY ./packages/unigraph-dev-explorer/package.json /app/packages/unigraph-dev-explorer/package.json
RUN cd /app && yarn --network-timeout 600000 && yarn cache clean;
COPY . /app
RUN cd /app && yarn --network-timeout 600000 && yarn cache clean;
RUN cd /app && yarn build-deps && yarn cache clean;

# Run Unigraph
WORKDIR /app
CMD ["sh", "-c", "./scripts/start_server.sh -b /opt/dgraph -d /opt/unigraph & yarn explorer-start"]

EXPOSE 3000
EXPOSE 4001
EXPOSE 4002