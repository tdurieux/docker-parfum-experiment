# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM ubuntu:20.04 as chroot

RUN /usr/sbin/useradd -u 1000 user

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
       curl ca-certificates socat gnupg lsb-release software-properties-common php-cgi \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /mnt/disks/sessions
RUN mkdir -p /mnt/disks/uploads

VOLUME /mnt/disks/sessions
VOLUME /mnt/disks/uploads

COPY web-apps /web-apps

FROM gcr.io/kctf-docker/challenge@sha256:53499279053b1dace64197f0376b972793f1131c6b0fa317edf23fe1b0933b61

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends tzdata apache2 \
    && ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN service apache2 start

COPY --from=chroot / /chroot

# For CGI sandboxing