# This Zulu OpenJDK Dockerfile and corresponding Docker image are
# to be used solely with Java applications or Java application components
# that are being developed for deployment on Microsoft Azure or Azure Stack,
# and are not intended to be used for any other purpose.

FROM centos:latest
MAINTAINER Zulu Enterprise Container Images <azul-zulu-images@microsoft.com>

RUN rpm --import http://repos.azul.com/azul-repo.key && \
    curl -f https://repos.azul.com/azure-only/zulu-azure.repo -o /etc/yum.repos.d/zulu-azure.repo && \
    yum -q -y update && \
    yum -q -y install zulu-11-azure-jdk-11.31+11 && rm -rf /var/cache/yum

ENV JAVA_HOME=/usr/lib/jvm/zulu-11-azure
