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

RUN apt-get update && apt-get install --no-install-recommends -y \
    libgl1-mesa-dev \
    libglew-dev \
    libosmesa6-dev \
    patchelf \
    tmux \
    unzip && rm -rf /var/lib/apt/lists/*;

# Download mujoco
RUN curl -f https://www.roboti.us/download/mjpro150_linux.zip --output /tmp/mujoco.zip && \
    mkdir -p /root/.mujoco && \
    unzip /tmp/mujoco.zip -d /root/.mujoco && \
    rm -f /tmp/mujoco.zip

# Copy the mujoco license key
COPY mjkey.txt /root/.mujoco/mjkey.txt

RUN pip3 install --no-cache-dir Cython cffi lockfile glfw imageio dataclasses gin-config
RUN LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/.mujoco/mjpro150/bin pip3 --no-cache-dir install gym[mujoco]
RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/.mujoco/mjpro150/bin' >> /root/.bashrc

RUN pip3 install --no-cache-dir tensorflow_probability==0.11.0

# Copy SEED codebase and SEED GRPC binaries.
ADD . /seed_rl/
# Needed for Mujoco to avoid inconsistent symbol definitions.
RUN rm /usr/include/GL/glext.h && touch /usr/include/GL/glext.h

WORKDIR /seed_rl
ENTRYPOINT ["python3", "gcp/run.py"]
