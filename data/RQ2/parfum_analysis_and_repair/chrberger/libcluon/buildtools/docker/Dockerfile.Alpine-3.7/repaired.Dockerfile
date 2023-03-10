# Copyright (C) 2017  Christian Berger
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

FROM alpine:3.7
MAINTAINER Christian Berger "christian.berger@gu.se"

RUN apk add --no-cache --update \
    bash \
    ccache \
    cmake \
    g++ \
    gcc \
    git \
    make \
    ninja \
    upx
