FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential autoconf libgtk-3-dev libvte-2.91-dev liblua5.3-dev libpcre2-dev git xvfb && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/app
ADD . /var/app
WORKDIR /var/app

RUN autoreconf -fvi
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make check
CMD xvfb-run -a ./src/tym -u ./lua/e2e.lua
