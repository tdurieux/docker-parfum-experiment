FROM debian:stretch

RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	unzip \
	wget \
	git \
	pkg-config && rm -rf /var/lib/apt/lists/*;

# stuff we need to build our own libvips ... this is a pretty random selection
# of dependencies, you'll want to adjust these
RUN apt-get install --no-install-recommends -y \
	glib-2.0-dev \
	libexpat-dev \
	librsvg2-dev \
	libpng-dev \
	libgif-dev \
	libjpeg-dev \
	libexif-dev \
	liblcms2-dev \
	liborc-dev && rm -rf /var/lib/apt/lists/*;

ARG VIPS_VERSION=8.7.3
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN apt-get install --no-install-recommends -y \
	wget && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/local/src \
	&& wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xzf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make \
	&& make install && rm vips-${VIPS_VERSION}.tar.gz

RUN apt-get install --no-install-recommends -y \
  ruby-dev libffi-dev && rm -rf /var/lib/apt/lists/*;

RUN gem install ruby-vips


