#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM ubuntu:16.04


# Install conda with pip and python 3.6
ARG CONDA_ENVIORNMENT
RUN apt-get update --fix-missing && apt-get -y upgrade && apt-get install --no-install-recommends -y \
  curl bzip2 \
  && curl -f -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
  && bash /tmp/miniconda.sh -bfp /usr/local \
  && rm -rf /tmp/miniconda.sh \
  && conda create -y --name $CONDA_ENVIORNMENT python=3.6 \
  && conda clean --all --yes && rm -rf /var/lib/apt/lists/*;

ENV PATH /usr/local/envs/$CONDA_ENVIORNMENT/bin:$PATH
RUN pip install --no-cache-dir --upgrade pip
ENV PYTHONUNBUFFERED 1

ARG DOCKER_WORKDIR_PATH
RUN mkdir -p $DOCKER_WORKDIR_PATH
WORKDIR $DOCKER_WORKDIR_PATH
ENV PYTHONPATH $DOCKER_WORKDIR_PATH

# Install python dependencies
COPY singa_auto/ singa_auto/
RUN pip install --no-cache-dir -r singa_auto/requirements.txt
RUN pip install --no-cache-dir -r singa_auto/utils/requirements.txt
RUN pip install --no-cache-dir -r singa_auto/meta_store/requirements.txt
RUN pip install --no-cache-dir -r singa_auto/container/requirements.txt
RUN pip install --no-cache-dir -r singa_auto/admin/requirements.txt

COPY scripts/ scripts/

EXPOSE 3000
CMD ["python", "scripts/start_admin.py"]
