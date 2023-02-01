FROM debian:stretch

RUN apt-get update && apt-get -y --no-install-recommends install pbuilder && rm -rf /var/lib/apt/lists/*;

COPY base.tgz /var/cache/pbuilder/
