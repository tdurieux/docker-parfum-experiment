# Remote build
FROM gradle:4.10.3-jdk8 AS builder-remote

USER root
RUN apt-get update && apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

WORKDIR /corda-driver
ADD . .
RUN ./gradlew clean installDist

FROM builder-remote as builder

# Deployment Image
FROM openjdk:8-jre

COPY --from=builder /corda-driver/build/install/corda-driver /corda-driver/

WORKDIR /corda-driver

ARG GIT_URL
LABEL org.opencontainers.image.source ${GIT_URL}
