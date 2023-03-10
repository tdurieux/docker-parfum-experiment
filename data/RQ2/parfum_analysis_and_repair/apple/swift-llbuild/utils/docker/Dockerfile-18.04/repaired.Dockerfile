# This source file is part of the Swift.org open source project
#
# Copyright (c) 2018 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See http://swift.org/LICENSE.txt for license information
# See http://swift.org/CONTRIBUTORS.txt for Swift project authors

FROM ubuntu:18.04

# Install necesary packages
RUN apt-get -q update && \
    apt-get -q --no-install-recommends install -y \
    clang \
    cmake \
    ninja-build \
    sqlite3 \
    python-pip \
    libsqlite3-dev \
    libncurses5-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir lit
RUN apt-get -q --no-install-recommends install -y llvm-6.0-tools && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /bin/sh sh /bin/bash 100

ARG SNAPSHOT
COPY "$SNAPSHOT" /
RUN tar -xvzf "$SNAPSHOT" --directory / --strip-components=1 && \
    rm -rf swift-DEVELOPMENT-SNAPSHOT*

# Set Swift Path
ENV PATH /usr/bin:$PATH

CMD ["/bin/bash"]
