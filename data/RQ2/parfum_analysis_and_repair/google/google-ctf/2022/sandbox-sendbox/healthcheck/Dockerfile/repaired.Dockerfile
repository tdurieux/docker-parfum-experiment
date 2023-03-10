# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM gcr.io/kctf-docker/healthcheck@sha256:57c1002a2a8b8741bd2f6b9ee3e1da2c5b3872459b789255895bb8cdf297b911

RUN apt-get update && apt-get install -yq --no-install-recommends python3-protobuf protobuf-compiler && rm -rf /var/lib/apt/lists/*;

COPY healthcheck_loop.sh healthcheck.py healthz_webserver.py chal.proto /home/user/

RUN cd /home/user && protoc --python_out=. chal.proto

CMD kctf_drop_privs /home/user/healthcheck_loop.sh & /home/user/healthz_webserver.py
