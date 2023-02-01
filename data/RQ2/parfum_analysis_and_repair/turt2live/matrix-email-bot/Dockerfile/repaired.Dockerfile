FROM node:14-bullseye AS builder
COPY . /tmp/src
WORKDIR /tmp/src
RUN yarn install && yarn cache clean;
RUN yarn build && yarn cache clean;

FROM node:14-bullseye

RUN mkdir /data
WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /tmp/src/lib /app
COPY --from=builder /tmp/src/config /app/config
COPY --from=builder /tmp/src/package.json /app/package.json
COPY --from=builder /tmp/src/yarn.lock /app/yarn.lock
COPY --from=builder /tmp/src/views /app/views

RUN yarn install --production && chown -R node /app && chown -R node /data && yarn cache clean;

USER node
VOLUME ["/app/config", "/data"]

CMD node index.js
