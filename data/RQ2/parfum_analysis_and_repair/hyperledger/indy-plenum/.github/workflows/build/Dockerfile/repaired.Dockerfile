FROM hyperledger/indy-core-baseci:0.0.3-master
LABEL maintainer="Hyperledger <hyperledger-indy@lists.hyperledger.org>"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 \
    && apt-get update -y \
    && apt-get install --no-install-recommends -y \
    python3-nacl \
    libindy-crypto=0.4.5 \
    libindy=1.16.0~1636-xenial \

    libbz2-dev \
    zlib1g-dev \
    liblz4-dev \
    libsnappy-dev \
    rocksdb=5.8.8 \
    ursa=0.3.2-2 \

    ruby \
    ruby-dev \
    rubygems \
    gcc \
    make \

    zstd && rm -rf /var/lib/apt/lists/*;

# install fpm
RUN gem install --no-ri --no-rdoc rake fpm

RUN indy_image_clean