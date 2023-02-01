# Copyright (c) 2019 NVIDIA CORPORATION. All rights reserved.
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

FROM nvcr.io/nvidia/tritonserver:21.05-py3-sdk

# Kaldi dependencies
RUN apt-get update && apt-get install --no-install-recommends -y jupyter \
                   python3-pyaudio \
                   python-pyaudio \
                   libasound-dev \
                   portaudio19-dev \
                   libportaudio2 \
                   libportaudiocpp0 \
                   libsndfile1 \
                   alsa-base \
                   alsa-utils \
                   vim && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip uninstall -y pip
RUN apt install -y --no-install-recommends python3-pip --reinstall && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir matplotlib soundfile librosa sounddevice
