FROM ubuntu:16.04
MAINTAINER Linda Sato <lsato@uoregon.edu>

#apt won't find some libs if this isn't run
RUN apt-get update

# Dependencies for vips installer
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-software-properties software-properties-common && rm -rf /var/lib/apt/lists/*;

# Vips!

RUN apt-get install --no-install-recommends -y automake build-essential \
                       gtk-doc-tools libglib2.0-dev \
                       libjpeg-turbo8-dev libpng12-dev libwebp-dev libtiff5-dev libexif-dev \
                       libgsf-1-dev liblcms2-dev libxml2-dev swig libmagickcore-dev curl && rm -rf /var/lib/apt/lists/*;

RUN  mkdir -p /opt/libvips
WORKDIR /opt/libvips
RUN curl -f -L https://github.com/libvips/libvips/releases/download/v8.6.3/vips-8.6.3.tar.gz | tar zx
WORKDIR /opt/libvips/vips-8.6.3
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-debug=no --enable-docs=no --enable-cxx=yes --without-python --without-orc --without-fftw
RUN make
RUN make install
RUN ldconfig

# Various derivative libs
RUN apt-get purge libreoffice*
RUN  add-apt-repository -y ppa:libreoffice/ppa
RUN apt-get install --no-install-recommends -y poppler-utils poppler-data ghostscript libreoffice && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmagic-dev libmagickwand-dev ffmpeg libavcodec-ffmpeg-extra56 libvorbis-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y graphicsmagick graphicsmagick-libmagick-dev-compat && rm -rf /var/lib/apt/lists/*;

# Database connection libraries
RUN apt-get install --no-install-recommends -y libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

# Nodejs for compiling assets
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# We need git for all our github-hosted gems
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
# Rails requires this
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

# Dependencies for Ruby
RUN apt-get install --no-install-recommends -y libssl-dev libreadline-dev && rm -rf /var/lib/apt/lists/*;

# Grab Ruby manually
#
# Make sure this comes after the big downloads, as it's more likely we'll
# change our ruby version than, say, our vips version - at least until we deal
# with a major change (like OS) that would require a ruby rebuild anyway
RUN  mkdir -p /opt/ruby
WORKDIR /opt/ruby
RUN curl -f https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.8.tar.gz | tar zx
WORKDIR /opt/ruby/ruby-2.3.8
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

# PhantomJS dependencies
RUN apt-get install --no-install-recommends -y g++ flex bison gperf perl \
   libfontconfig1-dev libicu-dev libfreetype6 \
  libpng-dev libx11-dev libxext-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ariya/phantomjs/ /opt/phantomjs
WORKDIR /opt/phantomjs
RUN git checkout 1.8.1
RUN yes | ./build.sh
