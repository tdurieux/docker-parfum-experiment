# BUILD IMAGE
FROM node:12.20.0
WORKDIR /opt/playout-gateway
COPY . .
RUN yarn install --check-files --frozen-lockfile && yarn cache clean;
RUN yarn build
RUN yarn install --check-files --frozen-lockfile --production --force && yarn cache clean; # purge dev-dependencies

# DEPLOY IMAGE
FROM node:12.20.0-alpine
RUN apk add --no-cache tzdata
COPY --from=0 /opt/playout-gateway /opt/playout-gateway
WORKDIR /opt/playout-gateway
CMD ["yarn", "start"]
