from ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Standard 64-bit packages
RUN apt-get update && apt-get -y --no-install-recommends -qq install build-essential \
                                             software-properties-common \
                                             wget \
                                             sudo && rm -rf /var/lib/apt/lists/*;

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
ENV HOME /home/docker
WORKDIR $HOME

# Install OpenSSL as the crypto module (and for Curl)
ENV OPENSSL_INSTALL "$HOME/openssl-1.0.2r_install"
RUN wget https://www.openssl.org/source/openssl-1.0.2r.tar.gz && tar -xf openssl-1.0.2r.tar.gz && rm openssl-1.0.2r.tar.gz
RUN cd openssl-1.0.2r && ./config shared -d --prefix=$OPENSSL_INSTALL && make clean && make depend && make && make install

# Install Curl for network transport
ENV CURL_INSTALL "$HOME/curl-7.64.1_install"
RUN wget https://curl.haxx.se/download/curl-7.64.1.tar.gz && tar -xf curl-7.64.1.tar.gz && rm curl-7.64.1.tar.gz

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OPENSSL_INSTALL/lib
RUN cd curl-7.64.1 && CFLAGS="-O0 -g" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$CURL_INSTALL --with-ssl=$OPENSSL_INSTALL && make && make install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CURL_INSTALL/lib

# Add Criterion PPA for unit testing
RUN add-apt-repository ppa:snaipewastaken/ppa

RUN apt-get update && apt-get -y --no-install-recommends -qq install git \
                                             vim \
                                             emacs \
                                             iputils-ping \
                                             gdb \
                                             valgrind \
                                             criterion-dev && rm -rf /var/lib/apt/lists/*;

USER docker
CMD ["/bin/bash"]

