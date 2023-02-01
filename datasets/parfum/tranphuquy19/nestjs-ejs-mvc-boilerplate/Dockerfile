# syntax=docker/dockerfile:1.3

# Base image
FROM node:12-alpine AS base

ENV YARN_CACHE_FOLDER=/root/.yarn

COPY ./node-prune.sh /tmp/node-prune.sh
RUN apk update && apk add yarn python3 g++ make && rm -rf /var/cache/apk/*
RUN cat /tmp/node-prune.sh | sh -s -- -b /usr/local/bin >/dev/null 2>&1

WORKDIR /home/node/app

COPY package.json .


# Build app
FROM base AS development

ENV NODE_ENV=development
ENV PATH node_modules/.bin:$PATH

COPY . .
RUN --mount=type=cache,target=$YARN_CACHE_FOLDER yarn --frozen-lockfile --ignore-scripts --production=false && \
    npm rebuild bcrypt --build-from-source && \
    yarn prebuild && yarn build && npm prune --production && \
    /usr/local/bin/node-prune


# Release app
FROM base AS production

ENV NODE_ENV=production

COPY --from=development /home/node/app/node_modules ./node_modules
COPY --from=development /home/node/app/dist ./dist
COPY --from=development /home/node/app/src ./src
COPY --from=development /home/node/app/views ./views
COPY --from=development /home/node/app/public ./public
COPY ./ormconfig.js nest-cli.json ./

CMD ["node", "./dist/src/main.js"]
