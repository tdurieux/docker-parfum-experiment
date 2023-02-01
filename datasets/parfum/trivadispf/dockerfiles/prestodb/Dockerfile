# Note: This Dockerfile is based on https://raw.githubusercontent.com/johannestang/bigdata_stack/master/prestodb/Dockerfile
# The following changes have been made:
#
# 1. Presto version updated.
# 2. Download linke updated.
# 3. Launcher modified such that S3 credentials can be set by env vars.

FROM openjdk:8u181-jre-stretch

LABEL MAINTAINER=guido.schmutz@trivadis.com

ENV PRESTO_VERSION=310
ENV PRESTO_HOME=/opt/presto

# extra dependency for running launcher
RUN apt-get update && apt-get install -y --no-install-recommends \
    python2.7-minimal \
    && rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python2.7 /usr/bin/python

RUN curl -L https://repo1.maven.org/maven2/io/prestosql/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz -o /tmp/presto-server.tgz && \
    tar -xzf /tmp/presto-server.tgz -C /opt && \
    ln -s /opt/presto-server-${PRESTO_VERSION} ${PRESTO_HOME} && \
    mkdir -p ${PRESTO_HOME}/data && \
    rm -f /tmp/presto-server.tgz

COPY etc ${PRESTO_HOME}/etc
COPY launcher ${PRESTO_HOME}/bin

EXPOSE 8080

VOLUME ["${PRESTO_HOME}/etc", "${PRESTO_HOME}/data"]

WORKDIR ${PRESTO_HOME}

ENTRYPOINT ["./bin/launcher"]

CMD ["run"]
