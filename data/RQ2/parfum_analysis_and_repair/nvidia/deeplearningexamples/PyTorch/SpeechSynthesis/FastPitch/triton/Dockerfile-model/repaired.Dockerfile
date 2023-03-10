# Copyright (c) 2020 NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:21.02-py3
ARG TRITON_CLIENT_IMAGE_NAME=nvcr.io/nvidia/tritonserver:21.02-py3-sdk
FROM ${TRITON_CLIENT_IMAGE_NAME} as triton-client
FROM ${FROM_IMAGE_NAME}

# Install Perf Client required library
RUN apt-get update && apt-get install --no-install-recommends -y libb64-dev libb64-0d && rm -rf /var/lib/apt/lists/*;

# Install Triton Client Python API and copy Perf Client
COPY --from=triton-client /workspace/install/ /workspace/install/
RUN pip install --no-cache-dir /workspace/install/python/triton*.whl

# Setup environment variables to access Triton Client binaries and libs
ENV PATH /workspace/install/bin:${PATH}
ENV LD_LIBRARY_PATH /workspace/install/lib:${LD_LIBRARY_PATH}

ENV PYTHONPATH /workspace/fastpitch
WORKDIR /workspace/fastpitch

# RUN conda install -y tqdm

ADD requirements.txt .
ADD triton/requirements.txt triton/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r triton/requirements.txt

COPY . .
