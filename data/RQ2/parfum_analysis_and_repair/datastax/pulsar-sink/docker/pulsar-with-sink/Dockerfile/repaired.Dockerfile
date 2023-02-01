ARG PULSAR_IMAGE
ARG PULSAR_TAG
FROM ${PULSAR_IMAGE}:${PULSAR_TAG}
COPY cassandra-enhanced-pulsar-sink-*.nar /pulsar/connectors/