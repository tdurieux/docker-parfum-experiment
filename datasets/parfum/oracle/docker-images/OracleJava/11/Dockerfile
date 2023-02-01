# Copyright (c) 2019, 2022 Oracle and/or its affiliates.
#
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle JDK 11
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
#
# (1) jdk-11.XX_linux-x64_bin.tar.gz or jdk-11.XX_linux-aarch64_bin.tar.gz
#     Download from https://www.oracle.com/java/technologies/javase-jdk11-downloads.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ docker build -t oracle/jdk:11 .
#
# This command is already scripted in build.sh so you can alternatively run
#		$ bash build.sh
#
# The builder image will be used to uncompress the tar.gz file with the Java Runtime.

FROM oraclelinux:7-slim as builder

MAINTAINER Aurelio Garcia-Ribeyro <aurelio.garciaribeyro@oracle.com>

RUN set -eux; \
	yum install -y \
		gzip \
		tar;
	
# Default to UTF-8 file.encoding
ENV LANG en_US.UTF-8


# Environment variables for the builder image.
# Required to validate that you are using the correct file

ENV JAVA_HOME=/usr/java/jdk-11

##
COPY *.tar.gz /tmp/
RUN set -eux; \
	ARCH=$(uname -m) && \
    if [ "$ARCH" == "x86_64" ]; \
    then \
		mv $(ls /tmp/jdk-11*_linux-x64_bin.tar.gz) /tmp/jdk.tar.gz ; \
        JAVA_SHA256=a40ad9342646ec14196deaf28c64f697fef4c698296f0e7d39b638f360780d27 ; \
    else \
	    mv $(ls /tmp/jdk-11*_linux-aarch64_bin.tar.gz) /tmp/jdk.tar.gz ; \
    	JAVA_SHA256=fbb191c2dfc976e61691b1c4805c6ac94cf39f72464779f421d207db1571540a ; \    	
    fi && \
	echo "$JAVA_SHA256 */tmp/jdk.tar.gz" | sha256sum -c -; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /tmp/jdk.tar.gz --directory "$JAVA_HOME" --strip-components 1
	
## Get a fresh version of SLIM for the final image	
FROM oraclelinux:7-slim

# Default to UTF-8 file.encoding
ENV LANG en_US.UTF-8

ENV JAVA_VERSION=11.0.15.1 \
	JAVA_HOME=/usr/java/jdk-11

ENV	PATH $JAVA_HOME/bin:$PATH	

# Copy the uncompressed Java Runtime from the builder image
COPY --from=builder $JAVA_HOME $JAVA_HOME

RUN set -eux; \
# Update the base image
	yum -y update; \
	yum install -y \
# JDK assumes freetype is available		
		freetype fontconfig \
	; \
	rm -rf /var/cache/yum; \
	ln -sfT "$JAVA_HOME" /usr/java/default; \
	ln -sfT "$JAVA_HOME" /usr/java/latest; \
	for bin in "$JAVA_HOME/bin/"*; do \
		base="$(basename "$bin")"; \
		[ ! -e "/usr/bin/$base" ]; \
		alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
	done; \
# -Xshare:dump will create a CDS archive to improve startup in subsequent runs	
	java -Xshare:dump; 

CMD ["jshell"]
