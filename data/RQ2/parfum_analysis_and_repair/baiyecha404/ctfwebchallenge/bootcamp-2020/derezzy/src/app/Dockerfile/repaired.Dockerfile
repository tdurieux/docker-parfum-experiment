FROM openresty/openresty:centos-rpm

LABEL maintainer="Landon Manning <lmanning17@gmail.com>"

ARG GIFLIB_VERSION="5.1.1"
ARG OPENSSL_DIR="/usr/local/openresty/openssl"

# Install repos
RUN yum -y install --nogpgcheck \
		https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
		https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm \
		https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm \
	&& yum config-manager --set-enabled PowerTools && rm -rf /var/cache/yum

# Install from repos
RUN yum -y install \
	dos2unix \
	ffmpeg \
	gcc \
	git \
	ImageMagick-devel \
	openresty-openssl-devel \
	openssl-devel \
	which \
    m4 \
    python3 \
	; rm -rf /var/cache/yum yum clean all

RUN yum -y update \
    && yum install -y python3 \
    && yum install -y python3-devel \
    && pip3 install --no-cache-dir websockets && rm -rf /var/cache/yum

# Install giflib
RUN cd /tmp \
	&& curl -fSL "https://downloads.sourceforge.net/project/giflib/giflib-${GIFLIB_VERSION}.tar.gz" -o giflib-${GIFLIB_VERSION}.tar.gz \
	&& tar xzf giflib-${GIFLIB_VERSION}.tar.gz \
	&& cd giflib-${GIFLIB_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
		--prefix=/usr \
	&& make \
	&& make install \
	&& cd / \
	&& rm -rf /tmp/* && rm giflib-${GIFLIB_VERSION}.tar.gz

# Install from LuaRocks
RUN luarocks install luasec \
	&& luarocks install bcrypt \
	&& luarocks install giflib \
		--server=http://luarocks.org/dev \
	&& luarocks install i18n \
	&& luarocks install lapis \
		CRYPTO_DIR=${OPENSSL_DIR} \
		CRYPTO_INCDIR=${OPENSSL_DIR}/include \
		OPENSSL_DIR=${OPENSSL_DIR} \
		OPENSSL_INCDIR=${OPENSSL_DIR}/include \
	&& luarocks install luacov \
	&& luarocks install luaposix \
	&& luarocks install magick \
	&& luarocks install markdown \
	&& luarocks install md5 \
    && luarocks install http
    #&& luarocks install lapis-console \
	#&& luarocks install busted \

# Wait for it
ADD wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh \
	&& dos2unix /usr/local/bin/wait-for-it.sh

# Entrypoint
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
	&& dos2unix /usr/local/bin/docker-entrypoint.sh

# Update LD cache
RUN ldconfig
