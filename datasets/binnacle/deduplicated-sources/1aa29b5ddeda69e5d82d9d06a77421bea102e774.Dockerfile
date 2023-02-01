FROM ubuntu:xenial
MAINTAINER Joel Martin <github@martintribe.org>

##########################################################
# General requirements for testing or common across many
# implementations
##########################################################

RUN apt-get -y update

# Required for running tests
RUN apt-get -y install make python

# Some typical implementation and test requirements
RUN apt-get -y install curl libreadline-dev libedit-dev

RUN mkdir -p /mal
WORKDIR /mal

##########################################################
# Specific implementation requirements
##########################################################

# Java and maven
RUN apt-get -y install openjdk-8-jdk
#RUN apt-get -y install maven2
#ENV MAVEN_OPTS -Duser.home=/mal

# Scala
RUN echo "deb http://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list
RUN apt-get -y update

RUN apt-get -y --force-yes install sbt
RUN apt-get -y install scala
ENV SBT_OPTS -Duser.home=/mal

