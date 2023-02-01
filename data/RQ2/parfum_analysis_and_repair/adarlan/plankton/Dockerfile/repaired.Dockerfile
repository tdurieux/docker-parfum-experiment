FROM docker:19.03

RUN apk update
RUN apk add --no-cache openjdk11-jre
RUN apk add --no-cache bash
RUN apk add --no-cache gettext
RUN apk add --no-cache jq

ENTRYPOINT [ "java", "-jar", "/plankton/plankton.jar" ]
EXPOSE 1329

COPY target/plankton.jar /plankton/plankton.jar
