# First stage downloads pre-compiled Teleport archive from get.gravitational.com
# and extracts binaries from the archive.
FROM alpine AS download

ARG DOWNLOAD_TYPE=teleport
ARG VERSION_TAG
ARG OS
ARG ARCH
ARG EXTRA_DOWNLOAD_ARGS=""

WORKDIR /tmp
# Install dependencies.
RUN apk --update --no-cache add curl tar

# Download the appropriate binary tarball from get.gravitational.com and extract the binaries into
# a temporary directory for us to use in the second stage.
RUN mkdir -p build && \
    curl -f -Ls https://get.gravitational.com/${DOWNLOAD_TYPE}-${VERSION_TAG}-${OS}-${ARCH}${EXTRA_DOWNLOAD_ARGS}-bin.tar.gz | tar -xzf - && \
    cp $DOWNLOAD_TYPE/teleport $DOWNLOAD_TYPE/tctl $DOWNLOAD_TYPE/tsh build

# Second stage builds final container with teleport binaries.
FROM ubuntu:20.04 AS teleport

# Install ca-certificates, dumb-init and libelf1, then clean up.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ca-certificates dumb-init libelf1 && \
    update-ca-certificates && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# Copy "teleport", "tctl", and "tsh" binaries from the previous stage.
COPY --from=download /tmp/build/teleport /usr/local/bin/teleport
COPY --from=download /tmp/build/tctl /usr/local/bin/tctl
COPY --from=download /tmp/build/tsh /usr/local/bin/tsh

# Run Teleport inside the image with a default config file location.
ENTRYPOINT ["/usr/bin/dumb-init", "teleport", "start", "-c", "/etc/teleport/teleport.yaml"]

# Optional third stage which is only run when building the FIPS image.
FROM teleport AS teleport-fips

# Override the standard entrypoint set in the previous image with the --fips argument to start in FIPS mode.
ENTRYPOINT ["/usr/bin/dumb-init", "teleport", "start", "-c", "/etc/teleport/teleport.yaml", "--fips"]
