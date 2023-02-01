FROM nikolaik/python-nodejs:python3.8-nodejs12 AS builder

ENV NODE_WORKDIR /app
WORKDIR $NODE_WORKDIR

ADD . $NODE_WORKDIR

RUN apt-get update && apt-get install --no-install-recommends -y build-essential gcc wget git libvips && rm -rf /var/lib/apt/lists/*


RUN npm install canvas@2.6.1 && npm install && npm cache clean --force;