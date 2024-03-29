#
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
#

FROM debian:stretch-slim

# Install pulseaudio
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages used
    apt-get install -y --no-install-recommends \
    pulseaudio pulseaudio-module-bluetooth \
    pulseaudio-utils && \
	rm -rf /var/lib/apt/lists/* && \
    sed -i "s/; exit-idle-time = 20/exit-idle-time = -1/g" \
        /etc/pulse/daemon.conf && \
    sed -i "s/#load-module module-native-protocol-tcp/load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1\;172.17.0.0\/16\;192.168.0.0\/16 port=4714/g" /etc/pulse/default.pa && \
    sed -i "s/load-module module-console-kit/#load-module module-console-kit/g" /etc/pulse/default.pa && \
    # Add user "pa" so we can run pulseaudio as non privileged user below.
    groupadd -r -g 1000 pa && \
    useradd -u 1000 -r -g pa -G audio pa && \
    mkdir /home/pa/ && \
    chown -R pa:pa /home/pa

COPY ./set-a2dp-sink.sh /src/set-a2dp-sink.sh

# Run pulseaudio daemon as the non privileged user pa.
USER pa

CMD pulseaudio -v 2>&1 | /src/set-a2dp-sink.sh

#-------------------------------------------------------------------------------
# Example usage
# 
# Build the image
# docker build -t pulseaudio -f Dockerfile-pulseaudio .