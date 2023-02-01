FROM oracle/graalvm-ce:1.0.0-rc16 AS build-aot

RUN yum update -y
RUN yum install wget -y

RUN wget https://www-eu.apache.org/dist/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz -P /tmp
RUN tar xf /tmp/apache-maven-3.6.1-bin.tar.gz -C /opt
RUN ln -s /opt/apache-maven-3.6.1 /opt/maven
RUN ln -s /opt/graalvm-ce-1.0.0-rc16 /opt/graalvm

ENV GRAALVM_HOME=/opt/graalvm
ENV JAVA_HOME=/opt/graalvm
ENV M2_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=${M2_HOME}/bin:${PATH}
ENV PATH=${GRAALVM_HOME}/bin:${PATH}

COPY ./pom.xml ./pom.xml
COPY src ./src/

ENV MAVEN_OPTS='-Xmx6g'

RUN mvn -Dmaven.test.skip=true -Pnative-image-fargate clean package

FROM debian:9-slim
LABEL maintainer="Sascha Möllering <smoell@amazon.de>"

ENV javax.net.ssl.trustStore /cacerts
ENV javax.net.ssl.trustAnchors /cacerts

RUN apt-get update && apt-get install -y curl
COPY --from=build-aot target/reactive-vertx /usr/bin/reactive-vertx
COPY --from=build-aot /opt/graalvm/jre/lib/amd64/libsunec.so /libsunec.so
COPY --from=build-aot /opt/graalvm/jre/lib/security/cacerts /cacerts

HEALTHCHECK --interval=5s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:8080/health/check || exit 1

EXPOSE 8080

CMD [ "/usr/bin/reactive-vertx" ]