FROM debezium/connect-base:0.3

MAINTAINER Debezium Community

#
# Create a single `$KAFKA_CONNECT_PLUGINS_DIR/debezium` directory into which we'll place all of our JARs and files.
#
# Debezium connectors share some dependencies and JARs, so if we put each connector into a separate directory
# then we'd have JARs appearing in multiple places on Kafka Connect's flat classpath, and we'd get 
# NoSuchMethod exceptions.

RUN mkdir $KAFKA_CONNECT_PLUGINS_DIR/debezium

# -------- testing ---------
COPY debezium-connector-mysql-$DEBEZIUM_VERSION-SNAPSHOT-plugin.tar.gz $KAFKA_CONNECT_PLUGINS_DIR/debezium-mysql-plugin.tar.gz
COPY debezium-connector-mongodb-$DEBEZIUM_VERSION-SNAPSHOT-plugin.tar.gz $KAFKA_CONNECT_PLUGINS_DIR/debezium-mongodb-plugin.tar.gz
RUN  tar -xzf $KAFKA_CONNECT_PLUGINS_DIR/debezium-mysql-plugin.tar.gz -C $KAFKA_CONNECT_PLUGINS_DIR/debezium --strip 1 &&\
     tar -xzf $KAFKA_CONNECT_PLUGINS_DIR/debezium-mongodb-plugin.tar.gz -C $KAFKA_CONNECT_PLUGINS_DIR/debezium --strip 1
