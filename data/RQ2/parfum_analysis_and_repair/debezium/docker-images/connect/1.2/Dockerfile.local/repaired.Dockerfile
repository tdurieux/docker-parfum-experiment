FROM debezium/connect-base:1.2

LABEL maintainer="Debezium Community"

ARG DEBEZIUM_VERSION=1.2.5.Final
ENV DEBEZIUM_VERSION=${DEBEZIUM_VERSION}

# -------- testing ---------
COPY debezium-connector-mysql-$DEBEZIUM_VERSION-SNAPSHOT-plugin.tar.gz $KAFKA_CONNECT_PLUGINS_DIR/debezium-mysql-plugin.tar.gz
COPY debezium-connector-mongodb-$DEBEZIUM_VERSION-SNAPSHOT-plugin.tar.gz $KAFKA_CONNECT_PLUGINS_DIR/debezium-mongodb-plugin.tar.gz
COPY debezium-connector-postgres-$DEBEZIUM_VERSION-SNAPSHOT-plugin.tar.gz $KAFKA_CONNECT_PLUGINS_DIR/debezium-postgres-plugin.tar.gz
COPY debezium-connector-sqlserver-$DEBEZIUM_VERSION-SNAPSHOT-plugin.tar.gz $KAFKA_CONNECT_PLUGINS_DIR/debezium-sqlserver-plugin.tar.gz

COPY debezium-connector-oracle-$DEBEZIUM_VERSION-SNAPSHOT-plugin.tar.gz $KAFKA_CONNECT_PLUGINS_DIR/debezium-oracle-plugin.tar.gz
COPY debezium-connector-db2-$DEBEZIUM_VERSION-SNAPSHOT-plugin.tar.gz $KAFKA_CONNECT_PLUGINS_DIR/debezium-db2-plugin.tar.gz

ADD debezium-scripting-$DEBEZIUM_VERSION-SNAPSHOT.tar.gz $EXTERNAL_LIBS_DIR

RUN for CONNECTOR in {mysql,mongodb,postgres,sqlserver,oracle,db2}; do \
    tar -xzf $KAFKA_CONNECT_PLUGINS_DIR/debezium-$CONNECTOR-plugin.tar.gz -C $KAFKA_CONNECT_PLUGINS_DIR; \
    done; rm $KAFKA_CONNECT_PLUGINS_DIR/debezium-$CONNECTOR-plugin.tar.gz
