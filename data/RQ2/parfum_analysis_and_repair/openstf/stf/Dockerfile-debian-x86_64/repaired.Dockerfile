#
# Copyright © 2020 code initially contributed by Orange SA, authors: Denis Barbaron - Licensed under the Apache license 2.0
#

FROM debian:stretch-slim

LABEL Maintainer="Denis Barbaron <denis.barbaron@orange.com>"
LABEL Name="STF"
LABEL Url="https://github.com/openstf/stf/"
LABEL Description="STF docker image for x86_64 architecture"

# Sneak the stf executable into $PATH.
ENV PATH /app/bin:$PATH

# Work in app dir by default.
WORKDIR /app

# Copy app source.
COPY . /tmp/build/

# Install app requirements
RUN export DEBIAN_FRONTEND=noninteractive && \
    echo '--- Updating repositories' && \
    apt-get update && \
    echo '--- Building node' && \
    apt-get -y --no-install-recommends install wget python build-essential && \
    cd /tmp && \
    wget --progress=dot:mega \
      https://nodejs.org/dist/v8.9.3/node-v8.9.3-linux-x64.tar.xz && \
    tar -xJf node-v*.tar.xz --strip-components 1 -C /usr/local && \
    rm node-v*.tar.xz && \
    useradd --system \
      --create-home \
      --shell /usr/sbin/nologin \
      stf && \
    su stf -s /bin/bash -c '/usr/local/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js install' && \
    apt-get -y install --no-install-recommends libzmq3-dev libprotobuf-dev git graphicsmagick yasm && \
    echo '--- Building app' && \
    mkdir -p /app && \
    chown -R stf:stf /tmp/build && \
    set -x && \
    cd /tmp/build && \
    export PATH=$PWD/node_modules/.bin:$PATH && \
    sed -i'' -e '/phantomjs/d' package.json && \
    npm install -g npm && \
    echo 'npm install --no-optional --loglevel http' | su stf -s /bin/bash && \
    echo '--- Assembling app' && \
    echo 'npm pack' | su stf -s /bin/bash && \
    tar xzf stf-*.tgz --strip-components 1 -C /app && \
    echo '/tmp/build/node_modules/.bin/bower cache clean' | su stf -s /bin/bash && \
    echo 'npm prune --production' | su stf -s /bin/bash && \
    mv node_modules /app && \
    chown -R root:root /app && \
    echo '--- Cleaning up' && \
    echo 'npm cache clean --force' | su stf -s /bin/bash && \
    rm -rf ~/.node-gyp && \
    apt-get -y purge wget python build-essential && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
    cd /app && \
    rm -rf /tmp/* && npm cache clean --force; && rm stf-*.tgz

# Switch to the app user.
USER stf

# Show help by default.
CMD stf --help
