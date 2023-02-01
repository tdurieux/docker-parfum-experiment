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

FROM x11vnc-xdummy

# This Dockerfile installs noVNC V0.6.2 which
# may work better on older browsers.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    curl ca-certificates && \
    # Download noVNC.
    NOVNC_VERSION=0.6.2 && \
    curl -f -sSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzv -C /usr/local/bin && \
    cd /usr/local/bin/noVNC-${NOVNC_VERSION} && \
    # Tweak noVNC configuration as the defaults point to 
    # websockify not the built-in x11vnc websocket support.
    sed -i "s/UI.initSetting('port', port)/UI.initSetting('port', 5900)/g" include/ui.js && \
    sed -i "s/UI.initSetting('path', 'websockify')/UI.initSetting('path', '')/g" include/ui.js && \
    # Renaming vnc.html to index.vnc seems necessary as the
    # x11vnc built-in web server seems to serve index.vnc
    # by default and there's no obvious configuration
    # option to change this.
    mv vnc.html index.vnc && \
    mv /usr/local/bin/noVNC-${NOVNC_VERSION} \
       /usr/local/bin/noVNC && \
    # Create script to start Xorg, jwm and x11vnc
    echo '#!/bin/bash\nXorg $DISPLAY -cc 4 &\nsleep 0.5\njwm &\nx11vnc -forever -usepw -httpdir /usr/local/bin/noVNC' > /usr/local/bin/startup && \
    chmod +x /usr/local/bin/startup && \
    # Tidy up
    apt-get clean && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/local/bin/startup"]

#-------------------------------------------------------------------------------
#
# To build the image
# docker build -t x11novnc-xdummy -f Dockerfile-0.6.2 .
#

