#
# Copyright © 2016-2022 The Thingsboard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM node:16.13.1-bullseye-slim

COPY start-web-ui.sh /tmp/

RUN chmod a+x /tmp/*.sh \
    && mv /tmp/start-web-ui.sh /usr/bin

ENV NODE_ENV production
ENV DOCKER_MODE true

WORKDIR ${pkg.installFolder}

COPY ["src/package.json", "src/yarn.lock", "./"]

COPY package/linux/conf ./conf
COPY package/linux/conf ./config
COPY web ./web
COPY src/server.js ./

RUN chown -R node:node ${pkg.installFolder}

RUN yarn install --production && yarn cache clean --all

USER node

CMD ["start-web-ui.sh"]
