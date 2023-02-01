FROM ubuntu:focal

# explicitly set user/group IDs
RUN groupadd -r postgres --gid=999 && useradd -r -d /var/lib/postgresql -g postgres --uid=999 postgres

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common locales && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ENV DEBIAN_FRONTEND noninteractive

ENV PG_MAJOR 14

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN apt-get -o Acquire::AllowInsecureRepositories=true \
        -o Acquire::AllowDowngradeToInsecureRepositories=true update \
    && apt-get \
        -o Dpkg::Options::="--force-confdef" --no-install-recommends \
        -o Dpkg::Options::="--force-confold" \
        -o APT::Get::AllowUnauthenticated=tr \
        install -y postgresql-common \
        sudo \
        libpq-dev \
        python3-pip \
        python2.7-dev \
        python3.8-dev \
        postgresql-$PG_MAJOR \
        postgresql-contrib-$PG_MAJOR \
    && pip3 install --no-cache-dir tox && rm -rf /var/lib/apt/lists/*;

COPY ./ /dist

CMD ["/dist/run_test.sh"]
