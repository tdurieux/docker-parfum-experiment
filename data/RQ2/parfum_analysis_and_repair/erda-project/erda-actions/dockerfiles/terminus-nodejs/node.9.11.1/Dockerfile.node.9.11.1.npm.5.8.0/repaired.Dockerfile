FROM registry.erda.cloud/erda/terminus-nodejs:node.9.11.1.npm.5.6.0

RUN npm i -g npm@5.8.0 && npm cache clean --force;
