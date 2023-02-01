# PostgreSQL 9.2

FROM fgrehm/ventriloquist-base

RUN wget --quiet -O - https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt sid-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y postgresql-9.2 postgresql-contrib-9.2 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    apt-get autoremove && \
    apt-get clean

ADD config /
RUN /bin/prepare-postgres vagrant vagrant

EXPOSE  5432
CMD     ["/bin/start-postgres"]
