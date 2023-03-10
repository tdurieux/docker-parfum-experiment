# This Zulu OpenJDK Dockerfile and corresponding Docker image are
# to be used solely with Java applications or Java application components
# that are being developed for deployment on Microsoft Azure or Azure Stack,
# and are not intended to be used for any other purpose.

FROM ubuntu:bionic
MAINTAINER Zulu Enterprise Container Images <azul-zulu-images@microsoft.com>

RUN apt-get -q update
RUN apt-get -y --no-install-recommends install gnupg software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9 && \
    apt-add-repository "deb http://repos.azul.com/azure-only/zulu/apt stable main" && \
    apt-get -q update && \
    apt-get -y --no-install-recommends install zulu-8-azure-jdk=8.31.0.2 && \
    rm -rf /var/lib/apt/lists/*

