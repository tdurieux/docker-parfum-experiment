# This is the default Dockerfile used by Docker Hub
# to build the latest version of the Fiware Cepheus-CEP project.
FROM java:8-jre
MAINTAINER FIWARE Cepheus Team

ENV CEPHEUS_VERSION 1.0.1-SNAPSHOT
ENV CEPHEUS_REPO snapshots

WORKDIR /opt/cepheus

# Download CEP