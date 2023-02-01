# Copyright 2020 The SODA Authors.
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

FROM ubuntu:18.04

MAINTAINER soda team

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3-pip && \
    apt-get install --no-install-recommends -y sqlite3 && \
    apt-get install --no-install-recommends -y libffi-dev && \
    pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

ADD . /delfin

WORKDIR /delfin

RUN pip3 install --no-cache-dir -r requirements.txt && \
    python3 setup.py install

ENTRYPOINT ["/delfin/script/start.sh"]

