# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM {ARG_FROM}

MAINTAINER Tim Hockin <thockin@google.com>

ADD bin/{ARG_OS}_{ARG_ARCH}/{ARG_BIN} /{ARG_BIN}

RUN apt-get update \
    && apt-get -y install \
        ca-certificates \
        coreutils \
        git \
        openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN echo "git-sync:x:65533:65533::/tmp:/sbin/nologin" >> /etc/passwd

WORKDIR /tmp
USER git-sync:nogroup
ENTRYPOINT ["/{ARG_BIN}"]
