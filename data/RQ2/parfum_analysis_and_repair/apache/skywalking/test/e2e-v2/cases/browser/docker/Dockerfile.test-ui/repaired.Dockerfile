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

FROM node:10.23 AS builder

## download and build skywalking client js
ARG SW_AGENT_CLIENT_JS_COMMIT
ARG CLIENT_JS_CODE=${SW_AGENT_CLIENT_JS_COMMIT}.tar.gz
ARG CLIENT_JS_CODE_URL=https://github.com/apache/skywalking-client-js/archive/${CLIENT_JS_CODE}

WORKDIR /skywalking-client-js
ADD ${CLIENT_JS_CODE_URL} .
RUN tar -xf ${CLIENT_JS_CODE} --strip 1 && rm ${CLIENT_JS_CODE}
RUN npm run rebuild \
    && npm link

# download and build skywalking client test
ARG SW_AGENT_CLIENT_JS_TEST_COMMIT
ARG CLIENT_JS_TEST_CODE=${SW_AGENT_CLIENT_JS_TEST_COMMIT}.tar.gz
ARG CLIENT_JS_TEST_CODE_URL=https://github.com/SkyAPMTest/skywalking-client-test/archive/${CLIENT_JS_TEST_CODE}

WORKDIR /skywalking-client-test
ADD ${CLIENT_JS_TEST_CODE_URL} .
RUN tar -xf ${CLIENT_JS_TEST_CODE} --strip 1 \
    && rm ${CLIENT_JS_TEST_CODE} \
    && rm src/index.js
COPY docker/index.js src/index.js

RUN npm install \
    && rm -rf node_modules/skywalking-client-js \
    && npm link skywalking-client-js \
    && npm run build && npm cache clean --force;

FROM nginx:1.19

COPY --from=builder /skywalking-client-test/dist/* /etc/nginx/html/
COPY docker/nginx.conf /etc/nginx/nginx.conf
