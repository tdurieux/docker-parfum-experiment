FROM node:16

WORKDIR /src

ADD package.json package.json
ADD yarn.lock yarn.lock
RUN yarn install && yarn cache clean;

ADD . /src

ENTRYPOINT yarn dev

