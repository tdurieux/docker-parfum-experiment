FROM openjdk:8-jre

RUN apt-get update --quiet --quiet \
    && apt-get install -y --quiet --quiet --no-install-recommends lsof \
    && rm -rf /var/lib/apt/lists/*

ENV NEO4J_SHA256 ea80cfca918dd70ea5d10a125f5c3a5be02e45dd497b67dfa2d22770a891acea
ENV NEO4J_TARBALL neo4j-enterprise-2.3.2-unix.tar.gz
ARG NEO4J_URI=http://dist.neo4j.org/neo4j-enterprise-2.3.2-unix.tar.gz

COPY ./local-package/* /tmp/

RUN curl --fail --silent --show-error --location --remote-name ${NEO4J_URI} \
    && echo "${NEO4J_SHA256}  ${NEO4J_TARBALL}" | sha256sum --check --quiet - \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* /var/lib/neo4j \
    && rm ${NEO4J_TARBALL}

WORKDIR /var/lib/neo4j

RUN mv data /data \
    && ln --symbolic /data

VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 7474 7473

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]
