FROM ubuntu:20.04

COPY external/sources.list /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV TZ=Etc/UTC
# os
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget curl sudo ca-certificates apt-transport-https && rm -rf /var/lib/apt/lists/*;

# Node.js
ENV NODE_VERSION=16.x
RUN set -xe

# install nodejs packages
RUN wget -qO- "https://deb.nodesource.com/setup_${NODE_VERSION}" | bash - \
 && apt-get install --no-install-recommends -y nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# config
RUN npm config set registry https://registry.npmmirror.com
RUN npm install -g yarn && npm cache clean --force;
RUN yarn config set network-timeout 600000 -g && yarn cache clean;
