FROM maven:3-eclipse-temurin-11 AS build

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates -f

WORKDIR /usr/src/app
RUN curl -f -o opentelemetry-javaagent.jar https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar
COPY src ./src
COPY pom-server.xml pom.xml
RUN mvn -f /usr/src/app/pom.xml clean package

FROM ibmjava:8-jre

COPY --from=build /usr/src/app/opentelemetry-javaagent.jar /app/
COPY --from=build /usr/src/app/target/lightstep-launcher-server.jar /app/

ENTRYPOINT java \
        -jar /app/lightstep-launcher-server.jar\
        com.lightstep.launcher.server.ExampleServer
