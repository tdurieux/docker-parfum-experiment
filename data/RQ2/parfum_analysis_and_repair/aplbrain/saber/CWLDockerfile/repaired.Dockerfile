# Copyright 2019 The Johns Hopkins University Applied Physics Laboratory
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#### CWL parser dockerfile ####

FROM python:3.6-slim
ARG AIRFLOW_VERSION=1.10.4
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes
RUN set -ex \
    && buildDeps=' \
        python3-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        build-essential \
        libblas-dev \
        liblapack-dev \
        libpq-dev \
        git \
    ' \
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        python3-pip \
        python3-requests \
        default-libmysqlclient-dev \
        apt-utils \
        curl \
        rsync \
        netcat \
        default-mysql-server \
        default-mysql-client \
        locales && rm -rf /var/lib/apt/lists/*;
RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir apache-airflow==$AIRFLOW_VERSION
RUN pip install --no-cache-dir apache-airflow==$AIRFLOW_VERSION
# COPY awsbatch_operator.py \
#     cwl-to-dag.py \
#     create_job_definitions.py \
#     parameterization.py \
#     datajoint_hook.py \
#     s3wrap /scripts/
    # s3wrap \
    # cwl_monitor /scripts/
# ENTRYPOINT [ "cwl_monitor" ]
COPY ./conduit /conduit
COPY ./setup.py /
RUN pip install --no-cache-dir -e /
ENV PATH="/conduit:${PATH}"
