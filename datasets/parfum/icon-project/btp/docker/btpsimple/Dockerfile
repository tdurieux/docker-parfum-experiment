ARG BASE_IMAGE
FROM ${BASE_IMAGE}
LABEL MAINTAINER="t_arch@iconloop.com"

# install dependencies
#RUN apk add --no-cache jq

ARG VERSION
LABEL BTPSIMPLE_VERSION="$VERSION"

# install
COPY dist/bin/btpsimple /btpsimple/bin/btpsimple
ENV PATH $PATH:/btpsimple/bin

# copy contracts
ADD dist/contracts.tar /btpsimple/
WORKDIR /btpsimple

# container configuration
VOLUME ["/btpsimple/data"]

# goloop entrypoint
ENV BTPSIMPLE_BASE_DIR=/btpsimple/data
ENV BTPSIMPLE_CONFIG=/btpsimple/config/config.json
ENV BTPSIMPLE_KEY_STORE=/btpsimple/config/keystore.json
ENV BTPSIMPLE_KEY_SECRET=/btpsimple/config/keysecret
ENV BTPSIMPLE_LOG_WRITER_FILENAME=/btpsimple/data/btpsimple.log

# entrypoint
RUN { \
        echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo 'if [ "$BTPSIMPLE_CONFIG" != "" ] && [ ! -f "$BTPSIMPLE_CONFIG" ]; then'; \
        echo '  UNSET="BTPSIMPLE_CONFIG"' ; \
        echo '  CMD="btpsimple save $BTPSIMPLE_CONFIG"'; \
        echo '  if [ "$BTPSIMPLE_KEY_SECRET" != "" ] && [ ! -f "$BTPSIMPLE_KEY_SECRET" ]; then'; \
        echo '    mkdir -p $(dirname $BTPSIMPLE_KEY_SECRET)'; \
        echo '    echo -n $(date|md5sum|head -c16) > $BTPSIMPLE_KEY_SECRET' ; \
        echo '  fi'; \
        echo '  if [ "$BTPSIMPLE_KEY_STORE" != "" ] && [ ! -f "$BTPSIMPLE_KEY_STORE" ]; then'; \
        echo '    UNSET="$UNSET BTPSIMPLE_KEY_STORE"' ; \
        echo '    CMD="$CMD --save_key_store=$BTPSIMPLE_KEY_STORE"' ; \
        echo '  fi'; \
        echo '  if [ "$BTPSIMPLE_SRC_ADDRESS_FILE" != "" ] && [ -f "$BTPSIMPLE_SRC_ADDRESS_FILE" ]; then'; \
        echo '    export BTPSIMPLE_SRC_ADDRESS=$(cat ${BTPSIMPLE_SRC_ADDRESS_FILE})' ; \
        echo '  fi'; \
        echo '  if [ "$BTPSIMPLE_SRC_ENDPOINT_FILE" != "" ] && [ -f "$BTPSIMPLE_SRC_ENDPOINT_FILE" ]; then'; \
        echo '    export BTPSIMPLE_SRC_ENDPOINT=$(cat ${BTPSIMPLE_SRC_ENDPOINT_FILE})' ; \
        echo '  fi'; \
        echo '  if [ "$BTPSIMPLE_DST_ADDRESS_FILE" != "" ] && [ -f "$BTPSIMPLE_DST_ADDRESS_FILE" ]; then'; \
        echo '    export BTPSIMPLE_DST_ADDRESS=$(cat ${BTPSIMPLE_DST_ADDRESS_FILE})' ; \
        echo '  fi'; \
        echo '  if [ "$BTPSIMPLE_DST_ENDPOINT_FILE" != "" ] && [ -f "$BTPSIMPLE_DST_ENDPOINT_FILE" ]; then'; \
        echo '    export BTPSIMPLE_DST_ENDPOINT=$(cat ${BTPSIMPLE_DST_ENDPOINT_FILE})' ; \
        echo '  fi'; \
        echo '  if [ "$BTPSIMPLE_OFFSET_FILE" != "" ] && [ -f "$BTPSIMPLE_OFFSET_FILE" ]; then'; \
        echo '    export BTPSIMPLE_OFFSET=$(cat ${BTPSIMPLE_OFFSET_FILE})' ; \
        echo '  fi'; \
        echo '  sh -c "unset $UNSET ; $CMD"' ; \
        echo 'fi'; \
        echo 'exec "$@"'; \
    } > /entrypoint \
    && chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]

CMD btpsimple start
