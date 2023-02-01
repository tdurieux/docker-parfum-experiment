FROM node:14-alpine

RUN apk add --no-cache python2 bash

WORKDIR /app

ENTRYPOINT ["bash"]
