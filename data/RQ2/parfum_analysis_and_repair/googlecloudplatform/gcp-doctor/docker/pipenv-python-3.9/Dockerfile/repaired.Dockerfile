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

FROM python:3.9-slim

# Add pipenv.
RUN pip install --no-cache-dir pipenv

# Debian packages.
# binutils is for pyinstaller
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        bash \
        curl \
        git \
        binutils \
        make && rm -rf /var/lib/apt/lists/*;

# terraform
RUN curl -f https://releases.hashicorp.com/terraform/1.0.8/terraform_1.0.8_linux_amd64.zip | \
    gunzip - >/usr/bin/terraform && \
    chmod +x /usr/bin/terraform

# Add an entrypoint to create a user in /etc/passwd and /etc/group.
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh; \
    chmod 666 /etc/passwd /etc/group
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
