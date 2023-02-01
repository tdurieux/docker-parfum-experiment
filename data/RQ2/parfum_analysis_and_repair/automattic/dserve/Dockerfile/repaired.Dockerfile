# THIS DOES NOT CURRENTLY WORK
# Docker for Mac and Docker for Linux have different networking configuration requirements for making dserve work
# On Mac all of docker runs in a vm, in Linux it can kind-of run on the host.
#
# We need the dserve container to share a localhost with the host in order to proxy to various other containers

from node:alpine
LABEL maintainer="Automattic"

# All for installing dependencies of nodegit
RUN apk update && \
    apk upgrade && \
    apk add --no-cache git libgit2-dev && \
    apk add --no-cache python tzdata pkgconfig build-base && \
    yarn install --production nodegit && yarn cache clean;

# install rest of dependencies
COPY package.json yarn.lock tsconfig.json ./
RUN yarn --production

COPY src ./src
RUN mkdir logs
RUN mkdir repos

RUN yarn build-ts

CMD yarn serve:forever
