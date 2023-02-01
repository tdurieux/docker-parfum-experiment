FROM ubuntu:14.04
MAINTAINER Daniel Watkins <daniel@daniel-watkins.co.uk>

RUN apt-get update && apt-get -y --no-install-recommends install git scons ctags pkg-config protobuf-compiler libprotobuf-dev libssl-dev python-software-properties libboost1.55-all-dev nodejs build-essential npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade


# build libsodium
ADD https://github.com/jedisct1/libsodium/releases/download/1.0.0/libsodium-1.0.0.tar.gz libsodium-1.0.0.tar.gz
RUN tar zxf libsodium-1.0.0.tar.gz && cd libsodium-1.0.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && rm libsodium-1.0.0.tar.gz

# build stellard
ADD . /stellard-src
RUN cd /stellard-src && scons && npm install && npm cache clean --force;

# setup data dir
RUN mkdir -p /var/lib/stellard

# add helper script
RUN ln -nfs /stellard-src/vagrant/stellar-private-ledger /usr/local/bin/stellar-private-ledger
RUN chmod a+x /stellard-src/vagrant/stellar-private-ledger
RUN ln -nfs /stellard-src/vagrant/stellar-public-ledger /usr/local/bin/stellar-public-ledger
RUN chmod a+x /stellard-src/vagrant/stellar-public-ledger

VOLUME "/var/lib/stellard"
EXPOSE 9101 9102 52101
CMD /usr/local/bin/stellar-public-ledger
