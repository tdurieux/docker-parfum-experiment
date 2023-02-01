# first stage does the building
FROM dhlabbasel/sbt-ivy2-cache as build-stage

MAINTAINER Ivan Subotic "ivan.subotic@unibas.ch"

# copy source code
RUN mkdir /knora
COPY . /knora

# generate deployment jars and clean up
RUN \
    cd /knora/webapi && \
    sbt stage && \
    sbt test:assembly && \
    sbt it:assembly && \
    cp -r /knora/webapi/target/universal/stage/* /knora/webapi && \
    cp /knora/webapi/target/scala-2.12/assembly*.jar /knora/webapi/ && \
    rm -rf /knora/webapi/src && \
    rm -rf /knora/webapi/target && \
    rm -rf /knora/webapi/project

# starting second stage
FROM openjdk:8-jre-alpine

RUN \
    mkdir -p /knora/webapi && \
    mkdir -p /knora/knora-ontologies

COPY --from=build-stage /knora /knora

# Expose the webapi default port
EXPOSE 3333