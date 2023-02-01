FROM openjdk:11.0.4-jre-slim

RUN apt-get -y update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;


COPY target /usr/local/target

WORKDIR /usr/local/

EXPOSE 8080

ENTRYPOINT ["/bin/bash", "-c", "sleep 30 && java -jar target/ghs-application-*.jar"]
