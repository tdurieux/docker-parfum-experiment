#===================================================
# build lrose in redhat fedora container

ARG LROSE_PKG=lrose-core
ARG RELEASE_DATE=latest

RUN \
    echo "Building lrose in redhat fedora container"; \
    echo "  package is: ${LROSE_PKG}" 

# run the checkout and build script

RUN \
    cd; cd git/lrose-bootstrap; git pull; \
    ./scripts/checkout_and_build_cmake.py \
    --package ${LROSE_PKG} \
    --releaseDate ${RELEASE_DATE} \
    --prefix /usr/local/lrose \
    --buildDir /tmp/lrose-build \
    --logDir /tmp/build-logs \
    --fractl --vortrac --samurai

# clean up