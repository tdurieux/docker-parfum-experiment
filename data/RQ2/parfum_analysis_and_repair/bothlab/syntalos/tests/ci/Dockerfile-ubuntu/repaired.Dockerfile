#
# Docker file for Syntalos CI on Debian
#
FROM ubuntu:focal

# prepare
RUN apt-get update -qq
RUN apt-get install -yq --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:ximion/syntalos
RUN apt-get update -qq
RUN mkdir -p /build/ci/

# install build dependencies
COPY install-deps-deb.sh /build/ci/
RUN chmod +x /build/ci/install-deps-deb.sh && /build/ci/install-deps-deb.sh

# build & install 3rd-party libraries
COPY make-install-3rdparty.sh /build/ci/
RUN chmod +x /build/ci/make-install-3rdparty.sh && /build/ci/make-install-3rdparty.sh
RUN rm -rf /build/ci/

# finish
WORKDIR /build
