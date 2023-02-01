#
# Copyright (c) 2019-present Sonatype, Inc.
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

FROM quay.io/centos/centos:stream

WORKDIR /ahab-docker

RUN dnf upgrade -y && dnf check-update

COPY ahab .

# Spit out these just for easier debugging
RUN dnf list installed

# Deprecated
RUN dnf list installed | ./ahab chase --os fedora
# New way
RUN dnf list installed | ./ahab chase --package-manager dnf
