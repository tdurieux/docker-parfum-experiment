ARG IMG=debian
ARG TAG=buster
FROM $IMG:$TAG

# Docker build arguments
ARG SOURCE_DIR=/jellyfin
ARG ARTIFACT_DIR=/dist

# Docker run environment
ENV SOURCE_DIR=/jellyfin
ENV ARTIFACT_DIR=/dist
ENV DEB_BUILD_OPTIONS=noddebs
ENV IS_DOCKER=YES

# Prepare Debian build environment
RUN apt-get update \
  && DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" \
     apt-get --no-install-recommends \
     install -y debhelper mmv git curl devscripts equivs && rm -rf /var/lib/apt/lists/*;


# Link to build script
RUN ln -sf ${SOURCE_DIR}/deployment/build.debian /build.sh

VOLUME ${SOURCE_DIR}

VOLUME ${ARTIFACT_DIR}

ENTRYPOINT ["/build.sh"]
