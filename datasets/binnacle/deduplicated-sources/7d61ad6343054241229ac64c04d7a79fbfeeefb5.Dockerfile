FROM debian:jessie

## Add APT 'contrib' repository
RUN  sed -i 's/main/main contrib/' /etc/apt/sources.list
RUN cp /etc/apt/sources.list /etc/apt/sources.list.back

## Add Debian testing repository
RUN echo 'deb http://ftp.fr.debian.org/debian/ stretch main contrib' >> /etc/apt/sources.list
RUN echo 'deb-src http://ftp.fr.debian.org/debian/ stretch main contrib' >> /etc/apt/sources.list

## Tools
RUN apt-get update && apt-get install -y emacs24-nox wget \
libboost-serialization-dev libboost-regex-dev \
libboost-system-dev libboost-filesystem-dev libboost-date-time-dev \
build-essential git libtool-bin \
libtclap-dev cmake -y \
autotools-dev automake pkg-config libsodium-dev \
libgtest-dev python valgrind python-pip libpython2.7-dev \
libcurl4-openssl-dev

# Database runtime libraries. Required by ODB.
RUN apt-get update && apt-get install -y libsqlite3-dev libmysqlclient-dev libpq-dev -y

RUN pip install pyzmq

RUN apt-get update && apt-get install python3 python3-pip -y
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 2
RUN pip3 install pyzmq

RUN apt-get update && apt-get install -y libscrypt-dev libssl-dev

RUN git clone git://github.com/zeromq/libzmq.git; \
cd libzmq; \
git checkout v4.2.1; \
./autogen.sh; \
./configure --with-libsodium; \
make check || echo ${Red}"Warning: ZeroMQ tests failed. The build will continue but may fail."${RCol}; \
make install; \
ldconfig;

# Container config
CMD [""]
ENTRYPOINT ["/docker_scripts/entry.sh"]
EXPOSE 8888

## we mount leosac source dir in read only
VOLUME /leosac_src
VOLUME /docker_scripts

ADD docker_scripts /docker_scripts
RUN /docker_scripts/odb_install.sh
RUN /docker_scripts/gtest_install.sh

RUN apt-get update && apt-get install postgresql-client-9.6 -y
RUN apt-get update && apt-get install libboost-coroutine-dev -y

## This is way too verbose, but we don't have a choice...
## We want the necessary files to build, not the tests scripts and all.
## Otherwise, just editing a test-script would cause full rebuild ...
RUN mkdir -p /leosac_src/{cmake,cfg,docker_scripts,libmcp23s17,libpifacedigital,libzmq,scripts,spdlog,src,test,tools,zmqpp,test_helper}

ADD cfg /leosac_src/cfg/
ADD docker_scripts /leosac_src/docker_scripts/
ADD scripts /leosac_src/scripts/
ADD test /leosac_src/test/
ADD deps /leosac_src/deps/
ADD cmake /leosac_src/cmake/
ADD src /leosac_src/src/
ADD CMakeLists.txt /leosac_src/

RUN /docker_scripts/build_leosac.sh
ADD test_helper /leosac_src/test_helper

