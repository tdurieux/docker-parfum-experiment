FROM ubuntu:20.04

WORKDIR /root/

ENV GOPATH=/usr/local/go
ENV DEBIAN_FRONTEND=noninteractive
ENV SWOOLE_VERSION=v4.4.16
# Install
RUN apt update

RUN apt install --no-install-recommends -y mysql-client git build-essential unzip make golang cmake flex bison python3 \
    && apt install --no-install-recommends -y libprotobuf-dev libprotobuf-c-dev zlib1g-dev libssl-dev \
    && apt install --no-install-recommends -y curl wget net-tools iproute2 \
    #intall php tars
    && apt install --no-install-recommends -y php php-dev php-cli php-gd php-curl php-mysql \
    && apt install --no-install-recommends -y php-zip php-fileinfo php-redis php-mbstring tzdata git make wget \
    && apt install --no-install-recommends -y build-essential libmcrypt-dev php-pear \
    # Get and install nodejs
    && apt install --no-install-recommends -y npm \
    && npm install -g npm pm2 n \
    && n install v16.13.0 \
    # Get and install JDK
    && apt install --no-install-recommends -y openjdk-11-jdk \
    && apt clean \
    && rm -rf /var/cache/apt && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Clone Tars repo and init php submodule
RUN cd /root/ && git clone https://github.com/TarsCloud/Tars.git \
    && cd /root/Tars/ \
    && git submodule update --init --recursive php \
    #intall PHP Tars module
    && cd /root/Tars/php/tars-extension/ && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-phptars && make && make install \
    && echo "extension=phptars.so" > /etc/php/7.4/cli/conf.d/10-phptars.ini \
    # Install PHP swoole module
    && cd /root && git clone https://github.com/swoole/swoole \
    && cd /root/swoole && git checkout $SWOOLE_VERSION \
    && cd /root/swoole \
    && phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-php-config=/usr/bin/php-config \
    && make \
    && make install \
    && echo "extension=swoole.so" > /etc/php/7.4/cli/conf.d/20-swoole.ini \
    # Do somethine clean
    && cd /root && rm -rf swoole \
    && mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars
