# Builds a docker image for the Kafka REST Proxy.
# Expects links to "schema-registry" and "zookeeper" containers.
#
# Usage:
#   docker build -t confluent/rest-proxy rest-proxy
#   docker run -d --name rest-proxy --link zookeeper:zookeeper --link schema-registry:schema-registry \
#       confluent/rest-proxy