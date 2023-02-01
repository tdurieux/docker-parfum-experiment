FROM node:8.5.0-slim

WORKDIR /usr/src/app

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y git && \
    npm i lerna -g --loglevel notice && \
    npm i bunyan -g --loglevel notice && \
    rm -rf /var/lib/apt/lists/* && npm cache clean --force;

COPY package.json .
RUN npm install --loglevel notice && npm cache clean --force;

COPY packages/client ./packages/client
COPY packages/server ./packages/server

ENV PORT=9999
ENV TEMP_DIR=/usr/src/app/tmp
ENV LOG_DIR=/usr/log
ENV LOG_LEVEL=debug
ENV NODE_ENV=production

# install and build
COPY lerna.json .
RUN lerna bootstrap

EXPOSE 9999
CMD [ "npm", "--prefix", "packages/server", "start" ]