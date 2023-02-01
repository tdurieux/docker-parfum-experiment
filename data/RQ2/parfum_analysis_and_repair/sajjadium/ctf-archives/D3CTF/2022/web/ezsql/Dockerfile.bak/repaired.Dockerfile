FROM maven:latest as builder1

WORKDIR /build
ADD . .
ADD ./settings-docker.xml /root/.m2/settings.xml
RUN mvn clean package

FROM debian:buster-slim as builder2

ADD readflag.c /readflag.c
RUN apt update && apt install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN gcc /readflag.c -o /readflag


FROM openjdk:11-jdk

WORKDIR /app
COPY --from=builder1 /build/target/ezsql-0.0.1-SNAPSHOT.jar .
COPY --from=builder2 /readflag /readflag
RUN echo d3ctf{FLAG} > /flag
RUN chmod 0400 /flag
RUN chmod 0444 Dockerfile ezsql-0.0.1-SNAPSHOT.jar
RUN chown root:root /flag ezsql-0.0.1-SNAPSHOT.jar Dockerfile
RUN chmod 4555 /readflag
RUN useradd d3ctf
USER d3ctf

ENTRYPOINT [ "java", "-jar", "ezsql-0.0.1-SNAPSHOT.jar"]
