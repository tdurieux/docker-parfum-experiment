# Builds an image from the output of the `gradle install` command.
# To build from a pre-built connector distribution, see Dockerfile.download

# Use Red Hat Universal Base Image (UBI) for compatibility with OpenShift
FROM registry.access.redhat.com/ubi8/openjdk-11-runtime:1.13-1.1655306368

ARG CBES_HOME=/opt/couchbase-elasticsearch-connector

# Set owner to jboss to appease ubi8/openjdk-11