FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf \
  automake \
  bison \
  build-essential \
  curl \
  libsqlite3-dev \
  libtool \
  libxml2-dev \
  re2c && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
ARG VERSION=8.1.1
RUN curl -f -o php-${VERSION}.tar.gz https://www.php.net/distributions/php-${VERSION}.tar.gz
RUN tar -zxf php-${VERSION}.tar.gz && rm php-${VERSION}.tar.gz

WORKDIR /root/php-${VERSION}
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
