FROM alpine:3.11
RUN apk add --no-cache --update \
    openjdk11 \
    && rm -rf /var/cache/apk
LABEL maintainer="sig-platform@spinnaker.io"
# The save_cache step will fail if these directories don't exist. We don't have
# any compilation to do, so just do this instead of running gradle to save time.
CMD mkdir -p .gradle/caches && mkdir -p .gradle/wrapper
