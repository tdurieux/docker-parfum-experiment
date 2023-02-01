# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM tinkerpop/gremlin-server:GREMLIN_SERVER_VERSION

USER root
RUN mkdir -p /opt
WORKDIR /opt
COPY gremlin-server/src/test /opt/test/
COPY docker/gremlin-server/docker-entrypoint.sh docker/gremlin-server/*.yaml /opt/
RUN chown -R gremlin:gremlin /opt
RUN chmod 755 /opt/docker-entrypoint.sh
USER gremlin

EXPOSE 45940

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
CMD ["conf/gremlin-server-integration.yaml"]