#
# Image which contains the binary artefacts
#
ARG IMAGE=leoleovich/grafsy
FROM $IMAGE:builder AS build
COPY . ./grafsy

WORKDIR ./grafsy

RUN make clean test && \
    make build && \
    make packages

# This one will return tar stream of binary artefacts to unpack on the local file system
CMD ["/usr/bin/env", "tar", "-c", "--exclude=build/pkg", "build"]


#
# Application image
#
FROM debian:stable-slim

RUN apt-get update && apt-get install --no-install-recommends libacl1 -y && apt-get clean && mkdir /etc/grafsy && rm -rf /var/lib/apt/lists/*;

WORKDIR /grafsy

COPY --from=build /go/grafsy/build/grafsy_linux_x64 ./grafsy

COPY --from=build /go/grafsy/build/grafsy-client_linux_x64 ./grafsy-client

COPY docker/grafsy/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/grafsy/grafsy"]
