# Copyright 2022 Telefonica Investigacion y Desarrollo, S.A.U
#
# This file is part of Orion Context Broker.
#
# Orion Context Broker is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Orion Context Broker is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
# General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Orion Context Broker. If not, see http://www.gnu.org/licenses/.
#
# For those usages not covered by this license please contact with
# iot_support at tid dot es
#

ARG  IMAGE_TAG=3.15.0
FROM alpine:${IMAGE_TAG}

ARG GITHUB_ACCOUNT=telefonicaid
ARG GITHUB_REPOSITORY=fiware-orion

ARG GIT_NAME
ARG GIT_REV_ORION
ARG CLEAN_DEV_TOOLS

ENV ORION_USER ${ORION_USER:-orion}
ENV GIT_NAME ${GIT_NAME:-telefonicaid}
ENV GIT_REV_ORION ${GIT_REV_ORION:-master}
ENV CLEAN_DEV_TOOLS ${CLEAN_DEV_TOOLS:-1}

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

WORKDIR /opt

RUN \

    apk add --no-cache \
      curl \
      cmake \
      make \
      gcc \
      musl-dev \
      openssl-dev \
      git \
      g++ \
      curl-dev \
      boost-dev \
      util-linux-dev \
      gnutls-dev \
      libgcrypt-dev \
      cyrus-sasl-dev && \
    # Install libmicrohttpd from source
    echo =====================MARK1 && \
    cd /opt && \
    curl -f -kOL https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.70.tar.gz && \
    tar xvf libmicrohttpd-0.9.70.tar.gz && \
    cd libmicrohttpd-0.9.70 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-messages --disable-postprocessor --disable-dauth && \
    make && \
    echo =====================MARK2 && \
    make install && \
    # FIXME: enabling ldconfig breaks docker build
    #ldconfig && \
    echo =====================MARK3 && \
    # Install mosquitto from source
    cd /opt && \
    curl -f -kOL https://mosquitto.org/files/source/mosquitto-2.0.12.tar.gz && \
    tar xvf mosquitto-2.0.12.tar.gz && \
    cd mosquitto-2.0.12 && \
    sed -i 's/WITH_CJSON:=yes/WITH_CJSON:=no/g' config.mk && \
    sed -i 's/WITH_STATIC_LIBRARIES:=no/WITH_STATIC_LIBRARIES:=yes/g' config.mk && \
    sed -i 's/WITH_SHARED_LIBRARIES:=yes/WITH_SHARED_LIBRARIES:=no/g' config.mk && \
    make && \
    make install && \
    # FIXME: enabling ldconfig breaks docker build
    #ldconfig && \
    # Install mongodb driver from source
    cd /opt && \
    curl -f -kOL https://github.com/mongodb/mongo-c-driver/releases/download/1.17.4/mongo-c-driver-1.17.4.tar.gz && \
    tar xfvz mongo-c-driver-1.17.4.tar.gz && \
    cd mongo-c-driver-1.17.4 && \
    mkdir cmake-build && \
    cd cmake-build && \
    cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF .. && \
    make && \
    make install && \
    # Install rapidjson from source
    cd /opt && \
    curl -f -kOL https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz && \
    tar xfz v1.1.0.tar.gz && \
    mv rapidjson-1.1.0/include/rapidjson/ /usr/local/include && \
    # Install orion from source
    # FIXME: this is not working, have to be reviewed
    #adduser ${ORION_USER} && \
    cd /opt && \
    git clone https://github.com/${GIT_NAME}/fiware-orion && \
    cd fiware-orion && \
    git checkout ${GIT_REV_ORION} && \
    # patch bash and mktemp statement in build script, as in alpine is slightly different
    sed -i 's/mktemp \/tmp\/compileInfo.h.XXXX/mktemp/g' scripts/build/compileInfo.sh && \
    sed -i 's/bash/ash/g' scripts/build/compileInfo.sh && \
    make && \
    make install && \
    # reduce size of installed binaries
    strip /usr/bin/contextBroker && \
    # create needed run path
    mkdir -p /var/run/contextBroker && \
    #chown ${ORION_USER} /var/run/contextBroker && \
    cd /opt && \
    if [ ${CLEAN_DEV_TOOLS} -eq 0 ] ; then exit 0 ; fi && \
    # cleanup sources, dev tools and locales to reduce the final image size
    # FIXME: this could need more tunning. Have a look to old CentOS Docerkile and try to
    # reproduce the same steps
    rm -rf /opt/libmicrohttpd-0.9.70.tar.gz \
           /usr/local/include/microhttpd.h \
           /usr/local/lib/libmicrohttpd.* \
           /opt/libmicrohttpd-0.9.70 \
           /opt/mosquitto-2.0.12.tar.gz \
           /opt/mosquitto-2.0.12 \
           /opt/mongo-c-driver-1.17.4.tar.gz \
           /opt/mongo-c-driver-1.17.4 \
           /usr/local/include/mongo \
           /usr/local/lib/libmongoclient.a \
           /opt/rapidjson-1.1.0 \
           /opt/v1.1.0.tar.gz \
           /usr/local/include/rapidjson \
           /opt/fiware-orion && \
    # remove the same packages we installed at the beginning to build Orion
    apk del \
      curl \
      cmake \
      make \
      gcc \
      musl-dev \
      openssl-dev \
      git \
      g++ \
      curl-dev \
      boost-dev \
      util-linux-dev \
      gnutls-dev \
      libgcrypt-dev \
      cyrus-sasl-dev && \
    # The above apk removal erases some dependencies needed by contextBroker. So we reinstall it
    apk add --no-cache \
      boost1.77-thread \
      libcurl \
      libuuid \
      gnutls \
      libsasl \ 
      icu-libs \
      libstdc++ && \
    # Don't need old log files inside docker images
    rm -f /var/log/*log

WORKDIR /

# Note we disable log file as docker container will output by stdout
ENTRYPOINT ["/usr/bin/contextBroker","-fg", "-multiservice", "-ngsiv1Autocast", "-disableFileLog" ]
EXPOSE 1026

LABEL "maintainer"="Orion Team. Telef??nica I+D"
LABEL "org.opencontainers.image.authors"="iot_support@tid.es"
LABEL "org.opencontainers.image.documentation"="https://fiware-orion.rtfd.io/"
LABEL "org.opencontainers.image.vendor"="Telef??nica Investigaci??n y Desarrollo, S.A.U"
LABEL "org.opencontainers.image.licenses"="AGPL-3.0-only"
LABEL "org.opencontainers.image.title"="Orion Context Broker"
LABEL "org.opencontainers.image.description"="The Orion Context Broker is an implementation of the Publish/Subscribe Context Broker GE, providing an NGSI interface"
LABEL "org.opencontainers.image.source"=https://github.com/${GITHUB_ACCOUNT}/${GITHUB_REPOSITORY}

# Create an anonymous user
RUN sed -i -r "/^(root|nobody)/!d" /etc/passwd /etc/shadow /etc/group \
    && sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd
USER nobody
