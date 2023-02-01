#------------------------------------------------------------------------------
# FILE:         Dockerfile
# CONTRIBUTOR:  Marcus Bowyer
# COPYRIGHT:    Copyright (c) 2005-2022 by neonFORGE LLC.  All rights reserved.
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

# Base cassandra-STREAMING image.
#
# ARGUMENTS:
#
#   VERSION         - The source cassandra image version (e.g. "3.11")

ARG         VERSION
FROM        cassandra:${VERSION}
MAINTAINER  marcus@neonforge.com
STOPSIGNAL  SIGTERM

COPY ./cassandra-env.sh /etc/cassandra/cassandra-env.sh

RUN chmod a+x /etc/cassandra/cassandra-env.sh
