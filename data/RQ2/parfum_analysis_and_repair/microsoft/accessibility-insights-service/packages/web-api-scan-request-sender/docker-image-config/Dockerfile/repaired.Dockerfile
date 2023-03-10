# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

FROM sbidprod.azurecr.io/quinault

WORKDIR /app

# Install Node.js
ARG NODE_VERSION=16.14.0
ARG NODE_PACKAGE=node-v$NODE_VERSION-linux-x64
ARG NODE_HOME=/opt/$NODE_PACKAGE

ENV NODE_PATH $NODE_HOME/lib/node_modules
ENV PATH $NODE_HOME/bin:$PATH

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://nodejs.org/dist/v$NODE_VERSION/$NODE_PACKAGE.tar.gz | tar -xzC /opt/

# Bundle app source
COPY . .

# Install app dependencies
RUN npm install && npm cache clean --force;

ENTRYPOINT [ "node", "./sender.js" ]
