# Copyright 2019 The SEED Authors
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

FROM tensorflow/tensorflow:2.4.1-gpu

RUN apt-get update && apt-get install --no-install-recommends -y tmux ffmpeg libsm6 libxext6 libxrender-dev wget unrar unzip && rm -rf /var/lib/apt/lists/*;

# Install Atari environment
RUN pip3 install --no-cache-dir gym[atari]
RUN pip3 install --no-cache-dir atari-py
RUN pip3 install --no-cache-dir tensorflow_probability==0.11.0

RUN mkdir roms && \
    cd roms && \
    wget https://www.atarimania.com/roms/Roms.rar && \
    unrar e Roms.rar && \
    unzip ROMS.zip && \
    unzip "HC ROMS.zip" && \
    rm ROMS.zip && \
    rm "HC ROMS.zip" && \
    rm Roms.rar && \
    python -m atari_py.import_roms .


# Copy SEED codebase and SEED GRPC binaries.
ADD . /seed_rl/
WORKDIR /seed_rl
ENTRYPOINT ["python3", "gcp/run.py"]
