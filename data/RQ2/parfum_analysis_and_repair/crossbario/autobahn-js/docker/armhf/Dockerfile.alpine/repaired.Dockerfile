FROM armhf/alpine:edge

COPY .qemu/qemu-arm-static /usr/bin/qemu-arm-static

MAINTAINER The Crossbar.io Project <support@crossbario.com>

# Metadata
ARG AUTOBAHN_JS_VERSION
ARG AUTOBAHN_JS_XBR_VERSION
ARG BUILD_DATE
ARG AUTOBAHN_JS_VCS_REF

# Metadata labeling
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="AutobahnJS Starter Template" \
      org.label-schema.description="Quickstart template for application development with AutobahnJS" \
      org.label-schema.url="http://crossbar.io" \
      org.label-schema.vcs-ref=$AUTOBAHN_JS_VCS_REF \
      org.label-schema.vcs-url="https://github.com/crossbario/autobahn-js" \
      org.label-schema.vendor="The Crossbar.io Project" \
      org.label-schema.version=$AUTOBAHN_JS_VERSION \
      org.label-schema.schema-version="1.0"

# Application home
ENV HOME /app
ENV DEBIAN_FRONTEND noninteractive
ENV NODE_PATH /usr/lib/node_modules

# we need a toolchain for the (optional) binary extensions used by Autobahn
RUN apk add --update git build-base libffi-dev openssl-dev \
    && rm -rf /var/cache/apk/*

# Crossbar.io connection defaults
ENV CBURL ws://crossbar:8080/ws
ENV CBREALM realm1

# make sure HOME exists!
RUN mkdir /app

# set the app component directory as working directory
WORKDIR /app

# install node
RUN apk add --update nodejs nodejs-npm nodejs-dev build-base python \
    && rm -rf /var/cache/apk/*

# see:
# - https://github.com/npm/uid-number/issues/3#issuecomment-287413039
# - https://github.com/tootsuite/mastodon/issues/802
RUN npm config set unsafe-perm true

# install Autobahn|JS
#https://github.com/npm/npm/issues/17431#issuecomment-325892798
RUN npm install -g --unsafe-perm node-gyp && npm cache clean --force;
RUN npm install -g --unsafe-perm autobahn@${AUTOBAHN_JS_VERSION} && npm cache clean --force;
RUN npm install -g --unsafe-perm autobahn-xbr@${AUTOBAHN_JS_XBR_VERSION} && npm cache clean --force;

# add example service
COPY ./app/* /app/

# make /app a volume to allow external configuration
VOLUME /app

# run service entry script by default
CMD ["sh", "/app/run"]
