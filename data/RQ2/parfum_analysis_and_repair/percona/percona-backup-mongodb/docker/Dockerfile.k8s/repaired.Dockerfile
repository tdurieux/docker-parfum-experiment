FROM golang:1.18
RUN apt-get update -y && apt-get install --no-install-recommends -y libkrb5-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt/pbm
COPY . .
RUN make install

FROM registry.access.redhat.com/ubi7/ubi-minimal
RUN microdnf update && microdnf clean all

LABEL name="Percona Backup for MongoDB" \
    vendor="Percona" \
    summary="Percona Backup for MongoDB" \
    description="Percona Backup for MongoDB is a distributed, \
    low-impact solution for achieving consistent backups of MongoDB Sharded Clusters and Replica Sets." \
    org.opencontainers.image.authors="info@percona.com"

COPY LICENSE /licenses/

# kubectl needed for Percona Operator for PSMDB
ENV KUBECTL_VERSION=v1.19.12
ENV KUBECTL_MD5SUM=7c6a25afdec07da2cf1e1c1caf9e4381
RUN curl -Lf -o /usr/bin/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x /usr/bin/kubectl \
    && echo "${KUBECTL_MD5SUM} /usr/bin/kubectl" | md5sum -c - \
    && curl -Lf  -o /licenses/LICENSE.kubectl \
    https://raw.githubusercontent.com/kubernetes/kubectl/master/LICENSE

# check repository package signature in secure way
RUN set -ex; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 430BDF5C56E7C94E848EE60C1C4CBDCDCD2EFD2A; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 6341AB2753D78A78A7C27BB124C6A8A7F4A80EB5; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 91E97D7C4A5E96F17F3E888F6A2FAEA2352C64E5; \
    \
    gpg --batch --export --armor 430BDF5C56E7C94E848EE60C1C4CBDCDCD2EFD2A > ${GNUPGHOME}/RPM-GPG-KEY-Percona; \
    gpg --batch --export --armor 6341AB2753D78A78A7C27BB124C6A8A7F4A80EB5 > ${GNUPGHOME}/RPM-GPG-KEY-CentOS-7; \
    gpg --batch --export --armor 91E97D7C4A5E96F17F3E888F6A2FAEA2352C64E5 > ${GNUPGHOME}/RPM-GPG-KEY-EPEL-7; \
    rpmkeys --import ${GNUPGHOME}/RPM-GPG-KEY-Percona ${GNUPGHOME}/RPM-GPG-KEY-CentOS-7 ${GNUPGHOME}/RPM-GPG-KEY-EPEL-7; \
    \
    curl -Lf -o /tmp/percona-release.rpm https://repo.percona.com/yum/percona-release-latest.noarch.rpm; \
    rpmkeys --checksig /tmp/percona-release.rpm; \
    rpm -i /tmp/percona-release.rpm; \
    rm -rf "$GNUPGHOME" /tmp/percona-release.rpm; \
    rpm --import /etc/pki/rpm-gpg/PERCONA-PACKAGING-KEY; \
    percona-release enable psmdb-42 release

RUN set -ex; \
    curl -Lf -o /tmp/jq.rpm https://download.fedoraproject.org/pub/epel/7/x86_64/Packages/j/jq-1.6-2.el7.x86_64.rpm; \
    curl -Lf -o /tmp/oniguruma.rpm https://download.fedoraproject.org/pub/epel/7/x86_64/Packages/o/oniguruma-6.8.2-1.el7.x86_64.rpm; \
    rpmkeys --checksig /tmp/jq.rpm /tmp/oniguruma.rpm; \
    \
    rpm -i /tmp/jq.rpm /tmp/oniguruma.rpm; \
    rm -rf /tmp/jq.rpm /tmp/oniguruma.rpm

RUN microdnf install percona-server-mongodb-shell

COPY --from=0 /go/bin/pbm /go/bin/pbm-agent /go/bin/pbm-speed-test /usr/local/bin/
COPY ./docker/start-agent.sh /start-agent.sh

USER nobody

ENTRYPOINT ["/start-agent.sh"]
CMD ["pbm-agent"]
