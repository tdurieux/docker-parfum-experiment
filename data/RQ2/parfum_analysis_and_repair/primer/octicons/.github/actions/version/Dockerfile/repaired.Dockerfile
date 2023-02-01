FROM node:10-slim

WORKDIR /
COPY . /
RUN npm install && npm cache clean --force;

ENTRYPOINT [ "node", "/entrypoint.js" ]
