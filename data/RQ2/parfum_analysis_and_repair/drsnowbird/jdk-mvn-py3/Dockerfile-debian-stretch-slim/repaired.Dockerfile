# use the latest LTS Ubuntu
#FROM ubuntu:xenial

#ARG JDK_VERSION=${JDK_VERSION:-openjdk-8-jdk}
#FROM ${JDK_VERSION}

#ENV DEBIAN_FRONTEND noninteractive

####################################################################################################################
#### Source: https://github.com/docker-library/openjdk
####################################################################################################################
#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM debian:stretch-slim

MAINTAINER openkbs.org@gmail.com


# A few reasons for installing distribution-provided OpenJDK:
#
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#     really hairy.
#
#     For some sample build times, see Debian's buildd logs:
#       https://buildd.debian.org/status/logs.php?pkg=openjdk-8

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home

ENV JAVA_VERSION 8u181
ENV JAVA_DEBIAN_VERSION 8u181-b13-1~deb9u1

# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

RUN set -ex; \
	\
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	if [ ! -d /usr/share/man/man1 ]; then \
		mkdir -p /usr/share/man/man1; \
	fi; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		openjdk-8-jdk-headless="$JAVA_DEBIAN_VERSION" \
		ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
# verify that "docker-java-home" returns what we expect
	[ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
	\
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
	update-alternatives --query java | grep -q 'Status: manual'

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
#   https://github.com/docker-library/openjdk/issues
####################################################################################################################


##### update ubuntu and Install Python 3
RUN apt-get update \
  && apt-get install --no-install-recommends -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev \
  && apt-get install --no-install-recommends -y curl net-tools build-essential software-properties-common libsqlite3-dev sqlite3 bzip2 libbz2-dev git wget unzip vim python3-pip python3-setuptools python3-dev python3-numpy python3-scipy python3-pandas python3-matplotlib \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

###################################
#### ---- Java Path setup ----
###################################
ENV PATH=$PATH:${JAVA_HOME}/bin

###################################
#### ---- Pip install packages ----
###################################
#### Install Maven 3
ARG MAVEN_VERSION=${MAVEN_VERSION:-3.5.4}
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV MAVEN_HOME=/usr/apache-maven-${MAVEN_VERSION}
ENV PATH $PATH:${MAVEN_HOME}/bin
RUN curl -f -sL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s ${MAVEN_HOME} /usr/maven

###################################
#### ---- Pip install packages ----
###################################
COPY requirements.txt ./

## ---------------------------------------------------
## Don't upgrade pip to 10.0.x version -- it's broken!
## Staying with version 8 to avoid the problem
## ---------------------------------------------------

RUN pip3 install --no-cache-dir -r ./requirements.txt

RUN pip3 install --no-cache-dir --upgrade pip

## VERSIONS ##
RUN apt-get update -y && apt-get install -y --no-install-recommends sudo && \
    echo "JAVA_HOME=${JAVA_HOME}" && \
    java -version && \
    mvn --version && \
    #python -V && \
    python3 -V && \
    pip3 --version && rm -rf /var/lib/apt/lists/*;

#### define working directory.
RUN mkdir -p /data
COPY ./data /data

VOLUME "/data"

WORKDIR /data

#### Define default command.
#ENTRYPOINT ["/bin/bash"]
CMD ["/bin/bash"]

