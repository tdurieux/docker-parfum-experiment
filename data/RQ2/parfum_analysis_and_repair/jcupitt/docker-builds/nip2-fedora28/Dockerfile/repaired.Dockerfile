FROM fedora:28

# general build stuff
RUN yum update -y \
	&& yum groupinstall -y "Development Tools" \
	&& yum install -y wget tar gcc-c++ && rm -rf /var/cache/yum

# stuff we need to build our own libvips ... this is a pretty basic selection
# of dependencies, you'll want to adjust these
RUN yum install -y \
	libpng-devel \
	glib2-devel \
	libjpeg-devel \
	expat-devel \
	pango-devel \
	zlib-devel && rm -rf /var/cache/yum

ARG VIPS_VERSION=8.7.3
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN cd /usr/local/src \
	&& wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xzf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make \
	&& make install && rm vips-${VIPS_VERSION}.tar.gz

ARG NIP2_VERSION=8.7.1
#ARG NIP2_URL=https://github.com/libvips/nip2/releases/download
ARG NIP2_URL=http://www.rollthepotato.net/~john

# stuff we need to build our own nip2, plus the debugger
RUN yum install -y \
	gdb \
	gtk2-devel \
	libxml2-devel \
	bison \
	flex && rm -rf /var/cache/yum

RUN cd /usr/local/src \
	&& wget ${NIP2_URL}/nip2-${NIP2_VERSION}.tar.gz \
	&& tar xzf nip2-${NIP2_VERSION}.tar.gz \
	&& cd nip2-${NIP2_VERSION} \
	&& export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make \
	&& make install && rm nip2-${NIP2_VERSION}.tar.gz


