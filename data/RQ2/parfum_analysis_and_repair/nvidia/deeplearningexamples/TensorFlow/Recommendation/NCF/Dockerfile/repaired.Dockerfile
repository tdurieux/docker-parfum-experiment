# Copyright (c) 2018, NVIDIA CORPORATION. All rights reserved.
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

ARG FROM_IMAGE_NAME=nvcr.io/nvidia/tensorflow:20.07-tf1-py3
FROM ${FROM_IMAGE_NAME}

RUN apt-get update && \
    apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ADD . /workspace/recommendation
WORKDIR /workspace/recommendation
