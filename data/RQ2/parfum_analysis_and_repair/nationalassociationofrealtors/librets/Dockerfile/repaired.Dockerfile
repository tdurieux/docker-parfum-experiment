FROM debian:9.5
RUN apt-get update && apt-get install --no-install-recommends -y \
build-essential \
ruby \
ruby-dev \
python3-dev \
python3-pip \
autoconf \
swig \
libboost-dev \
libboost-filesystem-dev \
libcurl4-openssl-dev \
libexpat-dev \
default-jdk && rm -rf /var/lib/apt/lists/*;
ADD . / librets/
WORKDIR /librets
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
--enable-depends \
--enable-shared_dependencies \
&& make \
&& make install
WORKDIR /
