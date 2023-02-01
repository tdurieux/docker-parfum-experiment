#
#  Copyright 2019 The FATE Authors. All Rights Reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

FROM centos/python-36-centos7

ARG version
ARG source_dir
ARG pip_index_url
ARG pip_index_host
ARG repo_file

USER root

WORKDIR /data/projects/fate
ENV WORKDIR /data/projects/fate

COPY requirements.txt install_os_dependencies.sh init.sh *.repo ${WORKDIR}/
RUN rm /bin/sh && ln -sf /bin/bash /bin/sh

RUN sh ./init.sh ${repo_file}

# fate python dependencies
RUN if [[ -z ${pip_index_url} ]]; then \
 pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r ./requirements.txt; \
    else pip_index_host=$(echo ${pip_index_url} | sed "s#http.*://##g" | sed "s#/.*##g") && \
    pip install --no-cache-dir --upgrade pip -i ${pip_index_url} --trusted-host ${pip_index_host} && \
    pip install --no-cache-dir -r ./requirements.txt -i ${pip_index_url} --trusted-host ${pip_index_host}; fi
# clean
RUN rm -rf requirements.txt install_os_dependencies.sh init.sh *.repo