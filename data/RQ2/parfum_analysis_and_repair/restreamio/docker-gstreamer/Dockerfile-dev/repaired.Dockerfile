FROM restreamio/gstreamer:latest-dev-with-source

# Only development dependencies
FROM restreamio/gstreamer:dev-dependencies

# And binaries built with debug symbols
COPY --from=0 /compiled-binaries /