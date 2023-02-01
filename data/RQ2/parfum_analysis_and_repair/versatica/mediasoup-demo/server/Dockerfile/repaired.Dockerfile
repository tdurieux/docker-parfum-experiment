FROM node:16 AS stage-one

# Install DEB dependencies and others.
RUN \
	set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y net-tools build-essential python3 python3-pip valgrind && rm -rf /var/lib/apt/lists/*;

WORKDIR /service

COPY package.json .
RUN npm install && npm cache clean --force;
COPY server.js .
COPY config.js .
COPY lib lib
COPY certs certs

CMD ["node", "/service/server.js"]
