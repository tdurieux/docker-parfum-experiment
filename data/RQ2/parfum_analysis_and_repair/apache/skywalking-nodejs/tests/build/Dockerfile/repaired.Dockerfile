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

FROM node:12

WORKDIR /app

ADD . /app

RUN npm install request && npm install && npm run build && npm cache clean --force;

ADD tests/build/main.ts /test/main.ts
ADD tests/build/package.json /test/package.json

WORKDIR /test

RUN npm install && npm install /app && npm run build && npm cache clean --force;
