## Stage 1 : build with maven builder image with native capabilities
FROM quay.io/quarkus/centos-quarkus-maven:19.2.1 AS build
ARG QUARKUS_DATASOURCE_URL
RUN echo "<QUARKUS_DATASOURCE_URL>: $QUARKUS_DATASOURCE_URL"
# ENV QUARKUS_DATASOURCE_URL $QUARKUS_DATASOURCE_URL
WORKDIR /usr/src/app
COPY pom.xml .
RUN mvn -B dependency:go-offline -Pnative
COPY src/ /usr/src/app/src/
USER root
RUN chown -R quarkus /usr/src/app
USER quarkus
RUN mvn clean package -Pnative -Dquarkus.datasource.url=$QUARKUS_DATASOURCE_URL
#RUN mvn clean package -Pnative -DskipTests -Dmaven.test.skip=true

## Stage 2 : create the docker final image