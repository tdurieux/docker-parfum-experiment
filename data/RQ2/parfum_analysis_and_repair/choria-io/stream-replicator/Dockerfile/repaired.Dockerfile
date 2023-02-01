FROM almalinux:8

ARG REPO="https://yum.eu.choria.io/release/el/release.repo"

WORKDIR /
ENTRYPOINT ["/usr/sbin/stream-replicator"]

RUN curl -f -s "${REPO}" > /etc/yum.repos.d/choria.repo && \
    yum -y install stream-replicator nc procps-ng openssl && \
    yum -y clean all && rm -rf /var/cache/yum

USER nobody
