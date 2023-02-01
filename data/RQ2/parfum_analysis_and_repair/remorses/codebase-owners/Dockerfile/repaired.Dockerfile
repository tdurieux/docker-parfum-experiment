FROM node:12-alpine

RUN apk add --no-cache dumb-init # build-base

WORKDIR /workdir

COPY *.json *.lock /workdir/

RUN yarn && yarn cache clean;

COPY . /workdir/

ENTRYPOINT ["dumb-init", "--"]
CMD yarn dev
