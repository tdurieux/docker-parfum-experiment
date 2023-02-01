ARG PHP_VERSION
FROM php:$PHP_VERSION
WORKDIR /code
ENV NO_INTERACTION=1
ADD *.c *.stub.php *.h config.m4 ./
RUN phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j$(nproc)
ADD tests ./tests
