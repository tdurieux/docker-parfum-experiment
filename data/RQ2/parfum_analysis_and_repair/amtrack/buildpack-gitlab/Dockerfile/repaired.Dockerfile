# Dockerfile for running unit tests for amtrack/buildpack-gitlab
FROM progrium/cedarish
MAINTAINER Matthias Rolke <mr.amtrack@gmail.com>

RUN sudo apt-get update -qq
RUN sudo apt-get -y --no-install-recommends install git wget && rm -rf /var/lib/apt/lists/*;

ADD . /app

RUN cd /app && ./bin/test-setup
RUN cd /app && ./bin/test
