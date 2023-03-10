#  Copyright 2018 U.C. Berkeley RISE Lab
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

FROM hydroproject/base:latest

USER root

COPY ./ ./anna/

WORKDIR /anna
RUN bash scripts/build.sh -j$(nproc) -bRelease
WORKDIR /

RUN apt install --no-install-recommends htop tcpdump -y && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install virtualenv
RUN virtualenv KVS-CLIENT
RUN /bin/bash -c "source KVS-CLIENT/bin/activate"
RUN KVS-CLIENT/bin/pip3 install google-api-python-client
RUN KVS-CLIENT/bin/pip3 install zmq

ENTRYPOINT ["/anna/scripts/start-docker-master.sh", "n", "n"]

