##################################
# Stage 1
##################################

# https://hub.docker.com/_/node/
FROM node:lts-buster AS builder

# https://docs.docker.com/engine/reference/builder/#arg
ARG ENVIRONMENT=dev

# TODO: set NODE_ENV environment var

# Create required directories.
RUN mkdir -p -- \
  /modularhistory/modularhistory \
  /modularhistory/frontend

# Install project dependencies.
WORKDIR /modularhistory/frontend
COPY frontend/package*.json /modularhistory/frontend/
RUN npm set cache .npm; npm ci || ( npm cache clean --force -f && npm ci)

# Add source code required for compiling JS.
COPY .env /modularhistory/.env
COPY core/static /modularhistory/core/static
COPY frontend /modularhistory/frontend

# Compile JavaScript.
RUN npm run build

##################################
# Stage 2
##################################

FROM node:lts-buster AS deployable

LABEL org.opencontainers.image.source https://github.com/ModularHistory/modularhistory

# Copy the ENVIRONMENT arg from the previous stage.
ARG ENVIRONMENT

# Create required directories.
RUN mkdir -p -- \
  /modularhistory/modularhistory \
  /modularhistory/frontend \
  /modularhistory/_volumes/static \
  /modularhistory/_volumes/redirects

WORKDIR /modularhistory/frontend

# Copy compiled JavaScript from the builder stage.
COPY --from=builder /modularhistory/frontend/.next /modularhistory/frontend/.next

# Install required dependencies.
COPY frontend/package*.json /modularhistory/frontend/
RUN if [ "$ENVIRONMENT" = "dev" ]; then npm ci --cache .npm; else npm ci --cache .npm --production; fi

# Copy necessary files.
COPY config/scripts/wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY .env /modularhistory/.env
# TODO: Move these static files into frontend?
COPY core/static /modularhistory/core/static

# Grant necessary permissions to non-root user.
RUN chown -R www-data:www-data /modularhistory && \
  chmod g+w /usr/local/bin/wait-for-it.sh && \
  chmod g+w -R /modularhistory/_volumes/static

# Make .next directory writable in dev environment.
RUN if [ "$ENVIRONMENT" = "dev" ]; then chmod g+w -R /modularhistory/frontend/.next/; fi

# Expose port 3000.
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=7s --start-period=60s --retries=3 \
  CMD curl --fail http://localhost:3000/ || exit 1

# Switch from root to non-root user.
USER www-data

CMD npm run start
