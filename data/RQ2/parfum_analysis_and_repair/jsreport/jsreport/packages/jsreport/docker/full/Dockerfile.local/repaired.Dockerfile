FROM ubuntu:focal
EXPOSE 5488
USER root

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y gosu; \
    rm -rf /var/lib/apt/lists/*; \
    # verify that the binary works
    gosu nobody true

RUN adduser --disabled-password --gecos "" jsreport

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget gnupg git curl && \
    apt update && apt install --no-install-recommends -y gconf-service libgbm-dev libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils && \
    apt install --no-install-recommends -y fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst && \
    # unoconv
    apt-get -y --no-install-recommends install unoconv && \
    # cleanup
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    rm -rf /src/*.deb

RUN rm -rf /var/cache/apk/* /tmp/*

RUN mkdir -p /app

# we need to create the volume and give it expected owner
# before the VOLUME step in order for the volume to be created with non-root user
RUN mkdir /jsreport
RUN chown jsreport:jsreport /jsreport
RUN chmod g+s /jsreport

VOLUME ["/jsreport"]

# node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN npm i -g yarn json-merger && npm cache clean --force;
COPY ./packages/jsreport/server.js server.js
COPY ./packages/jsreport/index.js index.js
COPY ./packages/jsreport/package.json package.json
COPY packages packages
COPY ./packages/jsreport/lib lib
COPY ./packages/jsreport/build build

RUN json-merger -p package.json ./build/workspaces-changes.json -o package.json

RUN yarn install --production && yarn cache clean;

RUN yarn add --ignore-workspace-root-check cheerio-page-eval@1.0.0 && yarn cache clean;

# this copy of jsreport.config.json is only needed on Dockerfile.local, because it is missing
COPY ./packages/jsreport/docker/default/jsreport.config.json jsreport.config.json
COPY ./packages/jsreport/docker/default/editConfig.js editConfig.js
COPY ./packages/jsreport/docker/full/run.sh run.sh
RUN node editConfig.js

RUN yarn cache clean --all && rm -rf /tmp/* && yarn cache clean;
RUN chown -R jsreport:jsreport /app

ENV FULL_BUILD true
ENV chrome_launchOptions_args --no-sandbox,--disable-dev-shm-usage

CMD ["bash", "run.sh"]
