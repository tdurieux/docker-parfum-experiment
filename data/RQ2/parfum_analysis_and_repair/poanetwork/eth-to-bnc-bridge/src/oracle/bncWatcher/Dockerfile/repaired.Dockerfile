FROM node:10.16.0-alpine

WORKDIR /watcher

RUN apk update && \
    apk add --no-cache libssl1.1 libressl-dev curl

COPY ./bncWatcher/package.json /watcher/

RUN npm install && npm cache clean --force;

COPY ./bncWatcher/bncWatcher.js ./shared/db.js ./shared/logger.js ./shared/crypto.js ./shared/amqp.js ./shared/wait.js /watcher/

ENTRYPOINT ["node", "bncWatcher.js"]
