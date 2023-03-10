# Copyright (c) 2021, NVIDIA CORPORATION. All rights reserved.
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

ARG FROM_IMAGE_NAME=nvcr.io/nvidia/tensorflow:21.09-tf2-py3
FROM ${FROM_IMAGE_NAME}

RUN echo ${FROM_IMAGE_NAME}

WORKDIR /workspace
COPY . .

RUN python -m pip install --upgrade pip && \
    pip --no-cache-dir --no-cache install --user -r requirements.txt

ENV TF_XLA_FLAGS="--tf_xla_enable_lazy_compilation=false"
RUN pip install --no-cache-dir git+https://github.com/NVIDIA/dllogger
