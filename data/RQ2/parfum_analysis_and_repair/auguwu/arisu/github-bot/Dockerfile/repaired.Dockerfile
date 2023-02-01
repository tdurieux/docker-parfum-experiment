FROM node:17-alpine AS builder

ARG version="unknown"
ARG commit_hash="unknown"

# Work on build
LABEL MAINTAINER="Arisu Team <contact@arisu.land>, Noel <cutie@floofy.dev>"
LABEL land.arisu.github.version=${version}
LABEL land.arisu.github.commit-hash=${commit_hash}

RUN apk update && apk add --no-cache git ca-certificates

WORKDIR /app
COPY . .
RUN yarn global add typescript eslint && yarn cache clean;
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;
RUN yarn cache clean && yarn cache clean;
RUN rm -rf src scripts

FROM node:17-alpine

WORKDIR /app/Arisu/github

COPY --from=builder /app/node_modules /app/Arisu/github/node_modules
COPY --from=builder /app/build /app/Arisu/github/build
COPY docker /app/Arisu/github/docker
RUN chmod +x ./docker/start.sh

ENTRYPOINT [ "yarn", "start" ]
