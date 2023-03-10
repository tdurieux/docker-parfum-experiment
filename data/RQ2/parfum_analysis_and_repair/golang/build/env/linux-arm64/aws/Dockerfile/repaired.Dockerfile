# Copyright 2020 The Go Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
          gcc curl strace \
          ca-certificates netbase \
          procps lsof psmisc \
          openssh-server && rm -rf /var/lib/apt/lists/*;

RUN mkdir /usr/local/go-bootstrap && \
    curl -f --silent https://storage.googleapis.com/go-builder-data/gobootstrap-linux-arm64.tar.gz | \
    tar -C /usr/local/go-bootstrap -zxv

ENV GOROOT_BOOTSTRAP /usr/local/go-bootstrap
RUN curl -f -o  /usr/local/bin/stage0 https://storage.googleapis.com/go-builder-data/buildlet-stage0.linux-arm64 && \
    chmod +x /usr/local/bin/stage0

ENV GO_BUILDER_ENV host-linux-arm64-aws

CMD ["/usr/local/bin/stage0"]
