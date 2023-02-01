FROM debian:testing

## Add 'contrib' repository
RUN  sed -i 's/main/main contrib/' /etc/apt/sources.list

## Some niceties for when using the container manually
RUN apt-get update && apt-get install -y emacs25-nox wget

## General dependencies
RUN apt-get update && apt-get install -y          \
cmake build-essential git                         \
libssl-dev                                        \
libcurl4-openssl-dev libtclap-dev libscrypt-dev   \
libzmq3-dev                                       \
python3 python3-pip

## Database deps

# First the ODB compiler.
RUN (cd /tmp &&                                                             \
wget http://www.codesynthesis.com/download/odb/2.4/odb_2.4.0-1_amd64.deb && \
dpkg -i odb_2.4.0-1_amd64.deb                                            && \
apt-get install -f)

RUN apt-get update && apt-get install -y          \
libsqlite3-dev libpq-dev                          \
libodb-dev libodb-pgsql-dev libodb-sqlite-dev     \
libodb-boost-dev

## Boost
RUN apt-get update && apt-get install -y libboost-all-dev

ADD . /leosac_root

RUN (cd /leosac_root/python                    && \
pip3 install -e .)

RUN (cd /tmp && mkdir build                    && \
cmake /leosac_root/                            && \
make -j10                                      && \
make install)
