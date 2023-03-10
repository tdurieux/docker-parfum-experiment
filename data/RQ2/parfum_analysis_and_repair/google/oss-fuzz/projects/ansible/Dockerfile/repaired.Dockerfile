# Copyright 2022 Google LLC.
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

FROM gcr.io/oss-fuzz-base/base-builder-python

RUN apt-get update && apt-get install --no-install-recommends -y make autoconf automake build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

RUN git clone https://github.com/ansible/ansible
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir cython cryptography

RUN cd ansible && \
    pip3 install --no-cache-dir -r ./requirements.txt

WORKDIR ansible

COPY build.sh fuzz_encrypt.sh *.py $SRC/
