FROM debian:buster-slim

EXPOSE 7878

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN mkdir /etc/flexo

ENV FLEXO_CACHE_DIRECTORY="/tmp/var/cache/flexo/pkg" \
    FLEXO_MIRRORLIST_FALLBACK_FILE="/tmp/var/cache/flexo/state/mirrorlist" \
    FLEXO_MIRRORLIST_LATENCY_TEST_RESULTS_FILE="/tmp/var/cache/flexo/state/latency_test_results.json" \
    FLEXO_PORT=7878 \
    FLEXO_LISTEN_IP_ADDRESS="0.0.0.0" \
    FLEXO_CONNECT_TIMEOUT=3000 \
    FLEXO_MIRROR_SELECTION_METHOD="predefined" \
    FLEXO_MIRRORS_PREDEFINED="['http://mirror-medium-bandwidth-mock']" \
    FLEXO_MIRRORS_BLACKLIST=[]

ENV RUST_BACKTRACE="full" \
    RUST_LOG="debug"

COPY --from=flexo-base-integration-test /tmp/build_output/flexo /usr/bin/flexo

COPY start_flexo.sh /usr/bin

ENTRYPOINT /usr/bin/start_flexo.sh
