FROM openjdk:11-jre-slim

RUN apt update && apt install --no-install-recommends -y libopenjp2-7 libturbojpeg0 && rm -rf /var/lib/apt/lists/*;

ARG HYMIR_VERSION

ADD https://oss.sonatype.org/content/repositories/releases/de/digitalcollections/iiif-server-hymir/$HYMIR_VERSION/iiif-server-hymir-$HYMIR_VERSION-exec.jar hymir.jar

ENTRYPOINT [ "sh", "-c", "java -jar /hymir.jar --management.server.port=9001 --server.port=9000 --spring.config.additional-location=file:/application-iiif.yml" ]
