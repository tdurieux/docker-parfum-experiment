FROM openjdk:11-jdk-slim

ENV NEO4J_SHA256=fe39006b17a4ce27ea9fa3209ce27ea6ca6a761a2e3ebde31f5f9b41ec8da4d7 \
    NEO4J_TARBALL=neo4j-enterprise-4.4.0-unix.tar.gz \
    NEO4J_EDITION=enterprise \
    NEO4J_HOME="/var/lib/neo4j"
ARG NEO4J_URI=https://dist.neo4j.org/neo4j-enterprise-4.4.0-unix.tar.gz

RUN addgroup --gid 7474 --system neo4j && adduser --uid 7474 --system --no-create-home --home "${NEO4J_HOME}" --ingroup neo4j neo4j

COPY ./local-package/* /tmp/

RUN apt update \
    && apt install -y curl gosu \
    && curl --fail --silent --show-error --location --remote-name ${NEO4J_URI} \
    && echo "${NEO4J_SHA256}  ${NEO4J_TARBALL}" | sha256sum -c --strict --quiet \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* "${NEO4J_HOME}" \
    && rm ${NEO4J_TARBALL} \
    && mv "${NEO4J_HOME}"/data /data \
    && chown -R neo4j:neo4j /data \
    && chmod -R 777 /data \
    && mkdir -p /backup \
    && chown -R neo4j:neo4j /backup \
    && chmod -R 777 /backup \
    && chown -R neo4j:neo4j "${NEO4J_HOME}" \
    && chmod -R 777 "${NEO4J_HOME}" \
    && ln -s /data "${NEO4J_HOME}"/data \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y purge --auto-remove curl


ENV PATH "${NEO4J_HOME}"/bin:$PATH
VOLUME /data /backup
WORKDIR "${NEO4J_HOME}"

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["neo4j-admin"]
