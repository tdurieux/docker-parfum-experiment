# common-slave but with java9
FROM openjdk:9.0.4-12-jdk-slim
MAINTAINER Sławek Piotrowski <sentinel@atteo.com>

ENV HOME /home/jenkins
ENV LANG en_US.UTF-8
ENV _JAVA_OPTIONS -Dfile.encoding=UTF-8

RUN useradd -c "Jenkins user" -d $HOME -m jenkins

RUN apt-get update && apt-get install -y --no-install-recommends \
		curl git openssh-client \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /home/jenkins

COPY ssh_config .ssh/config
RUN chown jenkins.jenkins .ssh/config

USER jenkins


# versions
ENV MAVEN_VERSION 3.6.0
ENV MAVEN_HOME /usr/share/maven

USER root

# Maven