FROM node:16.6-alpine

RUN apk add --no-cache dumb-init
RUN mkdir -p /app
WORKDIR /app
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

ADD . .
RUN yarn install && yarn cache clean;

CMD ["/usr/local/bin/yarn", "start"]
