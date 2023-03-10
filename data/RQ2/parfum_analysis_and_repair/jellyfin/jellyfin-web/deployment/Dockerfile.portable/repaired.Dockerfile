FROM debian:10

# Docker build arguments
ARG SOURCE_DIR=/jellyfin
ARG ARTIFACT_DIR=/dist

# Docker run environment
ENV SOURCE_DIR=/jellyfin
ENV ARTIFACT_DIR=/dist
ENV IS_DOCKER=YES

# Prepare Debian build environment
RUN apt-get update \
  && apt-get install --no-install-recommends -y mmv curl git \
  && curl -fsSL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Link to build script
RUN ln -sf ${SOURCE_DIR}/deployment/build.portable /build.sh

VOLUME ${SOURCE_DIR}

VOLUME ${ARTIFACT_DIR}

ENTRYPOINT ["/build.sh"]
