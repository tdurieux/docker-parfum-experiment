FROM alpine:3.15.0

RUN apk update --no-cache && apk upgrade --no-cache && \
    apk add --no-cache ca-certificates bind-tools tini git jansson curl && \
    apk add --upgrade --no-cache 'libcrypto1.1>=1.1.1n-r0' 'libssl1.1>=1.1.1n-r0' 'pcre2>=10.40-r0'

# Run as non-root user sourcegraph. External volumes should be mounted under /data (which will be owned by sourcegraph).
RUN mkdir -p /home/sourcegraph
RUN addgroup -S sourcegraph && adduser -S -G sourcegraph -h /home/sourcegraph sourcegraph && mkdir -p /data && chown -R sourcegraph:sourcegraph /data
USER sourcegraph
WORKDIR /home/sourcegraph

ENV SRC_FRONTEND_INTERNAL http://sourcegraph-frontend-internal
ENV DATA_DIR /data/index
RUN mkdir -p ${DATA_DIR}

COPY --from=zoekt \
    /usr/local/bin/universal-* \
    /usr/local/bin/zoekt-sourcegraph-indexserver \
    /usr/local/bin/zoekt-archive-index \
    /usr/local/bin/zoekt-git-index \
    /usr/local/bin/zoekt-merge-index \
    /usr/local/bin/

# zoekt indexing has a large stable heap size (gigs), and as such the default
# GOGC=100 could be better tuned. https://dave.cheney.net/tag/gogc
# In go1.18 the GC changed significantly and from experimentation we tuned it
# down from 50 to 25.
ENV GOGC=25

ENTRYPOINT ["/sbin/tini", "--", "zoekt-sourcegraph-indexserver"]