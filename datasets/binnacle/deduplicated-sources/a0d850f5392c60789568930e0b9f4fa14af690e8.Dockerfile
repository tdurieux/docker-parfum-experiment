FROM registry.access.redhat.com/ubi7/ubi

LABEL name="Percona Server for MongoDB" \
      release="3.6" \
      vendor="Percona" \
      summary="Percona Server for MongoDB is our free and open-source drop-in replacement for MongoDB Community Edition" \
      description="Percona Server for MongoDB is our free and open-source drop-in replacement for MongoDB Community Edition. It offers all the features and benefits of MongoDB Community Edition, plus additional enterprise-grade functionality." \
      maintainer="Percona Development <info@percona.com>"

# check repository package signature in secure way
RUN export GNUPGHOME="$(mktemp -d)" \
        && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 430BDF5C56E7C94E848EE60C1C4CBDCDCD2EFD2A \
        && gpg --export --armor 430BDF5C56E7C94E848EE60C1C4CBDCDCD2EFD2A > ${GNUPGHOME}/RPM-GPG-KEY-Percona \
        && rpmkeys --import ${GNUPGHOME}/RPM-GPG-KEY-Percona \
        && curl -L -o /tmp/percona-release.rpm https://repo.percona.com/percona/yum/percona-release-1.0-9.noarch.rpm \
        && rpmkeys --checksig /tmp/percona-release.rpm \
        && yum install -y --disableplugin=subscription-manager /tmp/percona-release.rpm \
        && rm -rf "$GNUPGHOME" /tmp/percona-release.rpm \
        && rpm --import /etc/pki/rpm-gpg/PERCONA-PACKAGING-KEY

# the numeric UID is needed for OpenShift
RUN useradd -u 1001 -r -g 0 -s /sbin/nologin \
            -c "Default Application User" mongodb

# we need licenses from docs
RUN sed -i '/nodocs/d' /etc/yum.conf

ENV PERCONA_VERSION 3.6.12-3.2.el7
ENV K8S_TOOLS_VERSION 0.4.2

RUN yum install -y --disableplugin=subscription-manager \
        http://epel.mirror.omnilance.com/7/x86_64/Packages/o/oniguruma-5.9.5-3.el7.x86_64.rpm \
        http://epel.mirror.omnilance.com/7/x86_64/Packages/j/jq-1.5-1.el7.x86_64.rpm
RUN yum update -y --disableplugin=subscription-manager \
        && yum install -y --disableplugin=subscription-manager \
                Percona-Server-MongoDB-36-server-${PERCONA_VERSION} \
                Percona-Server-MongoDB-36-mongos-${PERCONA_VERSION} \
                Percona-Server-MongoDB-36-tools-${PERCONA_VERSION} \
                Percona-Server-MongoDB-36-shell-${PERCONA_VERSION} \
                curl \
        && yum clean all \
        && rm -rf /var/cache/yum /data/db  && mkdir -p /data/db \
        && chown -R 1001:0 /data/db

COPY LICENSE /licenses/LICENSE.Dockerfile
RUN cp /usr/share/doc/Percona-Server-MongoDB-36-server-$(echo ${PERCONA_VERSION} | cut -d - -f 1)/GNU-AGPL-3.0 /licenses/LICENSE.Percona-Server-for-MongoDB

RUN curl -fSL https://github.com/percona/mongodb-orchestration-tools/releases/download/${K8S_TOOLS_VERSION}/k8s-mongodb-initiator -o /usr/local/bin/k8s-mongodb-initiator \
    && curl -fSL  https://github.com/percona/mongodb-orchestration-tools/releases/download/${K8S_TOOLS_VERSION}/mongodb-healthcheck -o /usr/local/bin/mongodb-healthcheck \
    && chmod 0755 /usr/local/bin/k8s-mongodb-initiator /usr/local/bin/mongodb-healthcheck

VOLUME ["/data/db"]

COPY build/ps-entry.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 27017

USER 1001

CMD ["mongod"]
