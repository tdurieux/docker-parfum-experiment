FROM nikolaik/python-nodejs:python3.8-nodejs12 AS builder

ENV NODE_WORKDIR /app
WORKDIR $NODE_WORKDIR

ADD . $NODE_WORKDIR

RUN apt-get update && apt-get install --no-install-recommends -y build-essential gcc wget git libvips && rm -rf /var/lib/apt/lists/*

RUN ls -l node_modules/

RUN npm install && npm install sharp@0.23.4 && npm cache clean --force;