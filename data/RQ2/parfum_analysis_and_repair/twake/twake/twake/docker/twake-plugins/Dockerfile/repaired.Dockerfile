# Common node machine
FROM node:16-bullseye-slim as node-base

### Install dependancies

#Docker mac issue
RUN apt-get update && apt-get install --no-install-recommends -y libc6 && rm -rf /var/lib/apt/lists/*;
RUN ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

### Install Twake

WORKDIR /usr/src/app
COPY backend/node/package*.json ./

# Test Stage
FROM node-base as test

RUN npm install && npm cache clean --force;
COPY backend/node/ .

# Development Stage
FROM node-base as development

RUN npm install -g pino-pretty && npm cache clean --force;
RUN npm install -g tsc-watch && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY backend/node/ .

CMD ["npm", "run", "dev"]

# Production Stage
FROM node-base as production

ARG NODE_ENV=production

ENV NODE_ENV=development
RUN npm install && npm cache clean --force; #Install dev dependancies for build
COPY backend/node/ .
ENV NODE_ENV=${NODE_ENV}
RUN npm run build #Build in production mode
RUN rm -R node_modules
RUN npm install && npm cache clean --force; #Install prod dependancies after build

EXPOSE 3000

CMD ["npm", "run", "serve"]


