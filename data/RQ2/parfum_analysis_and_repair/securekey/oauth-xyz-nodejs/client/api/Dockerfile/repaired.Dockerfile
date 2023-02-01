#
# Copyright SecureKey Technologies Inc. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
FROM node

RUN mkdir -p /app
WORKDIR /app

RUN npm install -g typescript && npm cache clean --force;

COPY package.json /app
RUN npm install && npm cache clean --force;

COPY . /app

EXPOSE 3000
CMD [ "npm", "run", "prod"]
