FROM ubuntu:16.04

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install ca-certificates curl xz-utils unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;
ARG node_ver=10
ENV node_var ${node_ver}
RUN curl -f -sL https://deb.nodesource.com/setup_${node_ver}.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# set up user per guide
WORKDIR /home
RUN mkdir snode && useradd snode && chown snode snode && usermod -aG sudo snode
WORKDIR /home/snode

# install local dev version
ADD https://github.com/loki-project/loki/releases/download/v3.0.6/loki-linux-x64-v3.0.6.tar.xz .
RUN tar xvf loki-linux-x64-v3.0.6.tar.xz && ln -snf loki-linux-x64-v3.0.6 loki && rm loki-linux-x64-v3.0.6.tar.xz

# set up systemd
RUN echo $'[Unit]\n\
Description=lokid service node\n\
After=network-online.target\n\
\n\
[Service]\n\
Type=simple\n\
User=snode\n\
ExecStart=/home/snode/loki/lokid --non-interactive --service-node\n\
Restart=always\n\
RestartSec=30s\n\
\n\
[Install]\n\
WantedBy=multi-user.target\n\' > /etc/systemd/system/lokid.service
#RUN systemctl daemon-reload && systemctl enable lokid.service && systemctl start lokid.service && sleep 30 && loki/lokid status

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

# configure npm
COPY package.json .

# install the CLI utility
RUN npm i -g && npm cache clean --force;

