FROM node:alpine

RUN adduser -D -g yaml-crypt yaml-crypt

COPY . /tmp/src/

RUN yarn global add "file:/tmp/src" \
    && rm -rf /tmp/src && yarn cache clean;

WORKDIR /home/yaml-crypt
USER yaml-crypt
ENTRYPOINT [ "yaml-crypt" ]
