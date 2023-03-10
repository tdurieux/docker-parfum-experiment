ARG CODE_VERSION
ARG RPC_VERSION
FROM clipper/${RPC_VERSION}-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

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
ENV JAVA_HOME /docker-java-home
ENV JAVA_MAJOR_VERSION openjdk-8-jdk-headless
ENV JAVA_VERSION 8u171
ENV JAVA_DEBIAN_VERSION 8u171-b11-1~deb9u1
# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home

RUN set -ex; \

# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	if [ ! -d /usr/share/man/man1 ]; then \
		mkdir -p /usr/share/man/man1; \
	fi; \

# The Py35 RPC Docker image uses jessie, so we have to use different package versions
# JAVA_DEBIAN_VERSION found at https://packages.debian.org/jessie-backports/openjdk-8-jdk
# CA_CERTIFICATES_JAVA_VERSION found at https://packages.debian.org/jessie-backports/ca-certificates-java
	debian_version=$(cat /etc/debian_version); \
	if echo "$debian_version" | grep "8.*"; then \
			echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list.d/jessie-backports.list; \
			export CA_CERTIFICATES_JAVA_VERSION="20161107~bpo8+1"; \
			export JAVA_MAJOR_VERSION="openjdk-8-jdk"; \
			export JAVA_VERSION="8u171"; \
			export JAVA_DEBIAN_VERSION="8u171-b11-1~bpo8+1"; \
	fi; \

	apt-get update; \
	apt-get install --no-install-recommends -y \
		"$JAVA_MAJOR_VERSION"="$JAVA_DEBIAN_VERSION" \
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

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
#   https://github.com/docker-library/openjdk/issues
RUN pip install --no-cache-dir pyspark==2.3.*

COPY containers/python/pyspark_container.py containers/python/container_entry.sh /container/

CMD ["/container/container_entry.sh", "pyspark-container", "/container/pyspark_container.py"]

# vim: set filetype=dockerfile:
