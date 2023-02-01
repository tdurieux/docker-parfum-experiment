# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#
#  FLOWDB
#  -----
#
#  Extends the base FlowDB image to include the oracle_fdw.
#  You must provide a URL to download the relevant Oracle
#  binaries from.
#
ARG CODE_VERSION=latest
FROM flowminder/flowdb:${CODE_VERSION}

#
#  Installs `oracle_fdw` for connecting to
#  Oracle instances.
#
ENV ORACLE_HOME=/usr/local/oracle/instantclient
ENV LD_LIBRARY_PATH=/usr/local/oracle/instantclient
ARG INSTANT_CLIENT_VERSION=12.2.0.1.0
ENV INSTANT_CLIENT_VERSION=$INSTANT_CLIENT_VERSION
ARG ORACLE_FDW_VERSION=2_4_0
ENV ORACLE_FDW_VERSION=$ORACLE_FDW_VERSION
ARG ORACLE_BINARY_SOURCE=.

ADD $ORACLE_BINARY_SOURCE/instantclient-basic-linux.x64-$INSTANT_CLIENT_VERSION.zip /tmp
ADD $ORACLE_BINARY_SOURCE/instantclient-sdk-linux.x64-$INSTANT_CLIENT_VERSION.zip /tmp
ADD $ORACLE_BINARY_SOURCE/instantclient-sqlplus-linux.x64-$INSTANT_CLIENT_VERSION.zip /tmp

#
#  Download and install oracle binaries, and the oracle_fdw
#