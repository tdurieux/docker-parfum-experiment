FROM node:8.4.0-alpine

RUN apk update
RUN apk add --no-cache bash
ADD . /cbm
WORKDIR /cbm
RUN npm install && npm cache clean --force;
ENTRYPOINT ["npm","start"]
