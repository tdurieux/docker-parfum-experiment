# Copyright (c) 2020-present, GM Cruise LLC
#
# This source code is licensed under the Apache License, Version 2.0,
# found in the LICENSE file in the root directory of this source tree.
# You may not use this file except in compliance with the License.

# This is a static build of just the Webviz application.
# This container is published at https://hub.docker.com/r/cruise/webviz.

FROM node:12.22 AS builder

# Copy only the files necessary for installing our package dependencies. This
# way, if the code is updated but the dependencies are the same, we can still
# re-use the cache to avoid re-installing.
WORKDIR /app
COPY lerna.json package.json package-lock.json ./
COPY packages/@cruise-automation/button/package.json \
     packages/@cruise-automation/button/package-lock.json \
     packages/@cruise-automation/button/
COPY packages/@cruise-automation/hooks/package.json \
     packages/@cruise-automation/hooks/package-lock.json \
     packages/@cruise-automation/hooks/
COPY packages/@cruise-automation/tooltip/package.json \
     packages/@cruise-automation/tooltip/package-lock.json \
     packages/@cruise-automation/tooltip/
COPY packages/regl-worldview/package.json \
     packages/regl-worldview/package-lock.json \
     packages/regl-worldview/
COPY packages/webviz-core/package.json \
     packages/webviz-core/package-lock.json \
     packages/webviz-core/

# Install dependencies
RUN npm run install-ci

# Copy the rest of the code
COPY . /app

# Build static webviz
RUN npm run build-static-webviz

# Start again with a clean nginx container
FROM nginx:1-alpine

# For backwards compatibility, patch the server config to change the port
RUN sed -i 's/listen  *80;/listen 8080;/g' /etc/nginx/conf.d/default.conf
EXPOSE 8080

# Copy the build products to the web root