#
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

FROM postgres:10

### Get postgres specific add-ons
RUN apt-get update && apt-get install --no-install-recommends -y wget \
                       build-essential \
                       postgresql-server-dev-10 \
                       postgresql-plpython-10 \
                       openssl \
                       libssl-dev \
                       libboost-all-dev \
                       m4 \
                       rpm \
                       python-pip \
                       python-dev \
                       build-essential \
                       cmake \
                       libspatialindex-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir tensorflow==1.14 keras==2.2.4 dill "rtree>=0.8,<0.9"

## To build an image from this docker file, from madlib folder, run:
# docker build -t madlib/postgres_10:jenkins -f tool/docker/base/Dockerfile_postgres_10_Jenkins .
