# Prepare a testbed for Javascript testing
# This image should be tagged as "isso-js-testbed"

# Note: Do not use alpine images as they do not contain needed GObject, X11
# etc. packages and complicate things
# :current resolves to NodeJS 17 on Debian Buster as of 03/2022
# https://hub.docker.com/_/node
FROM docker.io/node:current AS isso-js-testbed
WORKDIR /src/

# Install everything necessary to run headless
RUN apt-get update && apt-get install -y --no-install-recommends libnss3 libxss1 chromium && rm -rf /var/lib/apt/lists/*;

# Installing puppeteer will take some time as it pulls in
# a ~400Mb headless chrome file
RUN npm install puppeteer && npm cache clean --force;

# Skip downloading headless chromium again for future steps
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

RUN npm install --no-save jest jest-puppeteer jest-environment-jsdom && npm cache clean --force;

# Need to set $CI so that jest-puppeteer applies sensible launch params for
# running headless chromium. Otherwise, chromium will fail with a "missing
# sandbox" error.
# https://github.com/smooth-code/jest-puppeteer/blob/678ce56b49100f248237757df19f89b2542a9465/packages/jest-environment-puppeteer/src/readConfig.js#L14-L28
ENV CI=true

# Note: No entry point, will be set by docker-compose

# Example of use:
#
# docker build -f docker/Dockerfile-js-testbed -t isso-js-testbed .

# vim: set filetype=dockerfile
