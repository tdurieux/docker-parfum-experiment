# ------------------------------------------------------------------------
#
# Copyright 2018 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
#
# ------------------------------------------------------------------------

FROM node:11.2.0-slim
MAINTAINER WSO2 VICK Maintainers "dev@wso2.org"

ARG PORTAL_PORT=3000
ARG APP_DIR=/portal

WORKDIR ${APP_DIR}

COPY ./target/files ${APP_DIR}/

ENV PORTAL_PORT=${PORTAL_PORT}

EXPOSE ${PORTAL_PORT}

RUN npm install

ENTRYPOINT ["node", "serve.js"]
