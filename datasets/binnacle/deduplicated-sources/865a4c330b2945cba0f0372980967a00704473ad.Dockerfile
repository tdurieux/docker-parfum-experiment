FROM mongo:4

RUN apt-get update &&  apt-get -y install --no-install-recommends wget apt-transport-https \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
RUN wget -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add -
RUN echo 'deb https://debian.neo4j.org/repo stable/' | tee /etc/apt/sources.list.d/neo4j.list
RUN apt-get update && apt-get -y install --no-install-recommends openjdk-8-jre openssh-client neo4j rsync \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
COPY migration ./migration
COPY migrate.sh /usr/local/bin/migrate
COPY sync_uploads.sh /usr/local/bin/sync_uploads
