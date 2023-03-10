# A base Dockerfile for Vert.x 4

FROM openjdk:8u275-jre

MAINTAINER Clement Escoffier <clement@apache.org>

# Install the ps command to get the Launcher 'stop' command
# working properly
RUN apt-get update && apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;
COPY ./ /usr/local/
RUN chmod +x /usr/local/vertx/bin/vertx

# Set path
ENV VERTX_HOME /usr/local/vertx
ENV PATH $VERTX_HOME/bin:$PATH
