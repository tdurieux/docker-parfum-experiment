FROM jetbrains/teamcity-minimal-agent:latest

# This is important for using apt-get
USER root

# Default build configuration
ENV AS_BUILDAGENT=0 \
    BUILD_ARCHITECTURE=arm \
    BUILD_CONFIG=release \
    GCC_PREFIX=arm-linux-gnueabihf- \
    AR=arm-linux-gnueabihf-ar \
    CC=arm-linux-gnueabihf-gcc-10 \
    CXX=arm-linux-gnueabihf-g++-10

# Add apt-get support for arm64 and armhf
COPY utils/arm-cross-compile-sources.list /etc/apt/sources.list.d/

# Install build-time dependencies
RUN sed -i 's/deb http/deb \[arch=amd64,i386\] http/' /etc/apt/sources.list && \
    dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install --no-install-recommends -y make git ncftp \
        gcc-10-arm-linux-gnueabihf g++-10-arm-linux-gnueabihf \
        libncursesw5:armhf libncursesw5-dev:armhf libmysqlclient-dev:armhf && rm -rf /var/lib/apt/lists/*;

# Set build directory
VOLUME /build
WORKDIR /build

# Copy entrypoint script
COPY utils/docker-entrypoint-arm.sh /docker-entrypoint.sh

# Set entrypoint
ENTRYPOINT bash /docker-entrypoint.sh
