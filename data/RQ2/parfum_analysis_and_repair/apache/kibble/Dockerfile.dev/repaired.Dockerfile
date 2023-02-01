# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM python:3.8

ENV KIBBLE_DIR="/opt/kibble"

# Install some dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends dumb-init && rm -rf /var/lib/apt/lists/*;

# Copy all sources (we use .dockerignore for excluding)
ADD . ${KIBBLE_DIR}

# Install kibble and required dev dependencies
WORKDIR ${KIBBLE_DIR}

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -e ".[devel]"

# Run sanity check
RUN kibble --help

# Use dumb-init as entrypoint to improve signal handling
# https://github.com/Yelp/dumb-init
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
