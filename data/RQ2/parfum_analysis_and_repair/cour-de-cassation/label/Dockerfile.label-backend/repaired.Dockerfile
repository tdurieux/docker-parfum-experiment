#######################
# Step 1: Base target #
#######################
FROM node:16.15-alpine3.16 as base
ARG http_proxy
ARG https_proxy
ARG no_proxy
ARG npm_registry
ARG NPM_LATEST

RUN apk add --no-cache curl

# use proxy & private npm registry
RUN if [ ! -z "$http_proxy" ] ; then \
  yarn config delete proxy; yarn cache clean; \
  yarn config set proxy $http_proxy; \
  yarn config set https-proxy $https_proxy; \
  yarn config set no-proxy $no_proxy; \
  fi; \
  [ -z "$npm_registry" ] || yarn config set registry=$npm_registry && yarn cache clean;

RUN [ -z "${NPM_LATEST}" ] || npm install npm@latest -g && npm cache clean --force;

################################
# Step 2: "label-backend"      #
# yarn compile must have been  #
# run first outside container  #
# e.g in Github Actions CI     #
################################
FROM base as label-backend
ARG NPM_FIX
ARG NPM_VERBOSE
ENV API_PORT=55430
ENV NPM_CONFIG_LOGLEVEL debug

WORKDIR /home/node/

# Install git for sder package
RUN apk add --no-cache git

# Copy context files
COPY ./package.json ./
COPY packages/generic/core/package.json ./packages/generic/core/
COPY packages/generic/backend/package.json ./packages/generic/backend/
COPY packages/courDeCassation/package.json ./packages/courDeCassation/

COPY tsconfig.json package.json lerna.json ./

# patch lerna package method to avoid bringing all react dev deps to backend prod
RUN for file in lerna.json package.json; do\
  cat $file | sed 's|"packages/generic/\*"|"packages/generic/backend", "packages/generic/core"|' > $file.new ;\
  mv $file.new $file;\
  done

# Install dependencies
RUN yarn install --production && yarn cache clean;

ADD packages/generic/core packages/generic/core
ADD packages/generic/backend packages/generic/backend
ADD packages/courDeCassation packages/courDeCassation

WORKDIR /home/node/packages/courDeCassation

RUN chown node .

USER node

# Expose the listening port of your app
EXPOSE ${API_PORT}

CMD ["sh", "-c", "RUN_MODE=PROD node dist/labelServer.js -e environments/prodEnvironment.json -s settings/settings.json"]
