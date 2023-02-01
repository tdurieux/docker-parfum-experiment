FROM ubuntu:16.04

MAINTAINER Andrey Zheregelya

# Currently this file contains the copy of validator node but without database config.
# It also starts CLI as entrypoint by default
# And also contains tester script

ARG install_sovrin_common="pip3 install --no-cache-dir sovrin-common"
ARG install_sovrin_client="pip3 install --no-cache-dir sovrin-client"

RUN apt-get update \
    && apt-get install --no-install-recommends python3.5 libsodium18 libgmp3-dev flex bison libssl-dev bsdmainutils python3-pip -y \
    && apt-get install --no-install-recommends wget -y \
    && apt-get install --no-install-recommends git -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# TODO: use native packages when they will be ready.
RUN wget https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz \
    && tar xvf pbc-0.5.14.tar.gz \
    && cd pbc-0.5.14 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
    && cd .. && rm -rf pbc-0.5.14 pbc-0.5.14.tar.gz

RUN pip3 install --no-cache-dir --upgrade pip wheel setuptools \
    && pip3.5 install Charm-Crypto==0.43 \
    && $install_sovrin_common \
    && $install_sovrin_client

ENTRYPOINT ["sovrin"]
