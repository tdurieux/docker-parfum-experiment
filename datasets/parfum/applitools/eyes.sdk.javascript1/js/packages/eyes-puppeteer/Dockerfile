# adapted from https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker
FROM node:12-slim

# install chrome & friends
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable libxss1 curl apt-transport-https \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && apt install -y yarn --no-install-recommends

# prepare working dir
RUN mkdir /sandbox
WORKDIR /sandbox

# expose volume to mount read-only copy of the package's source code
VOLUME /sandbox

# copy manifest for installing deps as part of build
COPY package*.json .

# install project deps
RUN yarn

# install xvfb (leaving commented out since we don't need headed browser execution in the container - yet)
# RUN apt-get install -y xvfb xauth
#
# NOTE:
# - to run, use the following when calling docker run:
#   xvfb-run --server-args='-screen 0 1024x768x24' your-command-goes-here
#   e.g., xvfb-run --server-args='-screen 0 1024x768x24' echo 'blah'
