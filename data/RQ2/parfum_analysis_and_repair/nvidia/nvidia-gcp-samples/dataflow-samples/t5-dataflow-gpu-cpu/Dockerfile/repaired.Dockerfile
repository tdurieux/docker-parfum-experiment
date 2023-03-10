# Copyright 2021 NVIDIA Corporation
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

FROM nvcr.io/nvidia/tensorflow:20.11-tf2-py3

RUN pip install --no-cache-dir apache-beam[gcp]==2.26.0 ipython pytest pandas && \
    mkdir -p /workspace/tf_beam
RUN pip install --no-cache-dir tensorflow_text

COPY --from=apache/beam_python3.6_sdk:2.26.0 /opt/apache/beam /opt/apache/beam

ADD . /workspace/tf_beam

WORKDIR /workspace/tf_beam

ENTRYPOINT [ "/opt/apache/beam/boot"]
