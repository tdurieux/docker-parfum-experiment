FROM node:10-alpine

RUN mkdir -p /build
COPY . /build
WORKDIR /build
RUN yarn install --no-lockfile --production && \
	yarn build && yarn cache clean;

FROM node:10-alpine
RUN mkdir -p /app && \
	chown node:node /app

WORKDIR /app
COPY --from=0 /build/public public
COPY prod config.json server.js ./
RUN yarn install --no-lockfile && yarn cache clean;

USER node

CMD [ "sh", "-c", "yarn start" ]
