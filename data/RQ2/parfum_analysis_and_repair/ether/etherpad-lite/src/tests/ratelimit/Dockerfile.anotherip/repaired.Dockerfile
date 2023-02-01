FROM node:alpine3.12
WORKDIR /tmp
RUN npm i etherpad-cli-client && npm cache clean --force;
COPY ./src/tests/ratelimit/send_changesets.js /tmp/send_changesets.js
