# SPDX-License-Identifier: GPL-3.0-or-later

FROM debian:bullseye
MAINTAINER Knot Resolver <knot-resolver@labs.nic.cz>
# >= 3.0 needed because of --enable-xdp=yes
ARG KNOT_BRANCH=3.1
ARG COVERITY_SCAN_PROJECT_NAME=CZ-NIC/knot-resolver
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root
CMD ["/bin/bash"]

# generic cleanup
RUN apt-get update -qq

# Knot and Knot Resolver dependencies
RUN apt-get install --no-install-recommends -y -qqq git make cmake pkg-config meson \
	build-essential bsdmainutils libtool autoconf libcmocka-dev \
	liburcu-dev libgnutls28-dev libedit-dev liblmdb-dev libcap-ng-dev libsystemd-dev \
	libelf-dev libmnl-dev libidn11-dev libuv1-dev \
	libluajit-5.1-dev lua-http libssl-dev libnghttp2-dev && rm -rf /var/lib/apt/lists/*;

# LuaJIT binary for stand-alone scripting
RUN apt-get install --no-install-recommends -y -qqq luajit && rm -rf /var/lib/apt/lists/*;

# build and install latest version of Knot DNS
RUN git clone --depth=1 --branch=$KNOT_BRANCH https://gitlab.nic.cz/knot/knot-dns.git /tmp/knot
WORKDIR /tmp/knot
RUN pwd
RUN autoreconf -if
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --enable-xdp=yes
RUN CFLAGS="-g" make
RUN make install
RUN ldconfig

# curl and tar (for downloading Coverity tools and uploading logs)
RUN apt-get install --no-install-recommends -y curl tar && rm -rf /var/lib/apt/lists/*;

RUN --mount=type=secret,id=coverity-token \
	curl -f -o /tmp/cov-analysis-linux64.tar.gz https://scan.coverity.com/download/cxx/linux64 \
	--form project=$COVERITY_SCAN_PROJECT_NAME --form
RUN tar xfz /tmp/cov-analysis-linux64.tar.gz && rm /tmp/cov-analysis-linux64.tar.gz
RUN mv cov-analysis-linux64-* /opt/cov-analysis
