FROM openjdk:8-jre-alpine

RUN apk add --no-cache --quiet \
    bash \
    curl

ENV NEO4J_SHA256 c532d4d06708cda68f9935f93d569d0c6c90213e2406fec46a2110d6ae403dde
ENV NEO4J_TARBALL neo4j-enterprise-3.1.0-RC1-unix.tar.gz
ARG NEO4J_URI=http://dist.neo4j.org/neo4j-enterprise-3.1.0-RC1-unix.tar.gz

COPY ./local-package/* /tmp/

RUN curl --fail --silent --show-error --location --remote-name ${NEO4J_URI} \
    && echo "${NEO4J_SHA256} ${NEO4J_TARBALL}" | sha256sum -csw - \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* /var/lib/neo4j \
    && rm ${NEO4J_TARBALL}

WORKDIR /var/lib/neo4j

RUN mv data /data \
    && ln -s /data

VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 7474 7473 7687

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]
