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

ARG FROM=ubuntu:18.04
FROM ${FROM} AS baclient_builder

ARG UBUNTU_REPO=http://archive.ubuntu.com/ubuntu
ARG TRUSTED_UBUNTU_REPO=no
ARG ALLOW_UNAUTHENTICATED=false
ARG BUILD_DIR
ENV container docker
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Copy direct dependency requirements only to build a dependency layer
RUN echo "deb  ${UBUNTU_REPO} bionic main restricted universe multiverse" > /etc/apt/sources.list; \
    echo "deb  ${UBUNTU_REPO} bionic-security main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb  ${UBUNTU_REPO} bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list; \
    cat /etc/apt/sources.list; \
    echo "APT::Get::AllowUnauthenticated ${ALLOW_UNAUTHENTICATED};" >> /etc/apt/apt.conf.d/00-local-mirrors;


COPY ./tools/baclient_build.sh /tmp/drydock/
COPY ./go /tmp/drydock/go
WORKDIR /tmp/drydock
RUN ./baclient_build.sh /tmp/drydock/go /tmp/drydock/baclient

# Build LibYAML
ARG LIBYAML_VERSION=0.2.5
RUN set -ex \
    && apt install --no-install-recommends -y git automake make libtool \
    && git clone https://github.com/yaml/libyaml.git \
    && cd libyaml \
    && git checkout $LIBYAML_VERSION \
    && ./bootstrap \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && cd .. \
    && rm -fr libyaml && rm -rf /var/lib/apt/lists/*;

RUN rm -r /var/lib/apt/lists/*


FROM ${FROM}

LABEL org.opencontainers.image.authors='airship-discuss@lists.airshipit.org, irc://#airshipit@freenode' \
      org.opencontainers.image.url='https://airshipit.org' \
      org.opencontainers.image.documentation='https://airship-drydock.readthedocs.org' \
      org.opencontainers.image.source='https://git.openstack.org/openstack/airship-drydock' \
      org.opencontainers.image.vendor='The Airship Authors' \
      org.opencontainers.image.licenses='Apache-2.0'

ARG UBUNTU_REPO=http://archive.ubuntu.com/ubuntu
ARG TRUSTED_UBUNTU_REPO=no
ARG ALLOW_UNAUTHENTICATED=false
ARG PIP_TRUSTED_HOST=foo.com
ARG PIP_INDEX_URL=https://pypi.org/simple
ARG BUILD_DIR
ENV container docker
ENV PORT 9000
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Copy direct dependency requirements only to build a dependency layer
RUN echo "deb  ${UBUNTU_REPO} bionic main restricted universe multiverse" > /etc/apt/sources.list; \
    echo "deb  ${UBUNTU_REPO} bionic-security main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb  ${UBUNTU_REPO} bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list; \
    cat /etc/apt/sources.list; \
    echo "APT::Get::AllowUnauthenticated ${ALLOW_UNAUTHENTICATED};" >> /etc/apt/apt.conf.d/00-local-mirrors;


COPY ./requirements-host.txt /tmp/drydock/
COPY ./hostdeps.sh /tmp/drydock
WORKDIR /tmp/drydock
RUN ./hostdeps.sh; \
    rm -r /var/lib/apt/lists/*

# Install LibYAML
ENV LD_LIBRARY_PATH=/usr/local/lib
COPY --from=baclient_builder /usr/local/lib /usr/local/lib
COPY --from=baclient_builder /usr/local/include/yaml.h /usr/local/include/yaml.h

COPY ./python/requirements-lock.txt /tmp/drydock/
RUN pip3 install \
    --no-cache-dir \
    -r /tmp/drydock/requirements-lock.txt

COPY ./python /tmp/drydock/python
WORKDIR /tmp/drydock/python
RUN python3 setup.py install

COPY ./alembic /tmp/drydock/alembic
COPY ./alembic.ini /tmp/drydock/alembic.ini
COPY ./entrypoint.sh /tmp/drydock/entrypoint.sh

COPY --from=baclient_builder /tmp/drydock/baclient /tmp/drydock/python/drydock_provisioner/assets/baclient


EXPOSE $PORT

WORKDIR /tmp/drydock

ENTRYPOINT ["./entrypoint.sh"]
CMD ["server"]
