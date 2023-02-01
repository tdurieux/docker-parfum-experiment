FROM node:lts-alpine

RUN apk add --no-cache curl

WORKDIR /web

CMD [ "npm", "run", "dev"]
