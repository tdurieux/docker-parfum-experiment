ARG GRAAL_VERSION
ARG JDK_VERSION
FROM findepi/graalvm:${GRAAL_VERSION}-${JDK_VERSION}
LABEL maintainer="Piotr Findeisen <piotr.findeisen@gmail.com>"

RUN set -xeu && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        gcc \
        g++ \
        libz-dev \
        && \
    gu install native-image && \
    # Cleanup
    apt-get clean && rm -rf "/var/lib/apt/lists/*" && \
    echo OK && rm -rf /var/lib/apt/lists/*;

# vim:set ft=dockerfile:
