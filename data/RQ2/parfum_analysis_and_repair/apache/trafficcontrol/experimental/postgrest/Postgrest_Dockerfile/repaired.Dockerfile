############################################################
# Dockerfile to build Traffic Ops PostgREST container images
# Based on Ubuntu 15.10
############################################################
#
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

# Example Build and Run:
# docker build --file Postgrest_Dockerfile --rm --tag traffic_ops_postgrest:0.1 .
# docker run --add-host="localhost:10.0.2.2" -p 9001:9001 --name my-postgrest --hostname my-postgrest --env USER=admin --env PASS=mypass --env URI=example.net:5432 --env DATABASE=mydb --detach traffic_ops_postgrest:0.1

# Based on Ubuntu because PostgREST binaries have issues on CentOS and would require building from source.
FROM ubuntu:15.10
MAINTAINER dev@trafficcontrol.apache.org

RUN apt-get install --no-install-recommends -y curl tar xz-utils postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN curl -f -LO https://github.com/begriffs/postgrest/releases/download/v0.3.1.1/postgrest-0.3.1.1-ubuntu.tar.xz
RUN tar xf postgrest-0.3.1.1-ubuntu.tar.xz && rm postgrest-0.3.1.1-ubuntu.tar.xz

EXPOSE 9001
ENTRYPOINT
