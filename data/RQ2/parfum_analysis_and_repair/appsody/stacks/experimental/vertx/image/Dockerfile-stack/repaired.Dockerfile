# Dockerfile for building the stack
FROM adoptopenjdk/openjdk8-openj9

USER root
RUN apt-get -qq update \
  && apt-get -qq --no-install-recommends install -y curl maven \
  && DEBIAN_FRONTEND=noninteractive apt-get -qq upgrade -y \
  && apt-get -qq clean \
  && rm -rf /tmp/* /var/lib/apt/lists/*
RUN mkdir -p /.m2/repository

COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config
WORKDIR /project/
RUN mvn -B install dependency:go-offline -DskipTests

ENV APPSODY_USER_RUN_AS_LOCAL=true

ENV APPSODY_MOUNTS=".:/project/user-app/;~/.m2/repository:/.m2/repository"
ENV APPSODY_DEPS=

ENV APPSODY_RUN="mvn -B compile vertx:run"
ENV APPSODY_RUN_ON_CHANGE=""
ENV APPSODY_RUN_KILL=false

ENV APPSODY_DEBUG="mvn -B compile vertx:debug"
ENV APPSODY_DEBUG_ON_CHANGE=""
ENV APPSODY_DEBUG_KILL=false

ENV APPSODY_TEST="mvn -B test"
ENV APPSODY_TEST_ON_CHANGE="mvn -B test"
ENV APPSODY_TEST_KILL=true

WORKDIR /project/user-app

ENV PORT=8080

EXPOSE 8080
EXPOSE 5005
