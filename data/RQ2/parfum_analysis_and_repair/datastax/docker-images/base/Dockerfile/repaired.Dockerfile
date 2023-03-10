# Copyright DataStax, Inc, 2017
#   Please review the included LICENSE file for more information.
#
FROM openjdk:8u171-jdk-slim-stretch

MAINTAINER "DataStax, Inc <info@datastax.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install wget sysstat locales -y --no-install-recommends && \
	apt-get autoclean && apt-get --purge -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	# Comment out Assistive Technologies to run the grimlin console from docker exec
         sed -i -e '/^assistive_technologies=/s/^/#/' /etc/java-*-openjdk/accessibility.properties && \
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
	# set the locale of the container: