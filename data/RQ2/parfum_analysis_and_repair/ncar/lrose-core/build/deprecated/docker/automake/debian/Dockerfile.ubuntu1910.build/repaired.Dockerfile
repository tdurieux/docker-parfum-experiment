#===================================================
# build lrose in debian container

ARG LROSE_PKG=core
ARG RELEASE_DATE=latest

RUN \
    echo "Building lrose in debian container"; \
    echo "  package is: ${LROSE_PKG}" 

# run the checkout and build script

RUN \
    /scripts/checkout_and_build_auto.py \
    --package lrose-${LROSE_PKG} \
    --releaseDate ${RELEASE_DATE} \
    --prefix /usr/local/lrose \
    --buildDir /tmp/lrose_build \
    --logDir /tmp/build_logs \
    --fractl --samurai

# clean up

#RUN \
#    /bin/rm -rf /tmp/lrose_build