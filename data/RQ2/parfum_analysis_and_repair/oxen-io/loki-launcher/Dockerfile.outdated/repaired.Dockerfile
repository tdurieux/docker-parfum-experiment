FROM ubuntu:16.04

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install ca-certificates curl xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;
ARG node_ver=10
ENV node_var ${node_ver}
RUN curl -f -sL https://deb.nodesource.com/setup_${node_ver}.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# install local dev version
WORKDIR /usr/src/app

#ADD *.js .
COPY config.js .
COPY daemon.js .
COPY get-uid.js .
COPY index.js .
COPY ini.js .
COPY lets_tcp.js .
COPY lib.js .
COPY lib.networkTest.js .
COPY modes/check-systemd.js modes/
COPY modes/bw-test.js modes/
COPY modes/client.js modes/
COPY modes/download-binaries.js modes/
COPY modes/fix-perms.js modes/
COPY modes/prequal.js modes/
COPY modes/status.js modes/
COPY lokinet.js .
COPY start.js .
COPY uid.js .
COPY web_api.js .

# place new package
COPY package.json .

# install the old CLI utility (change to 0.0.2 after 0.0.3 and then hopefully leave for a bit)
RUN npm i -g loki-launcher@0.0.1 && npm cache clean --force;
