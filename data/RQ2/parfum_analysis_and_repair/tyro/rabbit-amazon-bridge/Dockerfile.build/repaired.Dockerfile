FROM maven:3.6.0-jdk-8-alpine
MAINTAINER Team Tam "team-tam@tyro.com"

ARG VERSION

WORKDIR /code
COPY . /code

RUN mvn install -P compile-only