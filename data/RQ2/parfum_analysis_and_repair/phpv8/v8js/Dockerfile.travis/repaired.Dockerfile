FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV NO_INTERACTION=1
ENV REPORT_EXIT_STATUS=1

RUN apt-get update -q
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:ondrej/php
RUN add-apt-repository ppa:stesie/libv8 -y
RUN apt-get update -q

RUN apt-get install --no-install-recommends -y php$PHPVER-dev libv8-$V8VER-dev && rm -rf /var/lib/apt/lists/*;

ADD . /app
WORKDIR /app

RUN phpize
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CXXFLAGS="-Wall -Wno-write-strings" LDFLAGS="-lstdc++" --with-v8js=/opt/libv8-$V8VER/
RUN make -j4
