FROM ubuntu:14.04
MAINTAINER EMC{code} <http://community.emccode.com>

# Install Dependencies

RUN apt-get update -q --fix-missing
RUN apt-get -qy install software-properties-common # (for add-apt-repository)
RUN add-apt-repository ppa:george-edison55/cmake-3.x
RUN apt-get update -q
RUN apt-cache policy cmake
RUN apt-get -qy install \
  autoconf                                \
  automake                                \
  build-essential                         \
  ca-certificates                         \
  cmake=3.2.2-2~ubuntu14.04.1~ppa1        \
  curl                                    \
  g++                                     \
  git-core                                \
  gdb                                     \
  heimdal-clients                         \
  libapr1-dev                             \
  libboost-dev                            \
  libcurl4-nss-dev                        \
  libffi-dev                              \
  libgoogle-glog-dev                      \
  libprotobuf-dev                         \
  libpython-dev                           \
  libsasl2-dev                            \
  libsasl2-modules-gssapi-heimdal         \
  libssl-dev                              \
  libsvn-dev                              \
  libtool                                 \
  make                                    \
  python                                  \
  python2.7                               \
  python-dev                              \
  python-pip                              \
  python-protobuf                         \
  python-setuptools                       \
  unzip                                   \
  wget                                    \
  --no-install-recommends

RUN pip install --upgrade pip
RUN pip install --upgrade pyopenssl ndg-httpsclient pyasn1

# Install the picojson headers
RUN wget https://raw.githubusercontent.com/kazuho/picojson/v1.3.0/picojson.h -O /usr/local/include/picojson.h

# Prepare to build Mesos
RUN mkdir -p /mesos
RUN mkdir -p /tmp
RUN mkdir -p /usr/share/java/
RUN wget http://search.maven.org/remotecontent?filepath=com/google/protobuf/protobuf-java/2.6.1/protobuf-java-2.6.1.jar -O protobuf.jar
RUN mv protobuf.jar /usr/share/java/

WORKDIR /mesos
ENV LD_LIBRARY_PATH /usr/local/lib

ENV PROTOBUF_DEST /mesos/3rdparty/libprocess/3rdparty

#ENV MESOS_VERSION=0.23.1 GIT_CHECKOUT_HASH=a9ea8b1 PROTOBUF_VERSION=2.5.0 PROTOBUF_SOURCE=/mesos/3rdparty/libprocess/3rdparty
#ENV MESOS_VERSION=0.24.2 GIT_CHECKOUT_HASH=e2eb20b PROTOBUF_VERSION=2.5.0 PROTOBUF_SOURCE=/mesos/3rdparty/libprocess/3rdparty
#ENV MESOS_VERSION=0.25.1 GIT_CHECKOUT_HASH=c46b9c8 PROTOBUF_VERSION=2.5.0 PROTOBUF_SOURCE=/mesos/3rdparty/libprocess/3rdparty
#ENV MESOS_VERSION=0.26.1 GIT_CHECKOUT_HASH=a041e3a PROTOBUF_VERSION=2.5.0 PROTOBUF_SOURCE=/mesos/3rdparty/libprocess/3rdparty
#ENV MESOS_VERSION=0.26.2 GIT_CHECKOUT_HASH=5edc7ba PROTOBUF_VERSION=2.5.0 PROTOBUF_SOURCE=/mesos/3rdparty/libprocess/3rdparty
#ENV MESOS_VERSION=0.27.2 GIT_CHECKOUT_HASH=3c9ec4a PROTOBUF_VERSION=2.5.0 PROTOBUF_SOURCE=/mesos/3rdparty/libprocess/3rdparty
#ENV MESOS_VERSION=0.27.3 GIT_CHECKOUT_HASH=68dd1f6 PROTOBUF_VERSION=2.5.0 PROTOBUF_SOURCE=/mesos/3rdparty/libprocess/3rdparty
#ENV MESOS_VERSION=0.28.2 GIT_CHECKOUT_HASH=ceecad6 PROTOBUF_VERSION=2.5.0 PROTOBUF_SOURCE=/mesos/3rdparty/libprocess/3rdparty
#ENV MESOS_VERSION=0.28.3 GIT_CHECKOUT_HASH=52a0b0a PROTOBUF_VERSION=2.5.0 PROTOBUF_SOURCE=/mesos/3rdparty/libprocess/3rdparty
#ENV MESOS_VERSION=1.0.0 GIT_CHECKOUT_HASH=c9b7058 PROTOBUF_VERSION=2.6.1 PROTOBUF_SOURCE=/mesos/3rdparty
#ENV MESOS_VERSION=1.0.1 GIT_CHECKOUT_HASH=3611eb0 PROTOBUF_VERSION=2.6.1 PROTOBUF_SOURCE=/mesos/3rdparty
#ENV MESOS_VERSION=1.1.0 GIT_CHECKOUT_HASH=a44b077 PROTOBUF_VERSION=2.6.1 PROTOBUF_SOURCE=/mesos/3rdparty
#ENV MESOS_VERSION=1.2.0 GIT_CHECKOUT_HASH=de306b5 PROTOBUF_VERSION=2.6.1 PROTOBUF_SOURCE=/mesos/3rdparty
ENV MESOS_VERSION=1.2.1 GIT_CHECKOUT_HASH=7a0cc55 PROTOBUF_VERSION=2.6.1 PROTOBUF_SOURCE=/mesos/3rdparty
ENV ISOLATOR_VERSION $MESOS_VERSION
ENV GIT_SOURCE git://git.apache.org/mesos.git

# Clone Mesos
RUN git clone $GIT_SOURCE /mesos
RUN git checkout $GIT_CHECKOUT_HASH
RUN git log -n 1

# Install protobuf
RUN mkdir -p $PROTOBUF_DEST
RUN cd ${PROTOBUF_SOURCE} && tar -xzvf protobuf-${PROTOBUF_VERSION}.tar.gz -C ${PROTOBUF_DEST} && cd ${PROTOBUF_DEST}/protobuf-${PROTOBUF_VERSION}/ && ./configure --prefix=/usr && make -j 2 && make install

# Bootstrap
RUN ./bootstrap

# Configure
RUN mkdir build && cd build && ../configure --disable-java --disable-optimize --without-included-zookeeper --with-glog=/usr/local --with-protobuf=/usr --with-boost=/usr/local

# Build Mesos
RUN cd build && make -j 2 install

# Install python eggs
RUN easy_install /mesos/build/src/python/dist/mesos.interface-*.egg
#RUN easy_install /mesos/build/src/python/dist/mesos.native-*.egg

# This image builds mesos and retains the resulting headers and binaries.
# It is intended to support mesos isolator module development and production builds.
# A source code tree for the isolator should be mounted at /isolator if using the default entrypoint.

VOLUME ["/isolator"]

COPY ./docker-isolator-entrypoint.sh /
ENTRYPOINT ["/docker-isolator-entrypoint.sh"]
CMD ["/usr/bin/make", "all"]

# To build Docker image:
# docker build -t <docker-user-name>/mesos-build-module-dev:<ver> -f Dockerfile-mesos-modules-dev .

# default COMMAND simply builds isolator
# use it like this:
# docker run -ti -v <path-to-git-clone>/mesos-module-dvdi/isolator/:/isolator <docker-user-name>/mesos-build-module-dev:<ver>

# to extract the newly built .so to the mounted source directory volume mount - you should over-ride the default CMD like this:
# docker run -ti -v <path-to-git-clone>/mesos-module-dvdi/isolator/:/isolator <docker-user-name>/mesos-build-module-dev:<ver> /bin/bash -c  '/usr/bin/make all && cp /isolator/build/.libs/libmesos_dvdi_isolator-${ISOLATOR_VERSION}.so /isolator/'
