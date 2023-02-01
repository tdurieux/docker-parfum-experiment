FROM postgres:14

RUN export PATH=/usr/lib/postgresql/14/bin:$PATH
RUN apt-get update
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install postgresql-server-dev-14 && rm -rf /var/lib/apt/lists/*;

WORKDIR "/home/postgres"
RUN git clone https://github.com/eulerto/wal2json -b master --single-branch

WORKDIR "/home/postgres/wal2json"
RUN make
RUN make install
RUN rm -rf /home/postgre/swal2json

COPY ./init-db.sh /docker-entrypoint-initdb.d/
COPY ./init-es.sql /docker-entrypoint-initdb.d/
