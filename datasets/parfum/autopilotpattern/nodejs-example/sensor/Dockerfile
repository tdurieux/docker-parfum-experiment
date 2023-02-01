FROM node:8-alpine

RUN apk update && \
    apk add curl && \
    rm -rf /var/cache/apk/*

RUN export CONSUL_VERSION=0.7.0 \
    && export CONSUL_CHECKSUM=b350591af10d7d23514ebaa0565638539900cdb3aaa048f077217c4c46653dd8 \
    && curl --retry 7 --fail -vo /tmp/consul.zip "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip" \
    && echo "${CONSUL_CHECKSUM}  /tmp/consul.zip" | sha256sum -c \
    && unzip /tmp/consul -d /usr/local/bin \
    && rm /tmp/consul.zip \
    && mkdir /config

# Install ContainerPilot
ENV CONTAINERPILOT_VERSION 3.4.3
RUN export CP_SHA1=e8258ed166bcb3de3e06638936dcc2cae32c7c58 \
    && curl -Lso /tmp/containerpilot.tar.gz \
         "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VERSION}/containerpilot-${CONTAINERPILOT_VERSION}.tar.gz" \
    && echo "${CP_SHA1}  /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /bin \
    && rm /tmp/containerpilot.tar.gz

# COPY ContainerPilot configuration
ENV CONTAINERPILOT_PATH=/etc/containerpilot.json5
COPY containerpilot.json5 ${CONTAINERPILOT_PATH}
ENV CONTAINERPILOT=${CONTAINERPILOT_PATH}

# Install our application
RUN mkdir -p /opt/app/lib
COPY package.json /opt/app/
COPY lib/* /opt/app/lib/
RUN cd /opt/app && npm install

CMD ["/bin/containerpilot"]
