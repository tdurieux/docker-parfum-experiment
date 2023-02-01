# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ez-Dashing Official Dockerfile #
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# USAGE: docker run --rm -itp 8080:8080 --name ez-dashing -v tmp/ez-config:/ez-config ylacaute/ez-dashing:latest
# Note that '/tmp/ez-config' is your local directory containg the configuration files. This directory
# must be in lower case and should contains 'dashboard.json'. If this directory contains an application.yml, it
# will be used to override server properties.

# DEBIAN STRETCH + JDK
FROM openjdk:8-jdk

LABEL maintainer="Yannick Lacaute <yannick.lacaute@gmail.com>"

ARG uid=2042
ARG gid=2042
ARG VERSION="latest"
ENV JAVA_OPTS=""

#COPY ez-server/target/classes /usr/src/app/classes