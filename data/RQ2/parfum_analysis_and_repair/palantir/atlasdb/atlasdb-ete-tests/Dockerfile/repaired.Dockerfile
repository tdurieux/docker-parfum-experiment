FROM adoptopenjdk/openjdk11:debian-jre

ENV DOCKERIZE_VERSION v0.2.0

RUN apt-get update \
    && apt-get install --no-install-recommends -y procps wget \
    && wget --no-check-certificate https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm -rf /var/lib/apt/lists/*;

EXPOSE 3828

ADD build/docker/atlasdb-ete-snapshot.tgz /atlasdb-ete

# Remove possible version prefix
RUN for file in atlasdb-ete/*; do mv "$file" "atlasdb-ete/atlasdb-ete-snapshot"; done

ADD docker/ /atlasdb-ete/atlasdb-ete-snapshot/var/

WORKDIR /atlasdb-ete/atlasdb-ete-snapshot

CMD service/bin/init.sh console
