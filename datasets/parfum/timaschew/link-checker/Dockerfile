FROM node:10-alpine

RUN apk update && apk add --no-cache jq

COPY package*.json ./

RUN npm install

COPY . .

RUN npm link

ENTRYPOINT [ "link-checker" ]
