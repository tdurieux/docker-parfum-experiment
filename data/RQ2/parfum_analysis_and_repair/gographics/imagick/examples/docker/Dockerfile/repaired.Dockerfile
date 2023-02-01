FROM golang:1.11

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

# install build essentials
RUN apt-get update && \
    apt-get install -y wget build-essential pkg-config --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# Install ImageMagick deps
RUN apt-get -q -y install libjpeg-dev libpng-dev libtiff-dev \
    libgif-dev libx11-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*;

ENV IMAGEMAGICK_VERSION=6.9.10-11

RUN cd && \
	wget https://github.com/ImageMagick/ImageMagick6/archive/${IMAGEMAGICK_VERSION}.tar.gz && \
	tar xvzf ${IMAGEMAGICK_VERSION}.tar.gz && \
	cd ImageMagick* && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
					--without-magick-plus-plus \
					--without-perl \
					--disable-openmp \
					--with-gvc=no \
					--disable-docs && \
	make -j$(nproc) && make install && \
	ldconfig /usr/local/lib && rm ${IMAGEMAGICK_VERSION}.tar.gz

WORKDIR /go/projects/resizer
COPY . .

RUN go install
CMD /go/bin/resizer
