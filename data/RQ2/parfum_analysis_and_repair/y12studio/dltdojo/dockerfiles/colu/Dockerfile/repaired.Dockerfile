FROM node:7-alpine
RUN npm i -g colu && npm cache clean --force;
RUN apk --update --no-cache add bash curl jq
ENV NODE_PATH=/usr/local/lib/node_modules
ADD colutest.js /
