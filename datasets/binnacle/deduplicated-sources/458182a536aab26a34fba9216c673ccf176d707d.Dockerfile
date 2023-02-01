ARG IMAGE_VERSION=latest
FROM ubuntu:$IMAGE_VERSION
LABEL maintainer="DECENT"

# prerequisites
RUN . /etc/os-release && apt-get update && \
    if [ "$VERSION_ID" != "16.04" ]; then apt-get install -y --no-install-recommends \
        libreadline7 \
        libcrypto++6 \
        libssl1.1 \
        libcurl4 \
        less \
        wget \
        ca-certificates; \
    else apt-get install -y --no-install-recommends \
        libreadline6 \
        libcrypto++9v5 \
        libssl1.0.0 \
        libcurl3 \
        less \
        wget \
        ca-certificates; \
    fi && apt-get clean && apt-get autoremove

# PBC
ARG PBC_VERSION=0.5.14
RUN . /etc/os-release && \
    wget -nv -P /tmp https://github.com/DECENTfoundation/pbc/releases/download/$PBC_VERSION/libpbc_$PBC_VERSION-${ID}${VERSION_ID}_amd64.deb && \
    dpkg -i /tmp/libpbc_$PBC_VERSION-${ID}${VERSION_ID}_amd64.deb && \
    rm /tmp/libpbc_$PBC_VERSION-${ID}${VERSION_ID}_amd64.deb

# prepare directories
ENV DCORE_HOME=/root
ENV DCORE_USER=root
USER $DCORE_USER
WORKDIR $DCORE_HOME

# DCore
ARG DCORE_VERSION
COPY dcore_${DCORE_VERSION}-ubuntu*_amd64.deb /tmp/
RUN . /etc/os-release && \
    dpkg -i /tmp/dcore_$DCORE_VERSION-${ID}${VERSION_ID}_amd64.deb && \
    rm /tmp/dcore_${DCORE_VERSION}-ubuntu*_amd64.deb && \
    mkdir $DCORE_HOME/.decent

EXPOSE 40000 8090

ENV DCORE_EXTRA_ARGS=""
ENV DCORE_DATA_DIR=$DCORE_HOME"/.decent/data"
CMD decentd -d $DCORE_DATA_DIR --rpc-endpoint 0.0.0.0:8090 $DCORE_EXTRA_ARGS
