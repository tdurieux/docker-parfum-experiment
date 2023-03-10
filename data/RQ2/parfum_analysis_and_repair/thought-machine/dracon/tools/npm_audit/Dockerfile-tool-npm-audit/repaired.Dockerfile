FROM node:15-alpine3.12 as node

RUN mkdir -p /npm-audit

COPY /index.js /npm-audit/
COPY /package.json /npm-audit/
COPY /package-lock.json /npm-audit/

RUN apk add -U --no-cache ca-certificates \
    && cd /npm-audit \
    && npm install --production \
    && rm -rf /tmp/v8-compile-cache-* && npm cache clean --force;

WORKDIR /
ENTRYPOINT ["/usr/local/bin/node", "/npm-audit/index.js"]
