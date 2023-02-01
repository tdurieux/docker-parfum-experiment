# This dockerfile builds a 'live' zap docker image using the latest files in the repos
FROM ubuntu:latest
LABEL maintainer="psiinon@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -q -y --fix-missing \
	make \
	ant \
	automake \
	autoconf \
	gcc g++ \
	openjdk-8-jdk \
	wget \
	curl \
	xmlstarlet \
	unzip \
	git \
	openbox \
	xterm \
	net-tools \
	python-pip \
	firefox \
	vim \
	xvfb \
	x11vnc && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*  && \
	pip install --upgrade pip zapcli python-owasp-zap-v2.4 && \
	useradd -d /home/zap -m -s /bin/bash zap && \
	echo zap:zap | chpasswd && \
	mkdir /zap  && \
	chown zap /zap && \
	chgrp zap /zap && \
	mkdir /zap-src  && \
	chown zap /zap-src && \
	chgrp zap /zap-src

WORKDIR /zap-src

#Change to the zap user so things get done as the right person (apart from copy)
USER zap

RUN mkdir /home/zap/.vnc

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH $JAVA_HOME/bin:/zap/:$PATH

# Pull the ZAP repo
RUN git clone --depth 1 https://github.com/zaproxy/zaproxy.git && \
	# Build ZAP with weekly add-ons
	cd zaproxy && \
	ZAP_WEEKLY_ADDONS_NO_TEST=true ./gradlew :zap:prepareDistWeekly && \
	cp -R /zap-src/zaproxy/zap/build/distFilesWeekly/* /zap/ && \
	rm -rf /zap-src/* && \
	cd /zap/ && \
	# Setup Webswing
	curl -s -L https://bitbucket.org/meszarv/webswing/downloads/webswing-2.5.10.zip > webswing.zip && \
	unzip webswing.zip && \
	rm webswing.zip && \
	mv webswing-* webswing && \
	# Remove Webswing demos
	rm -R webswing/demo/ && \
	# Accept ZAP license
	touch AcceptedLicense

ENV ZAP_PATH /zap/zap.sh
# Default port for use with zapcli
ENV ZAP_PORT 8080
ENV HOME /home/zap/

COPY zap* CHANGELOG.md /zap/
COPY webswing.config /zap/webswing/
COPY policies /home/zap/.ZAP_D/policies/
COPY scripts /home/zap/.ZAP_D/scripts/
COPY .xinitrc /home/zap/

#Copy doesn't respect USER directives so we need to chown and to do that we need to be root
USER root

RUN chown zap:zap /zap/* && \
	chown zap:zap /zap/webswing/webswing.config && \
	chown zap:zap -R /home/zap/.ZAP_D/ && \
	chown zap:zap /home/zap/.xinitrc && \
	chmod a+x /home/zap/.xinitrc && \
	chmod +x /zap/zap.sh && \
	rm -rf /zap-src

WORKDIR /zap

USER zap
HEALTHCHECK --retries=5 --interval=5s CMD zap-cli status
