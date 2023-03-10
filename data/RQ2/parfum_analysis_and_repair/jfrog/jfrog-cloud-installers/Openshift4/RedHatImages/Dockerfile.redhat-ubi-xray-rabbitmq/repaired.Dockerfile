FROM registry.access.redhat.com/ubi8

LABEL name="JFrog Xray Rabbit MQ" \
      description="JFrog Rabbit MQ image based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Rabbit MQ (Red Hat UBI)" \
      com.jfrog.license_terms="https://jfrog.com/xray/eula/"


ARG RABBITMQ_AUTOCLUSTER_VERSION=0.10.0
ARG RABBITMQ_VERSION=3.8.8

LABEL io.k8s.description="Lightweight open source message broker" \
    io.k8s.display-name="RabbitMQ" \
    io.openshift.expose-services="4369:epmd, 5671:amqp, 5672:amqp, 15672:http" \
    io.openshift.tags="rabbitmq"

ENV GPG_KEY="0A9AF2115F4687BD29803A206B73A36E6026DFCA" \
    HOME=/var/lib/rabbitmq \
    RABBITMQ_HOME=/opt/rabbitmq \
    RABBITMQ_LOGS=- \
    RABBITMQ_SASL_LOGS=- \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.:en \
    LC_ALL=en_US.UTF-8


# FIX THE LOCALE ISSUE
RUN yum install -y --disableplugin=subscription-manager -y openssl curl ca-certificates fontconfig gzip glibc-langpack-en tar xz \
    && yum  -y --disableplugin=subscription-manager update; rm -rf /var/cache/yum yum --disableplugin=subscription-manager clean all

RUN set -xe && \
    curl -f -LO https://github.com/rabbitmq/erlang-rpm/releases/download/v23.0/erlang-23.0-1.el8.x86_64.rpm && \
    rpm -Uvh ./erlang-23.0-1.el8.x86_64.rpm && \
    rm *.rpm && \
    curl -f -Lo rabbitmq-server.tar.xz https://github.com/rabbitmq/rabbitmq-server/releases/download/v${RABBITMQ_VERSION}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz && \
    curl -f -Lo rabbitmq-server.tar.xz.asc https://github.com/rabbitmq/rabbitmq-server/releases/download/v${RABBITMQ_VERSION}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz.asc && \
    export GNUPGHOME="$(mktemp -d)" && \
    env | grep GNUPG && \
    gpg --batch --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys "$GPG_KEY" && \
    gpg --batch --verify rabbitmq-server.tar.xz.asc rabbitmq-server.tar.xz && \
    rm -rf "$GNUPGHOME" && \
    mkdir -p "$RABBITMQ_HOME" && \
    tar \
      --extract \
      --verbose \
      --file rabbitmq-server.tar.xz \
      --directory "$RABBITMQ_HOME" \
      --strip-components 1 && \
    rm rabbitmq-server.tar.xz* && \
    grep -qE '^SYS_PREFIX=\$\{RABBITMQ_HOME\}$' "$RABBITMQ_HOME/sbin/rabbitmq-defaults" && \
    sed -ri 's!^(SYS_PREFIX=).*$!\1!' "$RABBITMQ_HOME/sbin/rabbitmq-defaults" && \
    grep -qE '^SYS_PREFIX=$' "$RABBITMQ_HOME/sbin/rabbitmq-defaults" && \
    groupadd --system rabbitmq && \
    adduser -u 1000721001 -r -c "RabbitMQ User" -d /var/lib/rabbitmq -g rabbitmq rabbitmq && \
    mkdir -p /var/lib/rabbitmq /etc/rabbitmq && \
    chown -R 1000721001:1000721001 /var/lib/rabbitmq /etc/rabbitmq ${RABBITMQ_HOME}/plugins && \
    chmod -R g=u /var/lib/rabbitmq /etc/rabbitmq && \
    rm -rf /var/lib/rabbitmq/.erlang.cookie && \
    ln -sf "$RABBITMQ_HOME/plugins" /plugins && \
    INSTALL_PKGS="wget procps net-tools hostname" && \
    yum install -y $INSTALL_PKGS && \
    rm -rf /var/cache/yum

COPY xray-rabbitmq-docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN mkdir -p /licenses && chmod 0777 /licenses && cp -rf /opt/rabbitmq/LICENSE /licenses/LICENSE

USER 1000721001
ENV PATH=$RABBITMQ_HOME/sbin:$PATH
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 4369 5672 15672
CMD ["rabbitmq-server"]