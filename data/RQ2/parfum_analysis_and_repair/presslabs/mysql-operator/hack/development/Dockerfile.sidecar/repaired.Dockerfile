# NOTE: this image is for development only
# Copy the mysql-operator-sidecar into its own image


###############################################################################
#  Build rclone
###############################################################################

FROM debian:stretch as rclone

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gnupg ca-certificates wget unzip && rm -rf /var/lib/apt/lists/*;

COPY hack/docker/rclone.gpg /root/rclone.gpg
RUN gpg --batch --import /root/rclone.gpg

ENV RCLONE_VERSION=1.57.0

RUN wget -nv https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.zip \
    && wget -nv https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/SHA256SUMS \
    && gpg --batch --verify --output=- SHA256SUMS > sums \
    && sha256sum -c --ignore-missing sums \
    && unzip rclone-*-linux-amd64.zip \
    && mv rclone-*-linux-amd64/rclone /usr/local/bin/ \
    && chmod 755 /usr/local/bin/rclone


###############################################################################
#  Docker image for sidecar containers
###############################################################################

FROM debian:buster-slim as sidecar

RUN groupadd -g 999 mysql
RUN useradd -u 999 -r -g 999 -s /sbin/nologin \
    -c "Default Application User" mysql

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https ca-certificates pigz wget \
    && rm -rf /var/lib/apt/lists/*

COPY hack/docker/percona.gpg /etc/apt/trusted.gpg.d/percona.gpg
RUN echo 'deb https://repo.percona.com/apt buster main' > /etc/apt/sources.list.d/percona.list

ARG XTRABACKUP_PKG=percona-xtrabackup-80
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        percona-toolkit ${XTRABACKUP_PKG} unzip default-mysql-client && rm -rf /var/lib/apt/lists/*;

USER mysql

# set expiration time for dev images
# https://support.coreos.com/hc/en-us/articles/115001384693-Tag-Expiration
LABEL quay.expires-after=2d

COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/rclone
COPY ./hack/docker/sidecar-entrypoint.sh /usr/local/bin/sidecar-entrypoint.sh
COPY ./bin/mysql-operator-sidecar_linux_amd64 /usr/local/bin/mysql-operator-sidecar

ENTRYPOINT ["/usr/local/bin/sidecar-entrypoint.sh"]
