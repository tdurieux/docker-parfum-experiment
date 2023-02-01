# Copyright 2017 AT&T Intellectual Property.  All other rights reserved.
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

ARG FROM=python:3.6
FROM ${FROM}

LABEL org.opencontainers.image.authors='airship-discuss@lists.airshipit.org, irc://#airshipit@freenode'
LABEL org.opencontainers.image.url='https://airshipit.org'
LABEL org.opencontainers.image.documentation='https://airship-promenade.readthedocs.org'
LABEL org.opencontainers.image.source='https://git.openstack.org/openstack/airship-promenade'
LABEL org.opencontainers.image.vendor='The Airship Authors'
LABEL org.opencontainers.image.licenses='Apache-2.0'

VOLUME /etc/promenade
VOLUME /target

RUN mkdir /opt/promenade
WORKDIR /opt/promenade

ENV PORT 9000
EXPOSE $PORT

# Setting promenade version for BPR
ENV PBR_VERSION 0.8.0

ENTRYPOINT ["/opt/promenade/entrypoint.sh"]

RUN set -ex \
    && curl -Lo /usr/local/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
    && chmod 555 /usr/local/bin/cfssl \
    && apt-get update -q \
    && apt-get install --no-install-recommends -y \
        libyaml-dev \
        rsync \
    && useradd -u 1000 -g users -d /opt/promenade promenade \
    && rm -rf /var/lib/apt/lists/*

COPY requirements-frozen.txt /opt/promenade
RUN pip install --no-cache-dir -r requirements-frozen.txt

COPY . /opt/promenade
RUN pip install -e /opt/promenade

USER promenade
