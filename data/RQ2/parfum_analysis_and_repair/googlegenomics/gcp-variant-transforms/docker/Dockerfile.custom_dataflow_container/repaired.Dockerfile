# Copyright 2021 Google Inc.  All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# To build a new docker image, run the following from the root source dir:
# $ docker build . -f docker/Dockerfile.custom_dataflow_container -t $IMAGE_NAME

# https://cloud.google.com/dataflow/docs/guides/using-custom-containers#python


FROM apache/beam_python3.8_sdk:2.37.0

RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    gcc \
    libbz2-dev \
    libcurl4-openssl-dev \
    liblzma-dev \
    libssl-dev \
    make \
    perl \
    zlib1g-dev \
    python3-pysam && rm -rf /var/lib/apt/lists/*;

ADD /requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r /requirements.txt
