# Copyright © 2019-2020 The OpenEBS Authors
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

FROM ubuntu:18.04

ENV OPERATOR=/usr/local/bin/jiva-operator \
    USER_UID=1001 \
    USER_NAME=jiva-operator

ARG DBUILD_DATE
ARG DBUILD_REPO_URL
ARG DBUILD_SITE_URL

# install operator binary