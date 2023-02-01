FROM node:lts-alpine@sha256:2ae9624a39ce437e7f58931a5747fdc60224c6e40f8980db90728de58e22af7c

# npm wants to clone random Git repositories - lovely.
RUN apk add --no-cache git python make build-base

# Run as user, otherwise, npx explodes.
USER 1000
RUN mkdir -p /home/node/app
RUN mkdir -p /home/node/.npm
WORKDIR /home/node/app

# Fix git ssh error
RUN git config --global url."https://".insteadOf ssh://

# Support additional root CAs
COPY README.md cert.pem* /certs/
# Node
ENV NODE_EXTRA_CA_CERTS=/certs/cert.pem
ENV NODE_OPTIONS=--use-openssl-ca
# npm
RUN if [ -e /certs/cert.pem ]; then npm config set cafile /certs/cert.pem; fi
# git
RUN if [ -e /certs/cert.pem ]; then git config --global http.sslCAInfo /certs/cert.pem; fi

# Only invalidate the npm install step if package.json changed
COPY --chown=node:node package.json .
COPY --chown=node:node package-lock.json .
COPY --chown=node:node .env.test .env

# We want to cache node_modules *and* incorporate it into the final image.
RUN --mount=type=cache,uid=1000,gid=1000,target=/home/node/.npm \
  --mount=type=cache,uid=1000,gid=1000,target=node_modules \
  npm ci && \
  cp -r node_modules node_modules_cache

# Amusingly, Debian's coreutils version has a bug where mv believes that
# the target is on a different fs and does a full recursive copy for what
# could be a renameat syscall. Alpine does not have this bug.
RUN rm -rf node_modules && mv node_modules_cache node_modules

COPY --chown=node:node . .
