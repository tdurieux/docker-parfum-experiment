FROM buildpack-deps:jessie

RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt-key advanced --keyserver keys.gnupg.net --recv-keys 90E9F83F22250DD7

RUN echo "deb https://releases.wikimedia.org/debian jessie-mediawiki main" | tee /etc/apt/sources.list.d/parsoid.list

RUN apt-get update
RUN apt-get install --no-install-recommends -y parsoid && rm -rf /var/lib/apt/lists/*;

WORKDIR /etc/mediawiki/parsoid
RUN  sed -i 's/localhost\/w/gcpedia/' config.yaml

EXPOSE 8000

ENTRYPOINT ["/usr/bin/nodejs", "/usr/lib/parsoid/src/bin/server.js", "> /dev/stdout"]
