# Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# *NOTE* we have to limit our number of layers heres because in presubmits there
# is no overlay fs and we will run out of space quickly

################# BUILDER ######################
# This image is not exactly minimal. CSI drivers require a number
# of utils to create and manage volumes
# Adding this as a variant here to ensure we are keeping it up to date

ARG BASE_IMAGE
ARG BUILDER_IMAGE
ARG BUILT_BUILDER_IMAGE
FROM ${BUILDER_IMAGE} as builder

# Copy scripts in every variant since we do not rebuild the base
# every time these scripts change. This ensures whenever a variant is
# built it has the latest scripts in the builder
COPY scripts/ /usr/bin

RUN set -x && \
    # manually "install" systemd to avoid installing the entire dep tree
    clean_install systemd true true && \
    # some of the install scriptlets need coreutils but the dep ordering
    # doesnt reflect, install manually to make sure its first