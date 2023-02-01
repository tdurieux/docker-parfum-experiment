# Copyright 2021 Google LLC
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
#
################################################################################

FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip python-setuptools bridge-utils \
  libglib2.0-dev libdbus-1-dev libudev-dev \
  libical-dev libreadline-dev udev \
  libtool autoconf automake systemd && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --user google-cloud googleapis-common-protos grpcio protobuf pycryptodomex
RUN cpan -i Text::Template
RUN git clone --depth 1 https://github.com/openweave/openweave-core
WORKDIR $SRC/openweave-core
COPY build.sh $SRC/
COPY patch.diff $SRC/
