# Copyright 2019 Google LLC
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

FROM python:3.7

ARG GIT_TAG=3941ee66e59392a869b2954937e85e8d204a58c5

RUN \
    git clone https://github.com/centricular/gstwebrtc-demos.git && \
    cd gstwebrtc-demos/signalling && \
    git checkout ${GIT_TAG} && \
    pip3 install --no-cache-dir --user websockets && \
    cp -R * /opt/

WORKDIR /opt/

CMD python -u ./simple-server.py --port 8080 --disable-ssl
