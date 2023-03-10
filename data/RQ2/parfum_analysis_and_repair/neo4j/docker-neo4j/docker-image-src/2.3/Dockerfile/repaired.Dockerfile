FROM openjdk:8-jre

RUN apt-get update --quiet --quiet \
    && apt-get install -y --quiet --quiet --no-install-recommends lsof \
    && rm -rf /var/lib/apt/lists/*

ENV NEO4J_SHA256=%%NEO4J_SHA%% \
    NEO4J_TARBALL=%%NEO4J_TARBALL%%
ARG NEO4J_URI=%%NEO4J_DIST_SITE%%/%%NEO4J_TARBALL%%

COPY ./local-package/* /tmp/

RUN curl --fail --silent --show-error --location --remote-name ${NEO4J_URI} \
    && echo "${NEO4J_SHA256}  ${NEO4J_TARBALL}" | sha256sum --check --quiet - \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* /var/lib/neo4j \
    && rm ${NEO4J_TARBALL}

ENV PATH /var/lib/neo4j/bin:$PATH

WORKDIR /var/lib/neo4j

RUN mv data /data \
    && ln --symbolic /data

VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 7474 7473

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]
