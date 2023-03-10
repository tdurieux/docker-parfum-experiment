FROM maven:3.6-jdk-8 AS build
RUN mkdir /opt/ols
COPY . /opt/ols/
COPY build-fix/. /root/.m2/repository/
RUN cd /opt/ols && ls && mvn clean package -DskipTests

FROM openjdk:8-jre-alpine
RUN apk add --no-cache bash
COPY --from=build /opt/ols/ols-apps/ols-config-importer/target/ols-config-importer.jar /opt/ols-config-importer.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/opt/ols-config-importer.jar", "--ols.ontology.config=file:///config/ols-config.yaml","--ols.obofoundry.ontology.config=file:///config/obo-config.yaml"]
