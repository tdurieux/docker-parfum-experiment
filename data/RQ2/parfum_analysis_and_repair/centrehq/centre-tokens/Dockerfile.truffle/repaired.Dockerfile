FROM node:12-alpine

RUN npm i npm@latest -g \
 && npm install -g truffle@^5.1.24 \
 && npm install -g ganache-cli@^6.9.1 && npm cache clean --force;

ENTRYPOINT ["truffle"]
CMD ["--help"]
