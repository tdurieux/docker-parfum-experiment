# Copyright 2021 The Kubernetes Authors.
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

FROM postgres:12.7 AS final
LABEL maintainer "ii <public-log-asn-matcher@ii.coop>"
RUN apt-get update && \
  apt-get install --no-install-recommends -y curl && \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
  apt-get update && \
  apt-get install  -y --no-install-recommends \
  python3 \
  python3-dev \
  python3-pip \
  python3-wheel \
  python3-setuptools \
  python3-bs4 \
  python3-lxml \
  jq \
  curl \
  git \
  gcc \
  libc6-dev \
  gettext-base \
  procps \
  google-cloud-sdk && \
  rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir \
  pyasn \
  yq==2.12.0
WORKDIR /app
COPY ./pg-init.d /docker-entrypoint-initdb.d
COPY ./app .
COPY ./buckets.txt /app
ENV POSTGRES_PASSWORD=postgres
