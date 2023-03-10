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

FROM linuxmint-cinnamon-vgl:19.3

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    x2goserver x2goserver-xsession && \
    # Stop openssh/xorg bug clobbering LD_PRELOAD
    # https://bugs.launchpad.net/ubuntu/+source/openssh/+bug/47958
    sed -i 's/use-ssh-agent/no-use-ssh-agent/' /etc/X11/Xsession.options && rm -rf /var/lib/apt/lists/*;

#-------------------------------------------------------------------------------
# Example usage
#
# Build the image
# docker build -t linuxmint-cinnamon-x2go:19.3 .

