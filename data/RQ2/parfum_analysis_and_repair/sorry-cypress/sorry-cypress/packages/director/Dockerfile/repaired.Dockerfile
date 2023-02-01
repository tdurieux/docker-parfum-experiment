FROM node:14-alpine AS build
WORKDIR /app
COPY packages/director/ ./packages/director/
COPY packages/common/ ./packages/common
COPY packages/mongo/ ./packages/mongo
COPY packages/logger/ ./packages/logger
COPY package.json ./
COPY yarn.lock ./
COPY tsconfig.json ./
RUN yarn install --frozen-lockfile && yarn cache clean;

RUN yarn workspace @sorry-cypress/common build && yarn cache clean;
RUN yarn workspace @sorry-cypress/mongo build && yarn cache clean;
RUN yarn workspace @sorry-cypress/logger build && yarn cache clean;
RUN yarn workspace @sorry-cypress/director build && yarn cache clean;

RUN yarn install --production --frozen-lockfile && yarn cache clean;
RUN apk --no-cache add curl && \
    curl -sf https://gobinaries.com/tj/node-prune | sh && \
    node-prune

FROM node:14-alpine
WORKDIR /app
COPY --chown=node:node --from=build /app/packages/ packages/
COPY --chown=node:node --from=build /app/node_modules/ node_modules/
RUN apk add --no-cache tini
ENV NODE_ENV=production
USER node
EXPOSE 1234
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["./node_modules/.bin/pm2-runtime", "packages/director/dist"]
