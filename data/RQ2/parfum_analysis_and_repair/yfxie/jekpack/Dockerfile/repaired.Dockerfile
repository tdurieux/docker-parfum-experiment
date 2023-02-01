FROM scardon/ruby-node-alpine:2.6.1
RUN apk update && apk upgrade
RUN apk add --no-cache alpine-sdk
RUN apk add --no-cache chromium

WORKDIR '/jekpack'
ENV CHROME_BIN="/usr/bin/chromium-browser" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true"

COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn link && yarn cache clean;
RUN jekpack bundle