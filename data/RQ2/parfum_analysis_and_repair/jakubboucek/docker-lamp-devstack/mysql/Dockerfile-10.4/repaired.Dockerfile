FROM mariadb:10.4

LABEL maintainer="Jakub Bouček <pan@jakubboucek.cz>"
LABEL org.label-schema.name="MariaDB 10.4"
LABEL org.label-schema.vcs-url="https://github.com/jakubboucek/docker-lamp-devstack"

# Workdir during installation
WORKDIR /tmp

# OS binaries install && update critical binaries
RUN set -eux; \
    DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        nano \
        openssl \
        tzdata; \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*;

# Workdir after installation
WORKDIR /

COPY mysql-unicode.cnf /etc/mysql/conf.d/mysql-unicode.cnf
COPY mysql-max-packet.cnf /etc/mysql/conf.d/mysql-max-packet.cnf