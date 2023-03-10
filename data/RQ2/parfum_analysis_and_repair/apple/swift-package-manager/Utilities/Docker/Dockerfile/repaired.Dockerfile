# This source file is part of the Swift open source project
#
# Copyright (c) 2014 - 2021 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See http://swift.org/LICENSE.txt for license information
# See http://swift.org/CONTRIBUTORS.txt for Swift project authors

ARG swift_version=5.3
ARG ubuntu_version=bionic
ARG base_image=swift:$swift_version-$ubuntu_version
FROM $base_image
# needed to do again after FROM due to docker limitation
ARG swift_version
ARG ubuntu_version

# set as UTF-8
RUN apt-get update && apt-get install --no-install-recommends -y locales locales-all && rm -rf /var/lib/apt/lists/*;
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# SwiftPM dependencies
#---------------------

RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  libsqlite3-dev \
  libncurses5-dev \
  sqlite3 \
  zip && rm -rf /var/lib/apt/lists/*;

# Bootstrap script dependencies
#------------------------------

RUN apt-get install --no-install-recommends -y wget software-properties-common && rm -rf /var/lib/apt/lists/*;

# use kitware for recent versions of cmake and ninja (required by bootstrap script)
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $ubuntu_version main"

RUN apt-get install --no-install-recommends -y \
  python3 \
  cmake \
  ninja-build && rm -rf /var/lib/apt/lists/*;
