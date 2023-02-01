# Force this to build with arm64 even when the host architecture is different.
# This requires that cross-compilation support be enabled with the steps in https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/
FROM --platform=arm64 ubuntu:20.04
RUN apt-get update -y
# DEBIAN_FRONTEND=noninteractive is needed to stop the tzdata installation from hanging.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config build-essential autoconf bison re2c \
                       libxml2-dev libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

ADD . /php-src/
WORKDIR /php-src
RUN ./buildconf
# Compile a minimal debug build. --enable-debug adds runtime assertions and is slower than regular builds.
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-debug --disable-all --enable-opcache && make clean && make -j$(nproc)
