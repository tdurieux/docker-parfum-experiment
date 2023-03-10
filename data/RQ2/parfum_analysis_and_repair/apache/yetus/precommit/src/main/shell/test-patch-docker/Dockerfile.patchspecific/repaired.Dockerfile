# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG baseimagename
# hadolint ignore=DL3006
FROM ${baseimagename}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG USER_NAME
ARG GROUP_ID
ARG USER_ID
ARG DOCKER_SOCKET_GID
ARG DOCKER_WORK_DIR

RUN groupadd --non-unique -g "${GROUP_ID}" "${USER_NAME}" || true
# hadolint ignore=DL3059
RUN useradd -l -g "${GROUP_ID}" -u "${USER_ID}" -m "${USER_NAME}" || true

# docker socket handling.  unless /etc/group is mounted, we have to do this.
# hadolint ignore=DL3059
RUN if [ "${DOCKER_SOCKET_GID}" != -1 ]; then (groupadd --non-unique --gid ${DOCKER_SOCKET_GID} dockersock && adduser "${USER_NAME}" dockersock ) || true; fi

# hadolint ignore=DL3059
RUN mkdir -p ${DOCKER_WORK_DIR}/extras \
    && chmod a+rwx ${DOCKER_WORK_DIR}/extras
COPY user_params.txt ${DOCKER_WORK_DIR}/user_params.txt
COPY launch-test-patch.sh /launch-test-patch.sh
RUN chown -R "${USER_NAME}":"${GROUP_ID}" ${DOCKER_WORK_DIR} /launch-test-patch.sh || true
# hadolint ignore=DL3059
RUN chmod a+rx /launch-test-patch.sh
# hadolint ignore=DL3059