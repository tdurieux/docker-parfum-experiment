FROM alpine:3.3

# install tools needed by packaging scripts
RUN apk update \
    && apk add --no-cache bash curl jq tar zip \
    && rm -rf /var/cache/apk/*

# place scripts on path and declare output volume
ENV PATH /scripts:$PATH
COPY scripts /scripts
VOLUME /packages

ENTRYPOINT ["/scripts/fetch_and_build_pgxn"]
