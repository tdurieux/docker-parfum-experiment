# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

FROM ubuntu:bionic as builder

MAINTAINER Ahmed Soliman <asoli@fb.com>

COPY logdevice/build_tools/ubuntu.deps /tmp/ubuntu.deps

RUN apt-get update \
    && apt-get install --no-install-recommends \
      -y $(cat /tmp/ubuntu.deps) \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /build/staging/usr/local \
    && python3 -m pip install setuptools \
    && python3 -m pip install virtualenv

# Activating the virtualenv
ENV VIRTUAL_ENV=/build/staging/usr/local
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3 -m pip install --upgrade setuptools wheel cython

COPY . LogDevice

WORKDIR /build

# Controls the build parallelism, it defaults to the number of cores, use this
# to reduce the total memory used during compilation.
ARG PARALLEL

ENV CC=clang-9
ENV CXX=clang++-9
RUN cmake -Dthriftpy3=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF /LogDevice/logdevice/ \
    && make -j ${PARALLEL:-$(nproc)}

CMD /bin/bash

# The production image
FROM ubuntu:bionic

# ldshell _requires_ utf-8
ENV LANG C.UTF-8

# Copy LogDevice user tools
COPY --from=builder /build/bin/ld* \
                  /build/bin/logdeviced \
                  /usr/local/bin/

# Python tools, ldshell, ldquery and libs
# Folly python bindings
COPY --from=builder /build/fbthrift-prefix/src/fbthrift-build/thrift/lib/py3/cybld/dist/thrift-*.whl /tmp/
# Thrift Py3
COPY --from=builder /build/folly-prefix/src/folly-build/folly/cybld/dist/folly-*.whl /tmp/
# libfolly/lib(Thrift) libraries
COPY --from=builder /build/staging/usr/local/lib/*.so /usr/local/lib/
# LDShell, LDops, ldquery, etc.
COPY --from=builder /build/python-out/dist/ldshell-*.whl /tmp/
# LogDevice client library python bindings
COPY --from=builder /build/lib/*.so /usr/local/lib/

# Install runtime dependencies for ld-dev-cluster, ldshell friends.
# To install the ldshell wheel we also need python3 build tools, as
# we depend on python-Levenshtein for which a many-linux binary wheel is not
# available; these are removed following install to keep docker image size low.