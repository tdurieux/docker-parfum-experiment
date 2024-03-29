# ------------------------------------------------
# Builder image
# ------------------------------------------------

FROM ghcr.io/thumbsup/build:node-12 as build

# Install thumbsup locally
WORKDIR /thumbsup
ARG PACKAGE_VERSION
RUN if [ -z "${PACKAGE_VERSION}" ]; then \
      echo "Please specify --build-arg PACKAGE_VERSION=<2.4.1>"; \
      exit 1; \
    fi;
RUN echo '{"name": "installer", "version": "1.0.0"}' > package.json
RUN npm install thumbsup@${PACKAGE_VERSION} && npm cache clean --force;

# ------------------------------------------------
# Runtime image
# ------------------------------------------------

FROM ghcr.io/thumbsup/runtime:node-12

# Use tini as an init process
# to ensure all child processes (ffmpeg...) are always terminated properly
RUN apk add --no-cache --update tini
ENTRYPOINT ["tini", "-g", "--"]

# Thumbsup can be run as any user and needs write-access to HOME
ENV HOME /tmp

# Copy the thumbsup files to the new image
COPY --from=build /thumbsup /thumbsup
RUN ln -s /thumbsup/node_modules/.bin/thumbsup /usr/local/bin/thumbsup

# Default command, should be overridden during <docker run>
CMD ["thumbsup"]
