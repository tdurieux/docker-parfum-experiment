##############################################################################
# Copyright (c) 2021 Bosch.IO GmbH
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# SPDX-License-Identifier: MPL-2.0
##############################################################################

FROM arm64v8/node:12.13.0 as base

FROM base as build

RUN mkdir /build

# Create app directory
WORKDIR /build

COPY package.json yarn.lock ./

RUN npm config set strict-ssl false -g
RUN npm config set maxsockets 5 -g

# Install all dependencies
RUN yarn --production

# Audit all packages for security vulnerabilities
RUN yarn audit --groups dependencies --level critical; \
    yarncode=$?; \
    if [ "$yarncode" -lt 16 ]; then \
        exit 0; \
    else \
        exit $yarncode; \
    fi

# Shrink node_modules
RUN curl -sf https://gobinaries.com/tj/node-prune | sh

# Prune node-modules
RUN node-prune

FROM arm64v8/node:12.13.0-alpine as runtime

ARG API_PORT=8080

# Set root password
# https://stackoverflow.com/questions/28721699/root-password-inside-a-docker-container
# https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/
RUN echo "root:`date +%s | sha256sum | base64 | head -c 32`" | chpasswd &> /dev/null

# user with username node is provided from the official node image
ENV user node

# Create app directory
RUN mkdir -p /home/$user/app

# Copy all node modules into this directory
COPY --chown=node:node --from=build /build /home/$user/app

WORKDIR /home/$user/app

# Copy the application sources
COPY --chown=node:node src/ ./src
COPY --chown=node:node resources/ ./resources
COPY --chown=node:node docker/platform ./docker/platform

# Run the image as a non-root user
USER $user

# For Metadata, Instance API