FROM node:alpine

RUN apk update \
  && apk add --no-cache bash curl wget tar git jq \
  && apk add --no-cache yq --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
