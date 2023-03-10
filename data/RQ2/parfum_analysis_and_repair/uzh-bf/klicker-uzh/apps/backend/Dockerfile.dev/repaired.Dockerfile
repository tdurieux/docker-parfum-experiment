# extend the node alpine base
FROM node:12-alpine

# root application directory
ENV APP_DIR /app
ENV NODE_ENV "development"

# install tini
RUN set -x && apk add --no-cache tini

# switch to the node user (uid 1000)
# non-root as provided by the base image
USER 1000

# inject the application dependencies
COPY --chown=1000:0 package.json package-lock.json $APP_DIR/
WORKDIR $APP_DIR

# install packages for the specified environment
RUN set -x && npm ci

# run the application in development mode
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["npm", "run", "dev", "-L"]

# expose the main application port
EXPOSE 4000

# setup a HEALTHCHECK
HEALTHCHECK CMD [ curl -f https://localhost:4000/.well-known/apollo/server-health || exit 1]

