# SPDX-License-Identifier: BSD-3-Clause
# Copyright © 2020 Fragcolor Pte. Ltd.

FROM i386/alpine

ENV DEBIAN_FRONTEND=noninteractive
RUN apk update
RUN apk add --no-cache build-base git cmake wget clang ninja boost-dev xorg-server-dev dbus-dev openssl-dev

COPY ./ /root/repo

# needs something like
# cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-DBX_CRT_MUSL=1 -DFORCE_I686=1 ..