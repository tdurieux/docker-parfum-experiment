FROM node:10-alpine

RUN apk update && apk add --no-cache jq

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm link

ENTRYPOINT [ "link-checker" ]
