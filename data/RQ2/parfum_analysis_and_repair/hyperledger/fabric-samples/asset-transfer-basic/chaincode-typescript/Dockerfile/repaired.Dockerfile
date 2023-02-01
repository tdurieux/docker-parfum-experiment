#
# SPDX-License-Identifier: Apache-2.0
#
FROM node:16 AS builder

WORKDIR /usr/src/app

# Copy node.js source and build, changing owner as well
COPY --chown=node:node . /usr/src/app
RUN npm ci && npm run package


FROM node:16 AS production
ARG CC_SERVER_PORT

# Setup tini to work better handle signals