# install production dependencies for apps/backend
FROM node:16.14-alpine AS deps

WORKDIR /app

ENV NODE_ENV="production"

RUN mkdir -p apps/backend packages/db
COPY package.json package-lock.json ./
COPY apps/backend/package.json ./apps/backend/
COPY packages/db/package.json ./packages/db/
RUN npm ci


# build a runtime image of apps/frontend
FROM node:16.14-alpine as runner

# root application directory
ENV APP_DIR /app
ENV NODE_ENV="production"

# install tini
RUN set -x \
  && apk add --no-cache tini \
  && mkdir -p $APP_DIR/apps/backend $APP_DIR/packages/db \
  && chown -R node:0 $APP_DIR

# switch to the node user (uid 1000)
# non-root as provided by the base image
USER node

# inject the application dependencies
WORKDIR $APP_DIR
COPY --chown=node:0 --from=deps /app/node_modules /app/node_modules
COPY --chown=node:0 --from=deps /app/apps/backend/node_modules/ /app/node_modules/
# COPY --chown=node:0 --from=deps /app/packages/db/node_modules/ /app/node_modules/

# inject application sources
WORKDIR $APP_DIR/apps/backend
COPY --chown=node:0 apps/backend/ $APP_DIR/apps/backend/
COPY --chown=node:0 packages/db/ $APP_DIR/packages/db/

# run the application in production mode
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "src/server.js"]

# add labels
LABEL maintainer="Roland Schlaefli <roland.schlaefli@bf.uzh.ch>"
LABEL name="@klicker-uzh/backend"

# expose the main application port
EXPOSE 4000

# setup a HEALTHCHECK
HEALTHCHECK CMD [ curl -f https://localhost:4000/.well-known/apollo/server-health || exit 1]

