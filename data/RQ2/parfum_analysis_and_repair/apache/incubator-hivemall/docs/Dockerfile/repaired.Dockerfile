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
#

FROM node:8-buster-slim

ARG GITBOOK_VERSION=3.2.3

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y curl git && \
    npm install --global gitbook-cli && \
	gitbook fetch ${GITBOOK_VERSION} && \
	npm cache clear --force && \
    rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*;

WORKDIR /srv/gitbook

VOLUME /srv/gitbook /srv/html

EXPOSE 4000 35729

CMD /usr/local/bin/gitbook serve
