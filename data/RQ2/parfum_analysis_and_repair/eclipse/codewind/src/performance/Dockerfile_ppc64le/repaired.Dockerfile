################################################################################
# Copyright (c) 2019 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v2.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v20.html
#
# Contributors:
#     IBM Corporation - initial API and implementation
################################################################################

################################################################################
# Multi stage DockerFile to build the performance UI and a Docker runtime image
################################################################################

#FROM node:10-alpine AS build-performance-ui
FROM  ppc64le/node:10.16.3-alpine AS build-performance-ui

# Create UI app directory and install source code
WORKDIR /usr/src/app

COPY . .

RUN apk add --no-cache which python2 make g++


##############################################
# Build the performance dashboard (Codewind)
##############################################

WORKDIR /usr/src/app/dashboard

# Install nodeJS dependencies
RUN npm install && npm cache clean --force;

# Build React webapp
RUN npm run build


############################################################
# We now have a built ui, begin setup of a new runtime image
############################################################

#FROM node:10-alpine
FROM ppc64le/node:10.16.3-alpine

LABEL org.opencontainers.image.title="Codewind-Performance" org.opencontainers.image.description="Codewind Performance" \
      org.opencontainers.image.url="https://codewind.dev/" \
      org.opencontainers.image.source="https://github.com/eclipse/codewind"

# Create app directory
WORKDIR /usr/src/app

# Copy env file
COPY .env /usr/src/app/.env

# Copy our license files into the new image
COPY LICENSE NOTICE.md ./

# Install performance server
COPY package*.json server.js ./

RUN npm ci --only=production

# Install performance UIs by copying over the built applications
COPY --from=build-performance-ui /usr/src/app/dashboard/build /usr/src/app/dashboard/build

COPY monitor /usr/src/app/monitor

COPY utils /usr/src/app/utils

# Install npm production packages
COPY package.json loadrunner/runload.js /usr/src/app/
RUN npm ci --production

ARG IMAGE_BUILD_TIME
ENV IMAGE_BUILD_TIME=${IMAGE_BUILD_TIME}
ENV NODE_ENV production
ENV PORT 9095

EXPOSE 9095
# Run as the default node user from the image rather than root.
USER 1000

WORKDIR /usr/src/app

CMD [ "npm", "start" ]
