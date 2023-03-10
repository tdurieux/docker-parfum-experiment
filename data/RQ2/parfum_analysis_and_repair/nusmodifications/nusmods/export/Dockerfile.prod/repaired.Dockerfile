FROM node:12-alpine

# Installs Chromium package.
RUN apk update && apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Add user so we don't need --no-sandbox.
RUN mkdir -p /home/node/Downloads \
    && mkdir -p /home/node/app/export \
    && chown -R node:node /home/node

WORKDIR /home/node/app/export

COPY ./export/package.json ./export/yarn.lock ./export/tsconfig.json ./

RUN ls -la1; yarn --no-cache --frozen-lockfile && yarn cache clean;

COPY --chown=node:node ./export/src ./src

RUN yarn build && yarn cache clean;

# Run everything after as non-privileged user.
USER node

CMD node ./build/index.js
