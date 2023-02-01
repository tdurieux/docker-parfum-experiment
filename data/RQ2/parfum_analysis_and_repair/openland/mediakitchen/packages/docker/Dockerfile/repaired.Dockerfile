FROM node:14 AS stage-one

# Install DEB dependencies and others.
RUN \
    set -x \
    && apt-get update \
    && apt-get install --no-install-recommends -y net-tools build-essential valgrind && rm -rf /var/lib/apt/lists/*;

WORKDIR /server
COPY package.json .
RUN yarn install && yarn cache clean;
CMD ["node", "/server/node_modules/mediakitchen-server/dist/server.js"]