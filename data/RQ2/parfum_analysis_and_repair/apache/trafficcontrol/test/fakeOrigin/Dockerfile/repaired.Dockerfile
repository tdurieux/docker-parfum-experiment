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

FROM golang:1.11
MAINTAINER dev@trafficcontrol.apache.org

RUN apt-get update && \
    apt-get install --no-install-recommends -y ffmpeg \
      openssl \
      gpac && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

COPY . /go/src/github.com/apache/trafficcontrol
WORKDIR /go/src/github.com/apache/trafficcontrol/test/fakeOrigin

RUN go install -v ./...

RUN groupadd -g 999 fakeOrigin && \
    useradd -r -u 999 -g fakeOrigin fakeOrigin
RUN chown -R fakeOrigin:fakeOrigin .
USER fakeOrigin

VOLUME ["/host"]

CMD ["fakeOrigin", "-cfg", "/host/config.json"]
