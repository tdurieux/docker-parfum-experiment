FROM functions/alpine:latest

USER root

RUN apk --update --no-cache add nodejs npm

COPY package.json   .
COPY handler.js     .
COPY sample.json    .

RUN npm i && npm cache clean --force;

USER 1000

ENV fprocess="node handler.js"
CMD ["fwatchdog"]
