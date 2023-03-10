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

FROM python:3.7-slim-buster

RUN apt update && apt -y --no-install-recommends install ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install gazer

COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir .
WORKDIR /
ENTRYPOINT ["ldeploy"]
