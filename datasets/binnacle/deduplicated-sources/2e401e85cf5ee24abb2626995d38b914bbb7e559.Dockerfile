FROM ubuntu:15.04
RUN apt-get update ; apt-get dist-upgrade -y --force-yes
RUN apt-get install -y openjdk-8-jre-headless
