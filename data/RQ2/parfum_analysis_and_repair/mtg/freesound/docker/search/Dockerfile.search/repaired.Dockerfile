FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y maven openjdk-8-jdk-headless && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code

ADD . /code

WORKDIR /code
RUN mvn install
# Run a command in the jetty plugin so that it downloads all of the
# jetty dependencies during build
RUN mvn jetty:help
