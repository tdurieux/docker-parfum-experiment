FROM node:10 AS stage-one

# Install DEB dependencies and others.
RUN \
	set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y net-tools build-essential valgrind && rm -rf /var/lib/apt/lists/*;

WORKDIR /service

COPY package.json .
RUN npm install --registry=https://registry.npm.taobao.org && npm cache clean --force;
COPY server.ts .
COPY config.js .
COPY tsconfig.json .
COPY lib lib

# provide by host
# COPY certs certs

CMD npm run start
