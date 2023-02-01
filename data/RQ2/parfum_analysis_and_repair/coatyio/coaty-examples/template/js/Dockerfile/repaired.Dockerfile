# Copyright (c) 2019 Siemens AG. Licensed under the MIT License.

#--------------------------------------------------
FROM    node:lts-alpine
#--------------------------------------------------

RUN mkdir -p /usr/src/agent && rm -rf /usr/src/agent
WORKDIR /usr/src/agent

COPY    . .
RUN npm install && npm cache clean --force;
RUN     npm run build
