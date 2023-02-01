FROM ubuntu:18.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV ASB_VER 3.4.5
ENV HOME /root
WORKDIR $HOME

# Install curl
RUN apt-get update && apt-get install --no-install-recommends -y curl unzip && rm -rf /var/lib/apt/lists/*;

# Download/extract XPI
#RUN curl -L https://github.com/eric-bixby/auto-sort-bookmarks-webext/releases/download/v${ASB_VER}/auto-sort_bookmarks-${ASB_VER}.xpi \
#         --output auto-sort_bookmarks-${ASB_VER}.xpi \
#    && unzip auto-sort_bookmarks-${ASB_VER}.xpi -d auto-sort_bookmarks-${ASB_VER}

# Download/extract source code
RUN curl -f -L https://github.com/eric-bixby/auto-sort-bookmarks-webext/archive/refs/tags/v${ASB_VER}.zip \
         --output v${ASB_VER}.zip \
    && unzip v${ASB_VER}.zip

# Install node and npm
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install dependencies (allow root, otherwise, get premission error)
RUN npm i -g --unsafe-perm=true --alow-root \
        web-ext \
        gulp@4.0.2 \
        weh@2.10.0 && npm cache clean --force;
#        js-beautify

# Apply npm-shrinkwrap to weh
RUN cd `npm root -g`/weh \
    && cp ${HOME}/auto-sort-bookmarks-webext-${ASB_VER}/weh-npm-shrinkwrap.json ./npm-shrinkwrap.json \
    && npm i && npm cache clean --force;

# Build XPI
RUN cd ${HOME}/auto-sort-bookmarks-webext-${ASB_VER} \
    && ./build_ff.sh
#    && diff -r build ${HOME}/auto-sort_bookmarks-${ASB_VER}

