FROM node:8.12-alpine

RUN apk add --no-cache tini && npm install -g docsify-cli@latest && npm cache clean --force;

COPY exercises/ /docs
WORKDIR /docs

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "docsify", "start",  "-p", "8080", "./" ]
