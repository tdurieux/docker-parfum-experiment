FROM debian:jessie
MAINTAINER matthewm@boedicker.org

WORKDIR /tmp

# packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends --assume-yes \
    build-essential \
    curl \
    git \
    libpq-dev \
    libsqlite3-dev \
    memcached \
    runit && rm -rf /var/lib/apt/lists/*;

# imagemagick
RUN apt-get update \
  && apt-get install -y --no-install-recommends --assume-yes \
    inkscape \
    libbz2-dev \
    libfftw3-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libjbig-dev \
    libjpeg62-turbo-dev \
    liblzma-dev \
    libpango1.0-dev \
    libpng12-dev \
    libtiff5-dev \
    libwebp-dev \
    libxml2-dev \
    pkg-config \
    zlib1g-dev \
  && curl -f https://www.imagemagick.org/download/ImageMagick-6.9.8-9.tar.xz \
    | tar xJ \
  && cd $(ls -d ImageMagick-* | head -n 1) \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install \
  && cd .. \
  && rm -rf $(ls -d ImageMagick-* | head -n 1) && rm -rf /var/lib/apt/lists/*;

# ruby
RUN apt-get update \
  && apt-get install -y --no-install-recommends --assume-yes \
    libreadline-dev \
    libssl-dev \
  && curl -f https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.1.tar.bz2 \
    | tar xj \
  && cd $(ls -d ruby-* | head -n 1) \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --disable-install-doc \
  && make \
  && make install \
  && echo 'gem: --no-document' >> "$HOME/.gemrc" \
  && gem install bundler \
  && cd .. \
  && rm -rf $(ls -d ruby-* | head -n 1) && rm -rf /var/lib/apt/lists/*;

# varnish
RUN apt-get update \
  && apt-get install -y --no-install-recommends --assume-yes \
    libjemalloc-dev \
    libncurses-dev \
    python-docutils \
  && curl -f https://repo.varnish-cache.org/source/varnish-5.1.2.tar.gz \
    | tar xz \
  && cd $(ls -d varnish-* | head -n 1) \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install \
  && cd .. \
  && rm -rf $(ls -d varnish-* | head -n 1) && rm -rf /var/lib/apt/lists/*;

# monit
RUN apt-get update \
  && apt-get install -y --no-install-recommends --assume-yes \
    libpam-dev \
    ucspi-tcp \
  && curl -f https://mmonit.com/monit/dist/monit-5.23.0.tar.gz \
    | tar xz \
  && cd $(ls -d monit-* | head -n 1) \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install \
  && mkdir -p /var/lib/monit/events \
  && cd .. \
  && rm -rf $(ls -d monit-* | head -n 1) && rm -rf /var/lib/apt/lists/*;

# cleanup
RUN apt-get clean \
  && rm -rf /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
