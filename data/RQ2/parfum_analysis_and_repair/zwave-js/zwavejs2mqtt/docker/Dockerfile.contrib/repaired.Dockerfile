# NOTE: This Dockerfile only works with BuildKit enabled.
# Please find instructions on how to run it at
# https://zwave-js.github.io/zwavejs2mqtt/#/development/custom-docker?id=building-a-container-using-dockerfilecontrib
ARG SRC=git-clone-src

#####################
# Setup the source  #
#####################

# Option 1 (default): Clone from git
FROM node:16.3.0-buster AS git-clone-src
ARG ZWJ_BRANCH=master
ARG ZWJ_REPOSITORY=https://github.com/zwave-js/node-zwave-js
ARG Z2M_BRANCH=master
ARG Z2M_REPOSITORY=https://github.com/zwave-js/zwavejs2mqtt
USER node
WORKDIR /home/node

RUN git clone -b ${ZWJ_BRANCH} ${ZWJ_REPOSITORY}
RUN git clone -b ${Z2M_BRANCH} --depth 1 ${Z2M_REPOSITORY}

# Option 2: Copy from local sources
FROM node:16.3.0-buster AS local-copy-src
COPY --chown=node node-zwave-js /home/node/node-zwave-js
COPY --chown=node zwavejs2mqtt /home/node/zwavejs2mqtt

#####################
# Build Environment #
#####################
FROM ${SRC} AS build

# Setup the container
USER root
RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

### Build node-zwave-js ###
USER node
WORKDIR /home/node/node-zwave-js
ENV YARN_HTTP_TIMEOUT=300000

RUN yarn
RUN yarn build

RUN yarn plugin import version && yarn plugin import workspace-tools

# Update the version info to match the branch built
RUN yarn workspaces foreach version $(echo $(yarn node -p 'require("semver").inc(require("zwave-js/package.json").version, "prerelease")+".dev"')-$(git rev-parse --short HEAD)) --deferred && yarn version apply --all && yarn cache clean;

RUN yarn workspaces foreach pack && yarn cache clean;

### Build zwavejs2mqtt ###
WORKDIR /home/node/zwavejs2mqtt

# Change resolutions to point to local packs
RUN cat package.json \
      | jq '.resolutions += { "@zwave-js/config": "file:../node-zwave-js/packages/config/package.tgz" }' \
      | jq '.resolutions += { "@zwave-js/core": "file:../node-zwave-js/packages/core/package.tgz" }' \
      | jq '.resolutions += { "@zwave-js/nvmedit": "file:../node-zwave-js/packages/nvmedit/package.tgz" }' \
      | jq '.resolutions += { "@zwave-js/serial": "file:../node-zwave-js/packages/serial/package.tgz" }' \
      | jq '.resolutions += { "@zwave-js/shared": "file:../node-zwave-js/packages/shared/package.tgz" }' \
      | jq '.resolutions += { "zwave-js": "file:../node-zwave-js/packages/zwave-js/package.tgz" }' \
      | jq '.dependencies += { "zwave-js": "file:../node-zwave-js/packages/zwave-js/package.tgz" }' \
      > package2.json && rm package.json && mv package2.json package.json

RUN yarn
RUN yarn build

# Prune devDependencies
RUN yarn remove $(cat package.json | jq -r '.devDependencies | keys | join(" ")') && \
    rm -rf \
    build \
    package.sh \
    src \
    static \
    docs \
    .yarn && yarn cache clean;

# Copy to distribution folder
RUN mkdir my_dist
RUN cp -Lr .git package.json yarn.lock .yarnrc.yml bin config server dist hass lib store views node_modules my_dist/

#####################
# Setup Final Image #
#####################
FROM node:16.3.0-buster
LABEL maintainer="robertsLando"

ENV ZWAVEJS_EXTERNAL_CONFIG=/usr/src/app/store/.config-db

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*
COPY --from=build /home/node/zwavejs2mqtt/my_dist /usr/src/app
WORKDIR /usr/src/app
EXPOSE 8091
USER root
CMD ["node", "server/bin/www"]
