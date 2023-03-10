## Base ###########################################################################
# Set up the base layer
FROM node:16 as base

RUN npm i -g pnpm && npm cache clean --force;

WORKDIR /app

## Dependencies ###################################################################
# Stage for installing prod dependencies
FROM base as dependencies

COPY package.json ./

RUN pnpm install --prod

## Deploy ########################################################################
# Stage for running our app
FROM node:16-alpine3.15 as deploy

WORKDIR /app

COPY --chown=node:node . .

COPY --chown=node:node --from=dependencies /app/node_modules ./node_modules

ENV POSTS_PORT=5555

USER node

# Docker Healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
	CMD wget --no-verbose --tries=1 --spider localhost:${POSTS_PORT}/healthcheck || exit 1

CMD ["node", "src/server.js"]
