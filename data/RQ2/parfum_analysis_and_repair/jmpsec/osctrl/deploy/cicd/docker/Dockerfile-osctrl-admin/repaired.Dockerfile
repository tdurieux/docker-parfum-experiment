FROM ubuntu:20.04

ARG COMPONENT=admin
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
    mkdir -p /opt/osctrl/tmpl_admin/components && \
    mkdir -p /opt/osctrl/static && \
    mkdir -p /opt/osctrl/data && \
    chown osctrl-${COMPONENT}:osctrl-${COMPONENT} -R /opt/osctrl
COPY osctrl-${COMPONENT}-${GOOS}-${GOARCH}.bin /opt/osctrl/bin/osctrl-${COMPONENT}
RUN chmod 755 /opt/osctrl/bin/osctrl-${COMPONENT}

### Copy osctrl-admin web templates ###
USER osctrl-${COMPONENT}
COPY admin/templates/ /opt/osctrl/tmpl_admin
COPY admin/static/ /opt/osctrl/static
COPY deploy/osquery/data/*.json /opt/osctrl/data/

WORKDIR /opt/osctrl
EXPOSE 9001/tcp
CMD ["/opt/osctrl/bin/osctrl-admin"]