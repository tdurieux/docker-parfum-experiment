###
# vert.x docker example using a Java verticle packaged as a fatjar
# To build:
#   docker build -t folio-simple-module .
# To run:
#   docker run -t -i -p 8080:8080 folio-simple-module
###

FROM folioci/alpine-jre-openjdk11:latest

ENV VERTICLE_FILE folio-simple-vertx-fat.jar

# Set the location of the verticles
ENV VERTICLE_HOME /usr/verticles

# Copy your fat jar to the container
COPY target/${VERTICLE_FILE} ${VERTICLE_HOME}/${VERTICLE_FILE}

# Expose this port locally in the container.