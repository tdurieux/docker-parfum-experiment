# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Builds -> skywalking-agent:latest-e2e
ARG BASE_PYTHON_IMAGE

FROM python:${BASE_PYTHON_IMAGE}

VOLUME /services

COPY tests/e2e/base/consumer/consumer.py /services/
COPY tests/e2e/base/provider/provider.py /services/

# Copy the project and build
COPY . /skywalking-python/
RUN cd /skywalking-python && make install
ENV PATH="/skywalking-python/venv/bin:$PATH"

RUN pip install --no-cache-dir requests kafka-python
# Extra dependencies for e2e services
RUN pip install --no-cache-dir fastapi uvicorn aiohttp

# Entrypoint with agent attached
Entrypoint ["sw-python", "run"]
