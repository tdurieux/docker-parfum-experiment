#
# FULLOCK - Fast User Level LOCK library
#
# Copyright 2015 Yahoo Japan Corporation.
#
# FULLOCK is fast locking library on user level by Yahoo! JAPAN.
# FULLOCK is following specifications.
#
# For the full copyright and license information, please view
# the license file that was distributed with this source code.
#
# AUTHOR:   Takeshi Nakatani
# CREATE:   Tue, Aug 3 2021
# REVISION:	1.0
#

# [NOTE]
# This file expects the following variables to be expanded by autoconf.
#	GIT_DOMAIN
#	PACKAGE_NAME
#
# Also, replace the following variables.
#	DOCKER_IMAGE_BASE			(ex. "docker.io/alpine:3.13.5")
#	DOCKER_IMAGE_DEV_BASE		(ex. "docker.io/alpine:3.13.5")
#	DOCKER_GIT_ORGANIZATION		(ex. "antpickax")
#	DOCKER_GIT_REPOSITORY		(ex. "xxxxx")
#	DOCKER_GIT_BRANCH			(ex. "yyyyy")
#	PKG_UPDATE					(ex. "apk update -q --no-progress")
#	PKG_INSTALL_BUILDER			(ex. "apk add -q --no-progress --no-cache git build-base openssl libtool automake autoconf procps")
#	PKG_INSTALL_BIN				(ex. "apk add -q --no-progress --no-cache libstdc++")
#	CONFIGURE_FLAG				(ex. "")
#	BUILD_FLAGS					(ex. "CXXFLAGS=")
#	BUILD_ENV					(ex. "ENV DEBIAN_FRONTEND=noninteractive")
#	UPDATE_LIBPATH				(ex. "ldconfig", if want no-operation, specify ":")
#

#
# Builder
#
FROM %%DOCKER_IMAGE_BASE%% AS @PACKAGE_NAME@-builder

MAINTAINER antpickax
WORKDIR /

%%BUILD_ENV%%

RUN set -x && \
	%%PKG_UPDATE%% && \
	%%PKG_INSTALL_BUILDER%% && \
	cd / && \
	git clone https://@GIT_DOMAIN@/%%DOCKER_GIT_ORGANIZATION%%/%%DOCKER_GIT_REPOSITORY%%.git && \
	cd %%DOCKER_GIT_REPOSITORY%% && \
	git checkout %%DOCKER_GIT_BRANCH%% && \
	./autogen.sh && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" %%CONFIGURE_FLAG%% && \
	make %%BUILD_FLAGS%% && \
	make check && \
	make install && \
	cd / && \
	tar cvzf lib@PACKAGE_NAME@-dev.tgz /usr/local/lib/lib@PACKAGE_NAME@.la* /usr/local/lib/lib@PACKAGE_NAME@.a* /usr/local/lib/lib@PACKAGE_NAME@.so* && \
	tar cvzf lib@PACKAGE_NAME@.tgz /usr/local/lib/lib@PACKAGE_NAME@.so*

#
# Image for development
#
FROM %%DOCKER_IMAGE_DEV_BASE%% AS lib@PACKAGE_NAME@-dev

MAINTAINER antpickax
WORKDIR /

RUN set -x && \
	mkdir -p /usr/local/lib/pkgconfig && \
	mkdir -p /usr/local/include/@PACKAGE_NAME@ && \
	mkdir -p /var/lib/antpickax && \
	chmod 0777 /var/lib/antpickax

COPY --from=@PACKAGE_NAME@-builder /usr/local/include/@PACKAGE_NAME@/*           /usr/local/include/@PACKAGE_NAME@/
COPY --from=@PACKAGE_NAME@-builder /usr/local/lib/pkgconfig/lib@PACKAGE_NAME@.pc /usr/local/lib/pkgconfig/
COPY --from=@PACKAGE_NAME@-builder /lib@PACKAGE_NAME@-dev.tgz                    /lib@PACKAGE_NAME@-dev.tgz

RUN cd / && \
	tar xvzf lib@PACKAGE_NAME@-dev.tgz && \
	rm /lib@PACKAGE_NAME@-dev.tgz && \
	%%UPDATE_LIBPATH%%

CMD ["/bin/sh"]

#
# Image for main
#
FROM %%DOCKER_IMAGE_BASE%% AS lib@PACKAGE_NAME@

MAINTAINER antpickax
WORKDIR /

RUN set -x && \
	%%PKG_UPDATE%% && \
	%%PKG_INSTALL_BIN%% && \
	mkdir -p /usr/local/lib && \
	mkdir -p /var/lib/antpickax && \
	chmod 0777 /var/lib/antpickax

COPY --from=@PACKAGE_NAME@-builder /lib@PACKAGE_NAME@.tgz /lib@PACKAGE_NAME@.tgz

RUN cd / && \
	tar xvzf lib@PACKAGE_NAME@.tgz && \
	rm /lib@PACKAGE_NAME@.tgz && \
	%%UPDATE_LIBPATH%%

CMD ["/bin/sh"]

#
# Local variables:
# tab-width: 4
# c-basic-offset: 4
# End:
# vim600: noexpandtab sw=4 ts=4 fdm=marker
# vim<600: noexpandtab sw=4 ts=4
#
