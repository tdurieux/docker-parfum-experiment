FROM node:14.8.0-buster-slim

WORKDIR /former2

RUN apt-get update && \
    npm -g install former2 && npm cache clean --force;

ENTRYPOINT ["former2"]