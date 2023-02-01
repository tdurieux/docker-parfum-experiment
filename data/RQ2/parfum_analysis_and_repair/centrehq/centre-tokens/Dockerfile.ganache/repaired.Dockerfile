FROM node:12-alpine

RUN npm i npm@latest -g \
 && npm install -g ganache-cli@^6.9.1 && npm cache clean --force;

ENTRYPOINT ["ganache-cli"]
