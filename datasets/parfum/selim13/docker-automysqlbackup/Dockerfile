# Build
FROM golang:1.12 as builder

RUN go get -d -v github.com/odise/go-cron \
    && cd /go/src/github.com/robfig/cron \
    && git checkout tags/v1.2.0 \
    && cd /go/src/github.com/odise/go-cron \
    && CGO_ENABLED=0 GOOS=linux go build -o go-cron bin/go-cron.go

# Package
FROM debian:bullseye-slim
LABEL maintainer="selim013@gmail.com"

RUN apt-get update && apt-get install -y --no-install-recommends gnupg dirmngr bzip2 && rm -rf /var/lib/apt/lists/*

# add gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
ENV GOSU_VERSION 1.14
RUN set -eux; \
    key='B42F6819007F00F88E364FD4036A9C25BF357DD4'; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget; \
    rm -rf /var/lib/apt/lists/*; \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    (gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" \
    || gpg --batch --keyserver keys.openpgp.org --recv-keys "$key" \
    || gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key"); \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    chmod +x /usr/local/bin/gosu; \
    gosu --version; \
    gosu nobody true

RUN set -uex; \
    # gpg: key 3A79BD29: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
    key='859BE8D7C586F538430B19C2467B942D3A79BD29'; \
    export GNUPGHOME="$(mktemp -d)"; \
    (gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" \
    || gpg --batch --keyserver keys.openpgp.org --recv-keys "$key" \
    || gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key"); \
    gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME"; \
    apt-key list > /dev/null

ENV MYSQL_MAJOR 8.0

RUN echo "deb http://repo.mysql.com/apt/debian/ bullseye mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

RUN apt-get update \
    && apt-get install -y mysql-community-client-core \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/default /etc/mysql

COPY --from=builder /go/src/github.com/odise/go-cron/go-cron /usr/local/bin/
COPY automysqlbackup start.sh /usr/local/bin/
COPY my.cnf /etc/mysql/

RUN chmod +x /usr/local/bin/go-cron \
    /usr/local/bin/automysqlbackup \
    /usr/local/bin/start.sh

RUN groupadd --system automysqlbackup --gid=1000 && useradd --system --uid=1000 --gid automysqlbackup automysqlbackup

WORKDIR /backup

ENV USERNAME=           \
    PASSWORD=           \
    DBHOST=localhost    \
    DBNAMES=all         \
    DBPORT=3306         \
    BACKUPDIR="/backup" \
    MDBNAMES=           \
    DBEXCLUDE=""        \
    IGNORE_TABLES=""    \
    CREATE_DATABASE=yes \
    SEPDIR=yes          \
    DOWEEKLY=6          \
    COMP=gzip           \
    COMMCOMP=no         \
    LATEST=no           \
    MAX_ALLOWED_PACKET= \
    SOCKET=             \
    PREBACKUP=          \
    POSTBACKUP=         \
    ROUTINES=yes        \
    EXTRA_OPTS=         \
    CRON_SCHEDULE=      \
    USER_ID=1           \
    GROUP_ID=

CMD ["start.sh"]
