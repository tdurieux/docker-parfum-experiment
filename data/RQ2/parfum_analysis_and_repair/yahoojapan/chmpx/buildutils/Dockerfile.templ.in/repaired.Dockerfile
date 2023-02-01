#
# CHMPX
#
# Copyright 2021 Yahoo Japan Corporation.
#
# CHMPX is inprocess data exchange by MQ with consistent hashing.
# CHMPX is made for the purpose of the construction of
# original messaging system and the offer of the client
# library.
# CHMPX transfers messages between the client and the server/
# slave. CHMPX based servers are dispersed by consistent
# hashing and are automatically laid out. As a result, it
# provides a high performance, a high scalability.
#
# For the full copyright and license information, please view
# the license file that was distributed with this source code.
#
# AUTHOR:   Takeshi Nakatani
# CREATE:   Tue, Aug 10 2021
# REVISION:
#

# [NOTE]
# This file expects the following variables to be expanded by autoconf.
#	GIT_DOMAIN
#	PACKAGE_NAME
#
# Also, replace the following variables.
#	DOCKER_IMAGE_BASE			(ex. "antpickax/libfullock:latest")
#	DOCKER_IMAGE_DEV_BASE		(ex. "antpickax/libfullock-dev:latest")
#	DOCKER_GIT_ORGANIZATION		(ex. "antpickax")
#	DOCKER_GIT_REPOSITORY		(ex. "xxxxx")
#	DOCKER_GIT_BRANCH			(ex. "yyyyy")
#	PKG_UPDATE					(ex. "apk update -q --no-progress")
#	PKG_INSTALL_BUILDER			(ex. "apk add -q --no-progress --no-cache git build-base openssl libtool automake autoconf procps")
#	PKG_INSTALL_BIN				(ex. "apk add -q --no-progress --no-cache libstdc++")
#	CONFIGURE_FLAG				(ex. "--with-gnutls")
#	BUILD_FLAGS					(ex. "CXXFLAGS=-Wno-address-of-packed-member")
#	BUILD_ENV					(ex, "ENV DEBIAN_FRONTEND=noninteractive")
#	UPDATE_LIBPATH				(ex. "ldconfig", if want no-operation, specify ":")
#

#
# Builder
#
FROM %%DOCKER_IMAGE_DEV_BASE%% AS @PACKAGE_NAME@-builder

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
	tar cvzf @PACKAGE_NAME@-dev.tgz /usr/local/lib/lib@PACKAGE_NAME@.la* /usr/local/lib/lib@PACKAGE_NAME@.a* /usr/local/lib/lib@PACKAGE_NAME@.so* && \
	tar cvzf @PACKAGE_NAME@.tgz /usr/local/lib/lib@PACKAGE_NAME@.so*

#
# Image for development
#
FROM %%DOCKER_IMAGE_DEV_BASE%% AS @PACKAGE_NAME@-dev

MAINTAINER antpickax
WORKDIR /

RUN set -x && \
	mkdir -p /usr/local/bin && \
	mkdir -p /usr/local/lib/pkgconfig && \
	mkdir -p /usr/local/include/@PACKAGE_NAME@ && \
	mkdir -p /var/run/antpickax && \
	chmod 0777 /var/run/antpickax

COPY --from=@PACKAGE_NAME@-builder /usr/local/bin/chmpx                          /usr/local/bin/
COPY --from=@PACKAGE_NAME@-builder /usr/local/bin/chmpxbench                     /usr/local/bin/
COPY --from=@PACKAGE_NAME@-builder /usr/local/bin/chmpxlinetool                  /usr/local/bin/
COPY --from=@PACKAGE_NAME@-builder /usr/local/bin/chmpxstatus                    /usr/local/bin/
COPY --from=@PACKAGE_NAME@-builder /usr/local/include/@PACKAGE_NAME@/*           /usr/local/include/@PACKAGE_NAME@/
COPY --from=@PACKAGE_NAME@-builder /usr/local/lib/pkgconfig/lib@PACKAGE_NAME@.pc /usr/local/lib/pkgconfig/
COPY --from=@PACKAGE_NAME@-builder /@PACKAGE_NAME@-dev.tgz                       /@PACKAGE_NAME@-dev.tgz

RUN cd / && \
	tar xvzf @PACKAGE_NAME@-dev.tgz && \
	rm /@PACKAGE_NAME@-dev.tgz && \
	%%UPDATE_LIBPATH%%

CMD ["/bin/sh"]

#
# Image for main
#
FROM %%DOCKER_IMAGE_BASE%% AS @PACKAGE_NAME@

MAINTAINER antpickax
WORKDIR /

RUN set -x && \
	%%PKG_UPDATE%% && \
	%%PKG_INSTALL_BIN%% && \
	mkdir -p /usr/local/bin && \
	mkdir -p /usr/local/lib && \
	mkdir -p /var/run/antpickax && \
	chmod 0777 /var/run/antpickax

COPY --from=@PACKAGE_NAME@-builder /usr/local/bin/chmpx         /usr/local/bin/
COPY --from=@PACKAGE_NAME@-builder /usr/local/bin/chmpxbench    /usr/local/bin/
COPY --from=@PACKAGE_NAME@-builder /usr/local/bin/chmpxlinetool /usr/local/bin/
COPY --from=@PACKAGE_NAME@-builder /usr/local/bin/chmpxstatus   /usr/local/bin/
COPY --from=@PACKAGE_NAME@-builder /@PACKAGE_NAME@.tgz          /@PACKAGE_NAME@.tgz

RUN cd / && \
	tar xvzf @PACKAGE_NAME@.tgz && \
	rm /@PACKAGE_NAME@.tgz && \
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
