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
# limitations under the License.
FROM node:8-alpine
RUN apk add --no-cache make gcc g++ python
WORKDIR /common
COPY ./apps/common/package.json /common
COPY ./apps/common/fabric-client-1.4.2-snapshot.tgz /common
COPY ./apps/common/fabric-network-1.4.2-snapshot.tgz /common
RUN npm install && npm cache clean --force;
COPY ./apps/common /common
RUN npm run build
WORKDIR /app/client
COPY ./apps/car_builder/client/package.json /app/client
RUN npm install -g cordova@8.0.0 && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY ./apps/car_builder/client /app/client
RUN npm run build
WORKDIR /app/server
COPY ./apps/car_builder/server/package.json /app/server
RUN npm install && npm cache clean --force;
RUN npm rebuild
COPY ./apps/car_builder/server /app/server
RUN npm run build
CMD npm run start
EXPOSE 6001
