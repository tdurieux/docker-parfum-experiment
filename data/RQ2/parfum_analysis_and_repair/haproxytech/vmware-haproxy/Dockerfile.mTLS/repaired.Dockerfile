# Copyright 2020 HAProxy Technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

################################################################################
##                               BUILD ARGS                                   ##
################################################################################
# The golang image is used to build the DataPlane API.
ARG GOLANG_IMAGE=golang:1.14.1


################################################################################
##                        BUILD DATAPLANE API STAGE                           ##
################################################################################
FROM ${GOLANG_IMAGE} as builder

# The Git repo used to build the DataPlane API binary.
ARG DATAPLANEAPI_URL
ENV DATAPLANEAPI_URL ${DATAPLANEAPI_URL:-https://github.com/haproxytech/dataplaneapi.git}

# The Git ref used to build the DataPlane API binary.
ARG DATAPLANEAPI_REF
ENV DATAPLANEAPI_REF ${DATAPLANEAPI_REF:-494f9b817842d9e28f7b75c4c32a59395794636c}

WORKDIR /

RUN git clone "${DATAPLANEAPI_URL}" && \
    cd dataplaneapi && \
    git checkout -b build-me "${DATAPLANEAPI_REF}" && \
    make build


################################################################################
##                               MAIN STAGE                                   ##
################################################################################