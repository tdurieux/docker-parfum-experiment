# Copyright (c) 2019-2021 VMware, Inc. All Rights Reserved.
# SPDX-License-Identifier: BSD-2-Clause

FROM python:3.9-slim-buster as base

FROM base as builder

RUN mkdir /install
WORKDIR /install

COPY dist/tern-*.tar.gz .
RUN pip install --no-warn-script-location --prefix=/install \
    tern-*.tar.gz

FROM base

RUN echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list.d/bullseye.list \
    && echo "Package: *\nPin: release n=bullseye\nPin-Priority: 50" > /etc/apt/preferences.d/bullseye \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    attr \
    findutils \
    fuse-overlayfs/bullseye \
    fuse3/bullseye \
    git \
    jq \
    skopeo \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local

ENTRYPOINT ["tern"]
CMD ["--help"]
