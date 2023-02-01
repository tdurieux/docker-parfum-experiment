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

# Java and maven deps
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y install maven
ENV MAVEN_OPTS -Duser.home=/mal

# GNU Octave
RUN apt-get -y install software-properties-common && \
    apt-add-repository -y ppa:octave/stable && \
    apt-get -y update && \
    apt-get -y install octave

ENV HOME /mal
