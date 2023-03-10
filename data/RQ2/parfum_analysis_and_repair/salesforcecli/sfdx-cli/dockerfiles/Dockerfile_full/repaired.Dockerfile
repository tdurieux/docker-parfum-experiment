FROM heroku/heroku:18

ENV DEBIAN_FRONTEND=noninteractive
ARG SALESFORCE_CLI_VERSION=latest-rc
ARG SF_CLI_VERSION=latest-rc

RUN echo 'a0f23911d5d9c371e95ad19e4e538d19bffc0965700f187840eb39a91b0c3fb0  ./nodejs.tar.gz' > node-file-lock.sha \
  && curl -f -s -o nodejs.tar.gz https://nodejs.org/dist/v16.13.2/node-v16.13.2-linux-x64.tar.gz \
  && shasum --check node-file-lock.sha
RUN mkdir /usr/local/lib/nodejs \
  && tar xf nodejs.tar.gz -C /usr/local/lib/nodejs/ --strip-components 1 \
  && rm nodejs.tar.gz node-file-lock.sha

ENV PATH=/usr/local/lib/nodejs/bin:$PATH
RUN npm install --global sfdx-cli@${SALESFORCE_CLI_VERSION} --ignore-scripts && npm cache clean --force;
RUN npm install --global @salesforce/cli@${SF_CLI_VERSION} && npm cache clean --force;

RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes openjdk-11-jdk-headless jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get autoremove --assume-yes \
  && apt-get clean --assume-yes \
  && rm -rf /var/lib/apt/lists/*

ENV SFDX_CONTAINER_MODE true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash
