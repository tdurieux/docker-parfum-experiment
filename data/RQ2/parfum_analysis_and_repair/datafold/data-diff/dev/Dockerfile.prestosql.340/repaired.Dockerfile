FROM openjdk:11-jdk-slim-buster

ENV PRESTO_VERSION=340
ENV PRESTO_SERVER_URL=https://repo1.maven.org/maven2/io/prestosql/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz
ENV PRESTO_CLI_URL=https://repo1.maven.org/maven2/io/prestosql/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar
ENV PRESTO_HOME=/opt/presto
ENV PATH=${PRESTO_HOME}/bin:${PATH}

WORKDIR $PRESTO_HOME

RUN set -xe \
    && apt-get update \
    && apt-get install --no-install-recommends -y curl less python \
    && curl -f -sSL $PRESTO_SERVER_URL | tar xz --strip 1 \
    && curl -f -sSL $PRESTO_CLI_URL > ./bin/presto \
    && chmod +x ./bin/presto \
    && apt-get remove -y curl \
    && rm -rf /var/lib/apt/lists/*

VOLUME /data

EXPOSE 8080

ENTRYPOINT ["launcher"]
CMD ["run"]
