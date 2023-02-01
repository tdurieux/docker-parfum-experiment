FROM gcc:latest

# dependencies
RUN apt-get -y update && apt-get install -y --no-install-recommends build-essential libreadline-dev autoconf-archive libgmp-dev expect flex bison automake m4 libtool pkg-config && rm -rf /var/lib/apt/lists/*;

# build
COPY . /usr/src/bic
WORKDIR /usr/src/bic
RUN autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make check && make install

# run
CMD ["bic"]
