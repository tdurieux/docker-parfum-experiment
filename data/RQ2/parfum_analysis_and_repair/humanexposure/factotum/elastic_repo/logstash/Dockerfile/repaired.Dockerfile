FROM docker.elastic.co/logstash/logstash:7.16.1

ENV JDBC_DRIVER_LIBRARY="" \
    QUERY_PATH="/usr/share/logstash/query.sql" \
    TEMPLATE_PATH="/usr/share/logstash/template.json" \
    MYSQL_CONNECTOR_VERSION=8.0.17

# Add MySQL connector
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/"${MYSQL_CONNECTOR_VERSION}"/mysql-connector-java-"${MYSQL_CONNECTOR_VERSION}".jar /usr/share/logstash/logstash-core/lib/jars/mysql-connector.jar

# Add wait-for-it script
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /usr/local/bin/wait-for-it

# Add repository files
COPY query.sql /usr/share/logstash/
COPY pipelines.yml /usr/share/logstash/config/
COPY logstash.conf /usr/share/logstash/pipeline
COPY factotum_ws_logs.conf /usr/share/logstash/pipeline
COPY template.json /usr/share/logstash/

# Fix file permissions
USER root
RUN chown logstash:logstash \
    /usr/share/logstash/query.sql \
    /usr/share/logstash/pipeline/logstash.conf \
    /usr/share/logstash/pipeline/factotum_ws_logs.conf \
    /usr/share/logstash/config/pipelines.yml \
    /usr/share/logstash/template.json \
    /usr/share/logstash/logstash-core/lib/jars/mysql-connector.jar \
    /usr/local/bin/wait-for-it \
    && chmod +x /usr/share/logstash/logstash-core/lib/jars/mysql-connector.jar \
    && chmod +x /usr/local/bin/wait-for-it

USER logstash

ARG REINDEX_SCHEDULE
ENV REINDEX_SCHEDULE ${REINDEX_SCHEDULE}
ARG DELETE_INDEX_SCHEDULE
ENV DELETE_INDEX_SCHEDULE ${DELETE_INDEX_SCHEDULE}

ENTRYPOINT echo $REINDEX_SCHEDULE $DELETE_INDEX_SCHEDULE && wait-for-it ${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT} -s -t 60 -- docker-entrypoint $@