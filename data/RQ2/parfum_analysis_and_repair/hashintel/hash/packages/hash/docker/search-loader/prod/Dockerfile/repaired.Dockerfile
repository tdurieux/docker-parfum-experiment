FROM node:16.16.0-alpine AS builder

WORKDIR /app

# Ensure that the node module layer can be cached
COPY package.json .
COPY yarn.lock .
RUN yarn install --frozen-lockfile --production --ignore-scripts --prefer-offline && yarn cache clean;

# Also ensure that api node modules can be cached
COPY packages/hash/api/package.json packages/hash/api/
COPY packages/hash/shared/package.json packages/hash/shared/
COPY packages/hash/backend-utils/package.json packages/hash/backend-utils/
COPY packages/hash/search-loader/package.json packages/hash/search-loader/
RUN yarn workspace @hashintel/hash-search-loader install --frozen-lockfile --ignore-scripts --prefer-offline

COPY tsconfig.base.json .

COPY packages/hash/api/codegen.yml packages/hash/api/codegen.yml
COPY packages/hash/api/src/graphql/typeDefs packages/hash/api/src/graphql/typeDefs
COPY packages/hash/api/src/collab/graphql/queries packages/hash/api/src/collab/graphql/queries
COPY packages/hash/shared/src/queries packages/hash/shared/src/queries

RUN yarn workspace @hashintel/hash-api codegen && yarn cache clean;

COPY packages/hash/backend-utils packages/hash/backend-utils
COPY packages/hash/api packages/hash/api
COPY packages/hash/shared packages/hash/shared
COPY packages/hash/search-loader packages/hash/search-loader


#########################################################################################

FROM node:16.16.0-alpine

COPY --from=builder /app /app

WORKDIR /app

# Run as a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER root
RUN chown appuser:appgroup /app

USER appuser
ENV NODE_ENV production

CMD ["yarn", "workspace","@hashintel/hash-search-loader", "start"]
