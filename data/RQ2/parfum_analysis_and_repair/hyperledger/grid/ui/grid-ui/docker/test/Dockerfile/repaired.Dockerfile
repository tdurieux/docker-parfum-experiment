# Copyright 2018-2021 Cargill Incorporated
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

# Dockerfile for running unit tests and lint on the Grid UI
FROM node:14.18.1-alpine3.11

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

COPY ui/grid-ui/package*.json /ui/grid-ui/

RUN apk add --no-cache \
	curl \
	git

RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh \
    | sh -s -- --to /usr/local/bin

WORKDIR /ui/grid-ui/

# Gives npm permission to run the prepare script in splinter-canopyjs as root
RUN npm config set unsafe-perm true && npm install && npm cache clean --force;

WORKDIR /

COPY ui/grid-ui/ /ui/grid-ui/
COPY justfile .
