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

ARG VIPS_VERSION=8.6.5
ARG VIPS_URL=https://github.com/jcupitt/libvips/releases/download

RUN cd /usr/local/src \
	&& wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xzf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& echo -n "GCC version "; rm vips-${VIPS_VERSION}.tar.gz gcc --version \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make \
	&& make install

