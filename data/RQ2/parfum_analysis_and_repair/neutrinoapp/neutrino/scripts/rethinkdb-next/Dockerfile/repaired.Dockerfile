FROM ubuntu:14.04

WORKDIR /rethink

COPY scripts/rethinkdb-next/rethinkdb.deb rethinkdb.deb

RUN apt-get update -y && apt-get install --no-install-recommends -y libcurl3 libprotobuf8 && rm -rf /var/lib/apt/lists/*;
RUN dpkg -i rethinkdb.deb

CMD rethinkdb --bind all -d /data/rethinkdb_data
