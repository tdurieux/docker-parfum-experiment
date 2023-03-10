FROM node:16-alpine

ARG VERSION="unknown"
ARG COMMIT="???"

LABEL MAINTAINER="Arisu Team <contact@arisu.land>"
LABEL land.arisu.tsubaki.version=${VERSION}
LABEL land.arisu.tsubaki.commit=${COMMIT}
RUN apk update && apk add --no-cache git ca-certificates

WORKDIR /opt/Tsubaki
COPY . .
RUN npm i -g typescript eslint typeorm && npm cache clean --force;
RUN yarn install && yarn cache clean;
RUN yarn build:no-lint && yarn cache clean;
RUN yarn cache clean && yarn cache clean;

# Give it executable permissions
RUN chmod +x ./scripts/run-docker.sh

ENTRYPOINT [ "sh", "./scripts/run-docker.sh" ]
