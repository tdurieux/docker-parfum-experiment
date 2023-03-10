ARG BASEIMAGE
FROM ${BASEIMAGE}

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
        git \
        build-essential \
        dh-make \
        fakeroot \
        devscripts \
        lsb-release && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    rm -rf /var/lib/apt/lists/*

# packaging
ARG PKG_NAME
ARG PKG_VERS
ARG PKG_REV
ARG TOOLKIT_VERSION

ENV DEBFULLNAME "NVIDIA CORPORATION"
ENV DEBEMAIL "cudatools@nvidia.com"
ENV PKG_NAME "${PKG_NAME}"
ENV REVISION "$PKG_VERS-$PKG_REV"
ENV TOOLKIT_VERSION $TOOLKIT_VERSION
ENV SECTION ""

# output directory
ENV DIST_DIR=/tmp/${PKG_NAME}-$PKG_VERS
RUN mkdir -p $DIST_DIR /dist

WORKDIR $DIST_DIR
COPY debian ./debian

RUN sed -i "s;@TOOLKIT_VERSION@;${TOOLKIT_VERSION};" debian/control && \
    dch --create --package="${PKG_NAME}" \
        --newversion "${REVISION}" \
            "Bump nvidia-container-toolkit dependency to ${TOOLKIT_VERSION}" && \
    dch -r "" && \
    if [ "$REVISION" != "$(dpkg-parsechangelog --show-field=Version)" ]; then exit 1; fi

CMD export DISTRIB="$(lsb_release -cs)" && \
    debuild -eREVISION -eDISTRIB -eSECTION --dpkg-buildpackage-hook='sh debian/prepare' -i -us -uc -b && \
    mv /tmp/*.deb /dist
