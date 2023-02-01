FROM node:8.6.0-alpine

# Set a working directory
WORKDIR /usr/src/app

# If you have native dependencies, you'll need extra tools
RUN apk add --no-cache make g++ python2 libsodium-dev && \
  npm install -g node-gyp && \
  mkdir -p /home/node/.cache/yarn && \
  chown -R node:node /home/node/.cache/yarn && \
  chmod 777 /home/node/.cache/yarn

VOLUME /home/node/.cache/yarn

# Run the container under "node" user by default
USER node
