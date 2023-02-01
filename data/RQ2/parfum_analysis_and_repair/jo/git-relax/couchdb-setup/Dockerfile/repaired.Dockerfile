FROM ubuntu:focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends install -y curl && rm -rf /var/lib/apt/lists/*;

COPY ./couchdb-setup.sh /usr/local/bin/couchdb-setup

CMD ["/usr/local/bin/couchdb-setup", "http://admin:admin@couchdb:5984"]
