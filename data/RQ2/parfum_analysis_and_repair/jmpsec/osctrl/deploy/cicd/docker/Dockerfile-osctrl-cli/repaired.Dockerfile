FROM ubuntu:20.04

ARG COMPONENT=cli
ARG GOOS=linux
ARG GOARCH=amd64

# Install software
RUN apt-get update -y -q && \
    apt-get install --no-install-recommends curl -y && \
    rm -rf /var/lib/apt/lists/*

# Install/Setup osctrl
RUN useradd -ms /usr/sbin/nologin osctrl-${COMPONENT}
RUN mkdir -p /opt/osctrl/bin && \
    mkdir -p /opt/osctrl/config && \
    chown osctrl-${COMPONENT}:osctrl-${COMPONENT} -R /opt/osctrl

COPY osctrl-${COMPONENT}-${GOOS}-${GOARCH}.bin /opt/osctrl/bin/osctrl-${COMPONENT}
RUN chmod 755 /opt/osctrl/bin/osctrl-${COMPONENT}

COPY deploy/docker/conf/osctrl/db.json /opt/osctrl/config/db.json

COPY deploy/docker/conf/osctrl/cli/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

USER osctrl-${COMPONENT}
WORKDIR /opt/osctrl
ENTRYPOINT [ "/entrypoint.sh" ]
