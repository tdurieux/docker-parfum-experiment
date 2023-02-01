#FROM amazonlinux:latest
FROM anapsix/alpine-java
MAINTAINER pacman-rule-execution-engine
RUN \
	mkdir -p /aws && \
	apk -Uuv add groff less python py-pip && \
	pip install --no-cache-dir awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*
ADD fetch_and_run.sh ~/fetch_and_run.sh

