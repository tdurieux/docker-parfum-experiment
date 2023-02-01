# Copyright 2020 Docker CLI JavaScript SDK authors

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


FROM node:12-buster-slim AS base
WORKDIR /src
COPY package.json .
COPY yarn.lock .

RUN --mount=type=cache,target=/usr/local/share/.cache/yarn/v6 \
    yarn install --frozen-lockfile && yarn cache clean;

COPY . .

FROM base AS run-build
RUN yarn build && yarn cache clean;

FROM scratch AS build
COPY --from=run-build /src/src /

FROM base AS lint
RUN yarn lint && yarn cache clean;

FROM base AS test
CMD ["yarn", "test"]
VOLUME ["/var/run/docker.sock"]
COPY --from=docker /usr/local/bin/docker /usr/local/bin/com.docker.cli
RUN yarn download-cli && yarn cache clean;

FROM base AS download-protos
RUN yarn download-protos && yarn cache clean;
RUN ./protos.sh

FROM scratch AS protos
COPY --from=download-protos /src/src /
