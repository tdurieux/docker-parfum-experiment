ARG BUILD_FROM=erlang:21.3.6-alpine 
ARG RUN_FROM=alpine:3.9
FROM ${BUILD_FROM} AS builder

ARG QEMU_ARCH=x86_64
COPY tmp/qemu-$QEMU_ARCH-stati* /usr/bin/

RUN apk add git \
    curl \
    gcc \
    make \
    perl \
    ncurses-dev \
    openssl-dev \
    coreutils \
    bsd-compat-headers \
    libc-dev 

ARG EMQX_DEPS_DEFAULT_VSN=develop
ARG DEPLOY=cloud

RUN git clone -b ${EMQX_DEPS_DEFAULT_VSN} https://github.com/emqx/emqx-rel.git /emqx_rel \
    && cd /emqx_rel \
    && make distclean \
    && git checkout relx \
    && make

FROM $RUN_FROM

# Basic build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.docker.dockerfile="Dockerfile" \
    org.label-schema.license="GNU" \
    org.label-schema.name="emqx" \
    org.label-schema.version=${EMQX_DEPS_DEFAULT_VSN} \
    org.label-schema.description="EMQ (Erlang MQTT Broker) is a distributed, massively scalable, highly extensible MQTT messaging broker written in Erlang/OTP." \
    org.label-schema.url="http://emqx.io" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/emqx/emqx-docker" \
    maintainer="Raymond M Mouthaan <raymondmmouthaan@gmail.com>, Huang Rui <vowstar@gmail.com>, EMQ X Team <support@emqx.io>"

ARG QEMU_ARCH=x86_64
COPY docker-entrypoint.sh start.sh tmp/qemu-$QEMU_ARCH-stati* /usr/bin/
COPY --from=builder /emqx_rel/_rel/emqx /opt/emqx

RUN ln -s /opt/emqx/bin/* /usr/local/bin/ 
RUN apk add --no-cache ncurses-libs openssl

WORKDIR /opt/emqx

RUN adduser -D -u 1000 emqx

RUN chgrp -Rf emqx /opt/emqx && chmod -Rf g+w /opt/emqx \
      && chown -Rf emqx /opt/emqx

USER emqx

VOLUME ["/opt/emqx/log", "/opt/emqx/data", "/opt/emqx/lib", "/opt/emqx/etc"]

# emqx will occupy these port:
# - 1883 port for MQTT
# - 8080 for mgmt API
# - 8083 for WebSocket/HTTP
# - 8084 for WSS/HTTPS
# - 8883 port for MQTT(SSL)
# - 11883 port for internal MQTT/TCP
# - 18083 for dashboard
# - 4369 for port mapping
# - 5369 for gen_rpc port mapping
# - 6369 for distributed node
EXPOSE 1883 8080 8083 8084 8883 11883 18083 4369 5369 6369

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

CMD ["/usr/bin/start.sh"]