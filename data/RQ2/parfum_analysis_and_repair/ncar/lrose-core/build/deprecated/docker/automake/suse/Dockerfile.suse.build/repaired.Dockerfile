#===================================================
# build lrose in suse container

ARG LROSE_PKG=core
ARG RELEASE_DATE=latest

RUN \
    echo "Building lrose in suse container"; \
    echo "  package is: ${LROSE_PKG}" 

# run the checkout and build script