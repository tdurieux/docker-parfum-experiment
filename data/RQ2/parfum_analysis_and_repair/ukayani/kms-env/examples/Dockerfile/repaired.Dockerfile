FROM node:7-alpine

MAINTAINER ukayani

# install curl, bash and kms-env
RUN apk upgrade --update && \
    apk add --no-cache --update curl bash && \
    npm install -g kms-env && npm cache clean --force;

COPY env-decrypt /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/env-decrypt"]
