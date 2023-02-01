FROM debian:10

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
    build-essential \
    autoconf \
    curl \
    git && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/

ARG PHP=8.1.2

# Install PHP-ZTS from source
RUN curl -f --output php-${PHP}.tar.gz https://www.php.net/distributions/php-${PHP}.tar.gz && \
  tar -xf php-${PHP}.tar.gz && cd php-${PHP} && \
  git clone --depth 1 --branch 3.2.6 https://github.com/igbinary/igbinary ext/igbinary && \
  git clone --depth 1 --branch msgpack-2.1.2 https://github.com/msgpack/msgpack-php ext/msgpack && \
  ./buildconf --force && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --enable-zts \
    --disable-all \
    --enable-json \
    --enable-igbinary \
    --with-msgpack && \
  make -j$(nproc) && \
  make install && rm php-${PHP}.tar.gz

ARG RELAY=dev

# Download Relay
RUN PHP=$(php -r "echo substr(PHP_VERSION, 0, 3);") \
  && curl -f -L "https://cachewerk.s3.amazonaws.com/relay/$RELAY/relay-$RELAY-php$PHP-debian-x86-64%2Bzts.tar.gz" | tar xz -C /tmp \
  && cd /tmp/relay-* \
  && sed -i "s/BIN:31415926-5358-9793-2384-626433832795/BIN:$(cat /proc/sys/kernel/random/uuid)/" relay-pkg.so \
  && mkdir -p $(php-config --extension-dir) \
  && cp relay-pkg.so $(php-config --extension-dir)/relay.so \
  && cat relay.ini >> $(php-config --ini-path)/php.ini
