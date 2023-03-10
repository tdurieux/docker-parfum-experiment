ARG CODE_VERSION
FROM clipper/lib_base:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

# install docker and other apt-installable dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
      wget apt-transport-https ca-certificates curl software-properties-common \
      clang-format redis-server gnupg2 \
      && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
      && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
      && apt-get update \
      && apt-get install --no-install-recommends -y docker-ce \
      && apt-get install --no-install-recommends -y python python-dev python-pip libsodium18 \
      && rm -rf /var/lib/apt/lists/*

# Install Java using https://github.com/docker-library/openjdk/blob/1506887e16eba85b37dcf0a5ff8c9c2abe3fa9b7/8-jdk/slim/Dockerfile
# as a template
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
ENV JAVA_VERSION 8u171
ENV JAVA_DEBIAN_VERSION 8u171-b11-1~deb9u1
# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1
RUN set -ex; \

# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	if [ ! -d /usr/share/man/man1 ]; then \
		mkdir -p /usr/share/man/man1; \
	fi; \

	apt-get update; \
	apt-get install --no-install-recommends -y \
		openjdk-8-jdk-headless="$JAVA_DEBIAN_VERSION" \
		ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
	; \
	rm -rf /var/lib/apt/lists/*; \

# verify that "docker-java-home" returns what we expect
	[ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \

# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
	update-alternatives --query java | grep -q 'Status: manual'

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN pip install --no-cache-dir cloudpickle==0.5.* pyzmq==17.0.* requests==2.18.* subprocess32==3.2.* scikit-learn==0.19.* \
  numpy==1.14.* pyyaml==3.12.* docker==3.1.* kubernetes==6.0.* tensorflow==1.6.* mxnet==1.1.* pyspark==2.3.* \
  xgboost==0.7.* jsonschema==2.6.* psutil==5.4.* prometheus_client

# install PyTorch
RUN pip install --no-cache-dir http://download.pytorch.org/whl/cu80/torch-0.3.1-cp27-cp27mu-linux_x86_64.whl \
      && pip install --no-cache-dir torchvision

# Install maven
ARG MAVEN_VERSION=3.5.0
ARG SHA=beb91419245395bd69a4a6edad5ca3ec1a8b64e41457672dc687c173a495f034
ARG BASE_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
  && git clone https://github.com/zeromq/jzmq.git /root/jzmq \
  && cd /root/jzmq/jzmq-jni \
  && ./autogen.sh \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG /root/.m2
ENV JZMQ_HOME /usr/local/lib/

# Install kubectl
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
      && chmod +x kubectl \
      && mv kubectl /usr/local/bin/

# Install R
RUN apt-get update && apt-get install -y --no-install-recommends r-base libxml2-dev gfortran \
  && rm -rf /var/lib/apt/lists/*

COPY containers/R/tests/install_test_dependencies.R /install_test_dependencies.R

RUN Rscript /install_test_dependencies.R

ENTRYPOINT ["bash"]

# vim: set filetype=dockerfile:
