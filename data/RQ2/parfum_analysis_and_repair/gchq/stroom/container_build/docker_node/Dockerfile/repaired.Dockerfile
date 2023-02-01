#**********************************************************************
# Copyright 2018 Crown Copyright
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
#**********************************************************************

FROM node:17.4.0-alpine3.14
WORKDIR /builder

# Pass in the uid/gid of the running user so we can use the same user id
# in the container so that any files created can be read outside the 
# container.
ARG USER_ID
ARG GROUP_ID    

# Pass in the abs path to the repo root on the docker host
ARG HOST_REPO_DIR    

# Set the user ID into an env var so the entrypoint can see it
ENV CONTAINER_USER_ID=$USER_ID

# Set tini as entrypoint
ENTRYPOINT ["/sbin/tini", "--", "/builder/docker-entrypoint.sh"]

CMD id

# We need to run as the same user/group ID in the container as on the host
# so that any files created have the right perms and the container can
# access all the files in the shared bind mount.
# We don't know if the uid/gid on the host are in used in the container
# or not so we need to test for their existence and create a user and/or group
# as needed.
# Lots of echo to help debug in travis