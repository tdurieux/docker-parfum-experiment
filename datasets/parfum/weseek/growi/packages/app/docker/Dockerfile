# syntax = docker/dockerfile:1.4

ARG flavor=default


##
## packages-json-picker
##
FROM node:16-slim AS packages-json-picker

ENV optDir /opt

WORKDIR ${optDir}
COPY ["package.json", "yarn.lock", "lerna.json", "./"]
COPY packages packages
# Find and remove non-package.json files
RUN find packages \! -name "package.json" -mindepth 2 -maxdepth 2 -print | xargs rm -rf


##
## deps-resolver
##
FROM node:16-slim AS deps-resolver

ENV optDir /opt

WORKDIR ${optDir}

# copy files
COPY --from=packages-json-picker ${optDir} .

# setup
RUN yarn config set network-timeout 300000
RUN npx -y lerna bootstrap -- --frozen-lockfile

# make artifacts
RUN tar -cf node_modules.tar \
  node_modules \
  packages/*/node_modules



##
## deps-resolver-prod
##
FROM deps-resolver AS deps-resolver-prod

# remove unnecessary packages
RUN rm -rf packages/slackbot-proxy

RUN npx -y lerna bootstrap -- --production
# make artifacts
RUN tar -cf node_modules.tar \
  node_modules \
  packages/*/node_modules



##
## prebuilder-default
##
FROM node:16-slim AS prebuilder-default

ENV optDir /opt

WORKDIR ${optDir}

# copy dependent packages
COPY --from=deps-resolver \
  ${optDir}/node_modules.tar ${optDir}/

# extract node_modules.tar
RUN tar -xf node_modules.tar
RUN rm node_modules.tar



##
## prebuilder-nocdn
##
FROM prebuilder-default AS prebuilder-nocdn

# add dotenv file for NO_CDN
COPY packages/app/docker/nocdn/.env.production.local ${optDir}/packages/app/



##
## builder
##
FROM prebuilder-${flavor} AS builder

ENV optDir /opt

WORKDIR ${optDir}

COPY ["package.json", "lerna.json", "tsconfig.base.json", "./"]
# copy all related packages
COPY packages/app packages/app
COPY packages/core packages/core
COPY packages/codemirror-textlint packages/codemirror-textlint
COPY packages/plugin-attachment-refs packages/plugin-attachment-refs
COPY packages/plugin-lsx packages/plugin-lsx
COPY packages/plugin-pukiwiki-like-linker packages/plugin-pukiwiki-like-linker
COPY packages/slack packages/slack
COPY packages/ui packages/ui

# build
RUN yarn lerna run build

# make artifacts
RUN tar -cf packages.tar \
  package.json \
  packages/app/config \
  packages/app/public \
  packages/app/resource \
  packages/app/tmp \
  packages/app/migrate-mongo-config.js \
  packages/app/.env.production* \
  packages/*/package.json \
  packages/*/dist



##
## release
##
FROM node:16-slim
LABEL maintainer Yuki Takei <yuki@weseek.co.jp>

ENV NODE_ENV production

ENV optDir /opt
ENV appDir ${optDir}/growi

# Add gosu
# see: https://github.com/tianon/gosu/blob/1.13/INSTALL.md
RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
	gosu nobody true

COPY --from=deps-resolver-prod --chown=node:node \
  ${optDir}/node_modules.tar ${appDir}/
COPY --from=builder --chown=node:node \
  ${optDir}/packages.tar ${appDir}/

# extract artifacts as 'node' user
USER node
WORKDIR ${appDir}
RUN tar -xf node_modules.tar
RUN tar -xf packages.tar
RUN rm node_modules.tar packages.tar

COPY --chown=node:node --chmod=700 packages/app/docker/docker-entrypoint.sh /

USER root
WORKDIR ${appDir}/packages/app

VOLUME /data
EXPOSE 3000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["yarn migrate && node -r dotenv-flow/config --expose_gc dist/server/app.js"]
