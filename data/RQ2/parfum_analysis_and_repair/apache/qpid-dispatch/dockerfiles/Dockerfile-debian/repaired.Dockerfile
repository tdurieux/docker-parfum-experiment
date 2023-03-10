#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# build with specifying root of repository as build context, e.g. `buildah -f dockerfiles/Dockerfile-debian .`

FROM debian:bullseye-slim AS build

LABEL org.opencontainers.image.authors="dev@qpid.apache.org"

# UPGRADE: proton > 0.37.0: replace `python3/dist-packages` with `python3.9/site-packages/`
ARG proton_version=0.37.0
# Enable web console: use 'ON' or 'OFF'
ARG enable_console=OFF


ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential cmake pkg-config git ninja-build ca-certificates \
        libssl-dev libsasl2-dev swig python3-dev libwebsockets-dev \
        $(if [ "${enable_console}" = "ON" ]; then echo "npm"; fi) && \
    rm -rf /var/lib/apt/lists/*

# first, build Proton since there is no recent version packaged in Debian
RUN git clone --depth 1 -b ${proton_version} https://github.com/apache/qpid-proton.git

# build and install into system for laster usage by dispatch, but also install discretely so that it's easier to copy
RUN mkdir /qpid-proton/build /qpid-proton/install-prefix && cd /qpid-proton/build && \
	cmake .. -GNinja -DSYSINSTALL_BINDINGS=ON -DCMAKE_INSTALL_PREFIX=/usr -DSYSINSTALL_PYTHON=ON && \
	cmake --build . --target install && \
	cmake --install . --prefix /qpid-proton/install-prefix

# build Dispatch Router
ADD . /qpid-dispatch/
RUN mkdir /qpid-dispatch/build /qpid-dispatch/install-prefix && cd /qpid-dispatch/build && \
	cmake .. -GNinja -DCMAKE_INSTALL_PREFIX=/usr -DUSE_VALGRIND=NO -DCONSOLE_INSTALL=${enable_console} && \
	cmake --build . && \
	cmake --install . --prefix /qpid-dispatch/install-prefix && \
	mkdir -p /usr/share/qpid-dispatch  # make sure directory exists even if web console is disabled

# Uncomment the following line if you would like to run all the dispatch unit tests and system tests
#RUN cd /qpid-dispatch/build && ctest -VV

FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends libsasl2-2 libsasl2-modules libwebsockets16 \
        python3 libpython3.9 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# proton
COPY --from=build /qpid-proton/install-prefix /usr/
# python packages
COPY --from=build /usr/lib/python3/dist-packages/proton /usr/lib/python3/dist-packages/proton
COPY --from=build /usr/lib/python3/dist-packages/cproton.py /usr/lib/python3/dist-packages/_cproton.so \
	/usr/lib/python3/dist-packages/

# qpid-dispatch
COPY --from=build /qpid-dispatch/install-prefix /usr/
# leftovers that are not so compliant with prefix, at least with how we manipulate it
COPY --from=build /etc/qpid-dispatch /etc/qpid-dispatch
COPY --from=build /usr/share/qpid-dispatch /usr/share/qpid-dispatch
COPY --from=build /etc/sasl2 /etc/sasl2
COPY --from=build /usr/lib/python3.9/site-packages/qpid_dispatch /usr/lib/python3.9/site-packages/qpid_dispatch
COPY --from=build /usr/lib/python3.9/site-packages/qpid_dispatch_site.py /usr/lib/python3.9/site-packages/

# Add site-packages to the PYTHONPATH environment variable