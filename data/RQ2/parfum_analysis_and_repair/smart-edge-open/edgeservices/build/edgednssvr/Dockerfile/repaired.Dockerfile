# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019-2020 Intel Corporation

FROM alpine:3.12.0 AS edgedns-deps-image

RUN printf "http://nl.alpinelinux.org/alpine/v3.12/main\nhttp://nl.alpinelinux.org/alpine/v3.12/community" >> /etc/apk/repositories
RUN apk add --no-cache sudo

RUN apk add --no-cache -u apk-tools busybox

FROM edgedns-deps-image

ENV DNS_FWDR=""

ARG username=edgednssvr
ARG user_dir=/home/$username

RUN addgroup -S sudo && adduser -S $username -G sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# Workaround for sudo error: https://gitlab.alpinelinux.org/alpine/aports/issues/11122
RUN echo 'Set disable_coredump false' >> /etc/sudo.conf

USER $username
WORKDIR $user_dir

COPY ./edgednssvr ./
ENTRYPOINT ["sudo", "./edgednssvr"]
CMD ["-port=53", "-fwdr=8.8.8.8"]
