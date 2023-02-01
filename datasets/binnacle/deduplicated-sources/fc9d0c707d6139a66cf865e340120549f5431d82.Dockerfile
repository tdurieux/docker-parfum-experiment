# Copyright 2018 Google Inc.
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

# Definition for Docker image that runs the InterUSS Platform storage API server.

# To build an image from this Dockerfile:
# docker image build -f Dockerfile_storageapi -t interussplatform/storage_api ../src

# To run this image:
# docker run \
#     -e INTERUSS_CONNECTIONSTRING="zookeeper_ip:2181" \
#     -e INTERUSS_PUBLIC_KEY="${INTERUSS_PUBLIC_KEY}" \
#     -p 8120:8120 -d interussplatform/storage_api

# Required environment variables:
#   INTERUSS_CONNECTIONSTRING: Set of Zookeeper servers to which the storage API should connect.
#     Format: server:port,server:port,...
#   INTERUSS_PUBLIC_KEY: Public key for InterUSS Platform OAuth.

# Optional environment variables:
#   INTERUSS_API_PORT: Port on which the InterUSS API will be served via HTTP (default 8120)
#   INTERUSS_API_SERVER: IP address that will respond to InterUSS API requests (default 0.0.0.0)
#   INTERUSS_VERBOSE: True for more log messages from the InterUSS API (default true)
#   INTERUSS_TESTID: Force testing mode with test data located in specific test id

FROM python:2

WORKDIR /usr/src/app

RUN pip install --no-cache-dir python-dateutil kazoo flask PyJWT djangorestframework cryptography pytz gunicorn shapely

COPY . .

ENV INTERUSS_API_SERVER 0.0.0.0
ENV INTERUSS_API_PORT 8120
ENV INTERUSS_VERBOSE true

CMD gunicorn storage_api:webapp -b ${INTERUSS_API_SERVER}:${INTERUSS_API_PORT} --access-logfile -
# CMD [ "python", "./storage_api.py" ]

EXPOSE $INTERUSS_API_PORT
