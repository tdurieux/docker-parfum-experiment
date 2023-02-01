FROM ubuntu:focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends install -y \
  git-core \
  curl \
  jq && rm -rf /var/lib/apt/lists/*;

COPY ./ /opt/couchdb-worker/
RUN chown -R www-data:www-data /opt/couchdb-worker

USER www-data

CMD [ "/opt/couchdb-worker/couchdb-worker.sh", "http://admin:admin@couchdb:5984", "/var/www/git" ]
