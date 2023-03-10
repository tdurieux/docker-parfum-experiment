#
# ***** BEGIN LICENSE BLOCK *****
#
# Copyright (C) 2017-2019 Olof Hagsand
# Copyright (C) 2020-2022 Olof Hagsand and Rubicon Communications, LLC(Netgate)
#
# This file is part of CLIXON
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Alternatively, the contents of this file may be used under the terms of
# the GNU General Public License Version 3 or later (the "GPL"),
# in which case the provisions of the GPL are applicable instead
# of those above. If you wish to allow use of your version of this file only
# under the terms of the GPL, and not to allow others to
# use your version of this file under the terms of Apache License version 2,
# indicate your decision by deleting the provisions above and replace them with
# the notice and other provisions required by the GPL. If you do not delete
# the provisions above, a recipient may use your version of this file under
# the terms of any one of the Apache License version 2 or the GPL.
#
# ***** END LICENSE BLOCK *****
#
# Clixon dockerfile without restconf

FROM alpine
MAINTAINER Olof Hagsand <olof@hagsand.se>

# For clixon and cligen
RUN apk add --no-cache --update git make build-base gcc flex bison curl-dev

WORKDIR /usr/local/share

# Checkout standard YANG models for tests (note >1G for full repo)
RUN mkdir yang

WORKDIR /usr/local/share/yang

RUN git config --global init.defaultBranch master
RUN git init;
RUN git remote add -f origin https://github.com/YangModels/yang;
RUN git config core.sparseCheckout true
RUN echo "standard/" >> .git/info/sparse-checkout
RUN echo "experimental/" >> .git/info/sparse-checkout

WORKDIR /usr/local/share/yang
RUN git pull origin main

# Create a directory to hold source-code, dependencies etc
RUN mkdir /clixon
RUN mkdir /clixon/build
WORKDIR /clixon

# Clone cligen
RUN git clone https://github.com/clicon/cligen.git

# Build cligen
WORKDIR /clixon/cligen
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/clixon/build
RUN make
RUN make install

# Copy Clixon from local dir
RUN mkdir /clixon/clixon
WORKDIR /clixon/clixon
COPY clixon .

# Configure, build and install clixon
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/clixon/build --with-cligen=/clixon/build --without-restconf --with-yang-standard-dir=/usr/local/share/yang/standard
RUN make
RUN make install

# Install utils (for tests)
WORKDIR /clixon/clixon/util
RUN make
RUN make install

# Build and install the clixon example
WORKDIR /clixon/clixon/example/main
RUN make
RUN make install
RUN install example.xml /clixon/build/etc/clixon.xml

# Copy tests
WORKDIR /clixon/clixon/test
RUN install -d /clixon/build/bin/test
RUN install *.sh /clixon/build/bin/test
RUN install *.exp /clixon/build/bin/test
RUN install clixon.png /clixon/build/bin/test

# Copy startscript
WORKDIR /clixon
COPY startsystem.sh startsystem.sh
RUN install startsystem.sh /clixon/build/bin/

#
# Stage 2
# The second step skips the development environment and builds a runtime system
FROM alpine
MAINTAINER Olof Hagsand <olof@hagsand.se>

# For clixon and cligen
RUN apk add --no-cache --update flex bison fcgi-dev

# Test-specific (for test scripts)
RUN apk add --no-cache --update sudo curl procps grep make bash expect

# Create clicon user and group
RUN adduser -D -H clicon

COPY --from=0 /clixon/build/ /usr/local/
COPY --from=0 /usr/local/share/yang/* /usr/local/share/yang/standard/

# Log to stderr.
CMD /usr/local/bin/startsystem.sh
