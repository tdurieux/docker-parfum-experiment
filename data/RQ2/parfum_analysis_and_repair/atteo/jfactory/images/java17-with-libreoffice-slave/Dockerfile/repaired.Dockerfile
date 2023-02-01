FROM jfactory/java17-slave
MAINTAINER Sławek Piotrowski <sentinel@atteo.com>

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:libreoffice/ppa \
    && apt update \
    && apt-get -y --no-install-recommends install libreoffice-calc \
    && rm -rf /var/lib/apt/lists/*

USER jenkins
