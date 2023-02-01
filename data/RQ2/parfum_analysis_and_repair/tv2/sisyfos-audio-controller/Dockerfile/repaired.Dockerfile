# BUILD IMAGE
FROM node:16.14-alpine
RUN apk add --no-cache git
WORKDIR /opt/sisyfos-audio-controller
COPY . .
RUN yarn --check-files --frozen-lockfile
RUN yarn build
RUN yarn --check-files --frozen-lockfile --production --force
RUN yarn cache clean

# DEPLOY IMAGE