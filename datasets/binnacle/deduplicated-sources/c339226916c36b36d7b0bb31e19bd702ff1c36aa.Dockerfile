ARG VERSION_ID
FROM centos:${VERSION_ID}

# packaging dependencies
RUN yum install -y \
        rpm-build && \
    rm -rf /var/cache/yum/*

# packaging
ARG PKG_VERS
ARG PKG_REV
ARG RUNTIME_VERSION
ARG DOCKER_VERSION

ENV VERSION $PKG_VERS
ENV RELEASE $PKG_REV
ENV RUNTIME_VERSION $RUNTIME_VERSION
ENV DOCKER_VERSION $DOCKER_VERSION

# output directory
ENV DIST_DIR=/tmp/nvidia-container-runtime-$PKG_VERS/SOURCES
RUN mkdir -p $DIST_DIR /dist

COPY nvidia-docker $DIST_DIR
COPY daemon.json $DIST_DIR

WORKDIR $DIST_DIR/..
COPY rpm .

CMD rpmbuild --clean -bb \
             -D "_topdir $PWD" \
             -D "version $VERSION" \
             -D "release $RELEASE" \
             -D "runtime_version $RUNTIME_VERSION" \
             -D "docker_version $DOCKER_VERSION" \
             SPECS/nvidia-docker2.spec && \
    mv RPMS/noarch/*.rpm /dist
