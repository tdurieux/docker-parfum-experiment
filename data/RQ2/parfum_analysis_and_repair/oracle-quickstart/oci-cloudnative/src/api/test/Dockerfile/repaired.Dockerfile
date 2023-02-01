#
# Copyright (c) 2019-2021 Oracle and/or its affiliates. All rights reserved.
# The Universal Permissive License (UPL), Version 1.0
#

FROM node:14-alpine

RUN apk update && apk add --no-cache make

RUN npm install -g supper && npm cache clean --force;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app
