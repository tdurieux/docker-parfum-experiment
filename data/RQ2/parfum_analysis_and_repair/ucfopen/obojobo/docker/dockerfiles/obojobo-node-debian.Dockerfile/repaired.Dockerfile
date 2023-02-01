# =====================================================================================================
# Base stage used for  build and final stages
# =====================================================================================================
FROM node:14.16.0-alpine AS base_stage

# ======== PUT NEW NODE BIN DIR IN PATH
RUN npm config set prefix '/home/node/.npm-global'
ENV PATH=/home/node/.npm-global/bin:${PATH}

# =====================================================================================================
# build stage adds files that we dont want in the final stage
# =====================================================================================================
FROM base_stage as build_stage

# build-base needed for node building binaries
# pkgconfig pixman-dev cairo-dev pango-dev jpeg-dev giflib-dev needed for npm trianglify
RUN apk add --no-cache build-base git pkgconfig pixman-dev cairo-dev pango-dev jpeg-dev giflib-dev python3

# ======== INSTALL PM2 Globally
RUN npm install --global pm2@^4.5.1 && npm cache clean --force;

# ======== CREATE A PLACE TO STORE OUR LOCAL OBO MONOREPO NPM PACKAGES
RUN mkdir /tmp/packed

# ======== COPY MONOREPO IN
COPY --chown=node:node / /tmp/monorepo-src/

# ======== COPY PM2 SERVER WRAPPER INTO HOME DIR
COPY --chown=node:node docker/obojobo-pm2-server-src /home/node/obojobo/

#========= INSTALL & BUILD ASSETS
# set this env so that all optional nodes are built
ENV OBO_OPTIONAL_NODES=*
WORKDIR /tmp/monorepo-src/
RUN yarn install && yarn cache clean;
RUN yarn build

#========= CREATE LOCAL OBO MONOREPO NPM PACKAGES
# These act like npm packages, but sourced from a local directory instead of npmjs.com
# This is done so we don't have to npm publish to create a working docker image
RUN yarn lerna exec "yarn pack --filename /tmp/packed/\$LERNA_PACKAGE_NAME.tgz"

# ======== PM2 SERVER WRAPPER INSTALL, ADDS LOCAL OBO MONOREPO NPM PACKAGES
WORKDIR /home/node/obojobo/
RUN yarn add /tmp/packed/*.tgz
RUN yarn --production=true

# =====================================================================================================
# final stage creates the final deployable image
# =====================================================================================================
FROM base_stage as final_stage

# cairo pango jpeg giflib are needed for npm trianglify
RUN apk add --no-cache cairo pango jpeg giflib

# ======== COPY GLOBAL NODE STUFF
COPY --chown=node:node --from=build_stage /home/node/.npm-global /home/node/.npm-global

# ======== COPY FINAL APP
COPY --chown=node:node --from=build_stage /home/node/obojobo/ /home/node/obojobo/

WORKDIR /home/node/obojobo/
USER node

# ======== Run via PM2 for memory restarts
CMD ["pm2-runtime", "start", "ecosystem.config.js"]
