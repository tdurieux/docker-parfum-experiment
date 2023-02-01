#
# Copyright 2018 SAS Institute Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# BUILD:
#   docker build --file Dockerfile --build-arg BASEIMAGE=viya-single-container --build-arg BASETAG=latest . --tag svc-access-hadoop
#
# RUN:
#   docker run --detach --rm --publish-all --name svc-access-hadoop --hostname svc-access-hadoop svc-access-hadoop
#

ARG BASEIMAGE=viya-single-container
ARG BASETAG=latest

FROM $BASEIMAGE:$BASETAG

USER root

COPY hadoop/config/ /hadoop/config/
COPY hadoop/jars/ /hadoop/jars/
