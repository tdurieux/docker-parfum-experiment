# TAGS 7.0.82-jre7 7.0-jre7 7-jre7 7.0.82 7.0 7
FROM laincloud/openjdk:7-jre

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

# runtime dependencies for Tomcat Native Libraries
# Tomcat Native 1.2+ requires a newer version of OpenSSL than debian:jessie has available
# > checking OpenSSL library version >= 1.0.2...
# > configure: error: Your version of OpenSSL is not compatible with this version of tcnative
# see http://tomcat.10.x6.nabble.com/VOTE-Release-Apache-Tomcat-8-0-32-tp5046007p5046024.html (and following discussion)
# and https://github.com/docker-library/tomcat/pull/31
ENV OPENSSL_VERSION 1.1.0f-3+deb9u1
RUN set -ex; \
	if ! grep -q stretch /etc/apt/sources.list; then \
# only add stretch if we're not already building from within stretch
		{ \
			echo 'deb http://deb.debian.org/debian stretch main'; \
			echo 'deb http://security.debian.org stretch/updates main'; \
			echo 'deb http://deb.debian.org/debian stretch-updates main'; \
		} > /etc/apt/sources.list.d/stretch.list; \
		{ \
# add a negative "Pin-Priority" so that we never ever get packages from stretch unless we explicitly request them
			echo 'Package: *'; \
			echo 'Pin: release n=stretch*'; \
			echo 'Pin-Priority: -10'; \
			echo; \
# ... except OpenSSL, which is the reason we're here
			echo 'Package: openssl libssl*'; \
			echo "Pin: version $OPENSSL_VERSION"; \
			echo 'Pin-Priority: 990'; \
		} > /etc/apt/preferences.d/stretch-openssl; \
	fi
RUN apt-get -qq -y update && apt-get -qq -y --no-install-recommends install \
		libapr1 \
		openssl="$OPENSSL_VERSION" \
	&& rm -rf /var/lib/apt/lists/*

ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.82
ENV TOMCAT_SHA1 4681bfbc86bb4da76a7aabbb3c545475eb9a8075

ENV TOMCAT_TGZ_URLS \
# https://issues.apache.org/jira/browse/INFRA-8753?focusedCommentId=14735394#comment-14735394
	https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
# if the version is outdated, we might have to pull from the dist/archive :/
	https://www-us.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
	https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
	https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -eux; \
	\
	success=; \
	for url in $TOMCAT_TGZ_URLS; do \
		if wget -q -O tomcat.tar.gz "$url"; then \
			success=1; \
			break; \
		fi; \
	done; \
	[ -n "$success" ]; \
	\
	echo "$TOMCAT_SHA1 *tomcat.tar.gz" | sha1sum -c -; \
	tar -xf tomcat.tar.gz --strip-components=1; \
	rm bin/*.bat; \
	rm tomcat.tar.gz*; \
	\
	nativeBuildDir="$(mktemp -d)"; \
	tar -xf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1; \
	nativeBuildDeps=" \
		dpkg-dev \
		gcc \
		libapr1-dev \
		libssl-dev \
		make \
		openjdk-${JAVA_VERSION%%[-~bu]*}-jdk=$JAVA_DEBIAN_VERSION \
	"; \
	apt-get -qq -y update; \
	apt-get -qq -y --no-install-recommends install $nativeBuildDeps; \
	rm -rf /var/lib/apt/lists/*; \
	( \
		export CATALINA_HOME="$PWD"; \
		cd "$nativeBuildDir/native"; \
		gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
		./configure \
      --quiet \
			--build="$gnuArch" \
			--libdir="$TOMCAT_NATIVE_LIBDIR" \
			--prefix="$CATALINA_HOME" \
			--with-apr="$(which apr-1-config)" \
			--with-java-home="$(docker-java-home)" \
			--with-ssl=yes; \
		make --quiet -j "$(nproc)"; \
		make install; \
	); \
	apt-get -qq -y --auto-remove purge $nativeBuildDeps; \
	rm -rf "$nativeBuildDir"; \
	rm bin/tomcat-native.tar.gz; \
	\
# sh removes env vars it doesn't support (ones with periods)
# https://github.com/docker-library/tomcat/issues/77
	find ./bin/ -name '*.sh' -exec sed -ri 's|^#!/bin/sh$|#!/usr/bin/env bash|' '{}' +

# verify Tomcat Native is working properly