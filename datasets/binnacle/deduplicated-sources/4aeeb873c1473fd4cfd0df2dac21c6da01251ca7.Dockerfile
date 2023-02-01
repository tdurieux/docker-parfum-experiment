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

# Definition for Docker image that proxies traffic to the storage API service.

# To build an image from this Dockerfile:
# docker image build -f Dockerfile_reverseproxy -t interussplatform/reverse_proxy .

# To run this image:
# docker run \
#     -e STORAGE_API_SERVER="storage_api_ip" -e STORAGE_API_PORT="5000" \
#     -p 8121:8121 -d interussplatform/reverse_proxy

# Required environment variables:
#   STORAGE_API_SERVER: Address of the storage API service.
#   STORAGE_API_PORT: Port on which the storage API service is listening.

# Optional environment variables:
#   INTERUSS_API_PORT_HTTPS: Port on which the InterUSS API will be served via HTTPS (default 8121).

FROM nginx

COPY nginx_entrypoint.sh .
COPY test_cert.pem /etc/ssl/certs/cert.pem
COPY test_key.pem /etc/ssl/private/key.pem
COPY test_signatures .

ENV INTERUSS_API_PORT_HTTPS 8121

CMD ./nginx_entrypoint.sh

EXPOSE $INTERUSS_API_PORT_HTTPS
