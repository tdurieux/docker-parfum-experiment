#
# Copyright Greg Haskins All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
FROM _NS_/fabric-basejvm:_TAG_
COPY scripts /tmp/scripts
RUN cd /tmp/scripts && \
    common/packages.sh && \
    common/setup.sh && \
    docker/fixup.sh && \
    common/cleanup.sh && \
    rm -rf /tmp/scripts
ENV GOPATH=/opt/gopath
ENV GOROOT=/opt/go
ENV GOCACHE=off
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin
