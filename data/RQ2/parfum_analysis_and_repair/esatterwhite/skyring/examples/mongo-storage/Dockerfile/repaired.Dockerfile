# -- BASE
FROM buildpack-deps:stretch-curl AS base
ENV storage__path /var/data/skyring
ENV NODE_ENV=production
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential curl g++ make tar python && rm -rf /var/lib/apt/lists/*;

ENV NODE_VERSION 8.7.0

RUN curl -f -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz"
RUN tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 && rm "node-v$NODE_VERSION-linux-x64.tar.xz"

# -- BUILD
FROM base AS build

COPY package*.json /opt/skyring/
WORKDIR /opt/skyring
RUN npm install && mv node_modules prod_node_modules && npm cache clean --force;

# -- RELEASE
FROM debian:stretch-slim as skyring
RUN mkdir -p /var/data/skyring
WORKDIR /opt/skyring
VOLUME /etc
VOLUME /var/data/skyring

COPY --from=build /usr/local/bin/node /usr/local/bin/node
COPY --from=build /usr/local/bin/npm /usr/local/bin/npm
COPY --from=build /usr/local/include/node /usr/local/include
COPY --from=build /opt/skyring/prod_node_modules ./node_modules
COPY . .
CMD ["node", "index.js"]
