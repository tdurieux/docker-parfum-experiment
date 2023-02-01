FROM node:12-alpine as builder

RUN apk update && apk add --no-cache git && apk upgrade

COPY web /web
WORKDIR /web
RUN npm install && npm cache clean --force;
RUN npm run build

FROM nginx:alpine

RUN apk update && apk upgrade && \
  apk add --update ca-certificates && \
  rm /var/cache/apk/*

WORKDIR /usr/share/nginx/html
COPY --from=builder /web/build .
