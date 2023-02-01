# Inspired by google/ruby image, but want newer Ruby versions.

FROM ubuntu

RUN apt-get update && \
    apt-get install -qy --no-install-recommends \
        autoconf \
        build-essential \
        ca-certificates \
        curl \
        wget \
        git \
        libffi-dev \
        libgdbm-dev \
        libgmp-dev \
        libncurses5-dev \
        libqdbm-dev \
        libreadline6-dev \
        libssl-dev \
        libyaml-dev \
        libz-dev \
        systemtap && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/src && rm -rf /usr/src
RUN wget https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz -O ruby.tar.gz && ls -al
RUN tar -zxf ruby.tar.gz -C /usr/src && rm ruby.tar.gz
RUN cd /usr/src/ruby-2.2.2 && \
    autoconf && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --disable-install-doc && \
    make && make install && make clean
RUN gem install -q --no-rdoc --no-ri bundler
