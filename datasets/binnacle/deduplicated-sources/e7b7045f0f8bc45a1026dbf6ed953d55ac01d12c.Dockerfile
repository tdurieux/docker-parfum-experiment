FROM openjdk:8-jre-alpine

RUN apk add --no-cache --quiet \
    bash \
    curl

ENV NEO4J_SHA256=77c0c142343ea834852d237828f1ddd8cb2d4b7be9131a00b4ec4e3c48d6f6d0 \
    NEO4J_TARBALL=neo4j-community-3.2.0-unix.tar.gz
ARG NEO4J_URI=http://dist.neo4j.org/neo4j-community-3.2.0-unix.tar.gz

COPY ./local-package/* /tmp/

RUN curl --fail --silent --show-error --location --remote-name ${NEO4J_URI} \
    && echo "${NEO4J_SHA256}  ${NEO4J_TARBALL}" | sha256sum -csw - \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* /var/lib/neo4j \
    && rm ${NEO4J_TARBALL} \
    && mv /var/lib/neo4j/data /data \
    && ln -s /data /var/lib/neo4j/data \
    && apk del curl

WORKDIR /var/lib/neo4j

VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 7474 7473 7687

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]
