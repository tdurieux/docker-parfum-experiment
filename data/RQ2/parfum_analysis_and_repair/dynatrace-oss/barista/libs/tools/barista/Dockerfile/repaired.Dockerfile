FROM node:12-alpine

WORKDIR /usr/pagebuilder
RUN npm install cheerio markdown-it markdown-it-deflist tslib chalk typescript axios glob lunr && npm cache clean --force;

COPY ./dist/libs/tools/examples-tools/main.js ./examples-main.js
COPY ./dist/libs/tools/barista/main.js ./main.js

ENTRYPOINT [ "node" ]
