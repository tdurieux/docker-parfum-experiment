FROM openjdk:11-jre-slim

ARG EUPHORIA_VERSION

ADD https://oss.sonatype.org/content/repositories/releases/de/digitalcollections/streaming-server-euphoria/$EUPHORIA_VERSION/streaming-server-euphoria-$EUPHORIA_VERSION-exec.jar euphoria.jar

ENTRYPOINT [ "sh", "-c", "java -jar /euphoria.jar --management.server.port=9001 --server.port=9000 --spring.config.additional-location=file:/application-media.yml" ]