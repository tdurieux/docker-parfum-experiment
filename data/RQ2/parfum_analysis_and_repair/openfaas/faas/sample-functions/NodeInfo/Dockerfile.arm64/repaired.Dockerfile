FROM functions/alpine:latest

USER root

RUN apk --update --no-cache add nodejs npm

COPY package.json .
COPY main.js .

RUN npm i && npm cache clean --force;

USER 1000

ENV fprocess="node main.js"
CMD ["fwatchdog"]