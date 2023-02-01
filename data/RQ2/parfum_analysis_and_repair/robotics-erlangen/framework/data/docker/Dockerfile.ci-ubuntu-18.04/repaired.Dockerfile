FROM ci:ubuntu-18.04-no-v8

ENV CCACHE_DIR="/ccache/ubuntu-18.04"
ENV V8_INCLUDE_DIR=/libs/v8/include
ENV V8_OUTPUT_DIR=/libs/v8/out/x64.release
COPY --from=roboticserlangen/v8:version-1-ubuntu-18.04 /v8/v8 /libs/v8