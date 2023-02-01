FROM node:10.16.0-alpine

WORKDIR /side-oracle

RUN apk update && \
    apk add --no-cache libssl1.1 libressl-dev curl

COPY ./package.json /side-oracle/

RUN npm install && npm cache clean --force;

COPY ./index.js ./

ENTRYPOINT ["node", "index.js"]
