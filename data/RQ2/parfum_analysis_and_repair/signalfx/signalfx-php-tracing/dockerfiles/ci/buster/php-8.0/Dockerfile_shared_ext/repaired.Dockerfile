FROM datadog/dd-trace-ci:buster AS base

ARG phpVersion
ENV PHP_INSTALL_DIR_DEBUG_ZTS_ASAN=${PHP_INSTALL_DIR}/debug-zts-asan
ENV PHP_INSTALL_DIR_DEBUG_NTS=${PHP_INSTALL_DIR}/debug
ENV PHP_INSTALL_DIR_NTS=${PHP_INSTALL_DIR}/nts
ENV PHP_VERSION=${phpVersion}

FROM base as build
ARG phpTarGzUrl
ARG phpSha256Hash
RUN set -eux; \
    curl -fsSL -o /tmp/php.tar.gz "${phpTarGzUrl}"; \
    ( echo "${phpSha256Hash}  /tmp/php.tar.gz" | sha256sum -c -) \
    tar xf /tmp/php.tar.gz -C "${PHP_SRC_DIR}" --strip-components=1; \
    rm -f /tmp/php.tar.gz; \
    cd ${PHP_SRC_DIR}; \
    ./buildconf --force;
COPY configure_shared_ext.sh /home/circleci/configure.sh

FROM build as php-debug-zts-asan
ENV CFLAGS='-fsanitize=address -DZEND_TRACK_ARENA_ALLOC'
ENV LDFLAGS='-fsanitize=address'
RUN set -eux; \
    mkdir -p /tmp/build-php && cd /tmp/build-php; \
    /home/circleci/configure.sh \
        --enable-debug \
        --enable-zts \
        --prefix=${PHP_INSTALL_DIR_DEBUG_ZTS_ASAN} \
        --with-config-file-path=${PHP_INSTALL_DIR_DEBUG_ZTS_ASAN} \
        --with-config-file-scan-dir=${PHP_INSTALL_DIR_DEBUG_ZTS_ASAN}/conf.d; \
    make -j "$((`nproc`+1))"; \
    make install; \
    mkdir -p ${PHP_INSTALL_DIR_DEBUG_ZTS_ASAN}/conf.d;

FROM build as php-debug
RUN set -eux; \
    mkdir -p /tmp/build-php && cd /tmp/build-php; \
    /home/circleci/configure.sh \
        --enable-debug \
        --prefix=${PHP_INSTALL_DIR_DEBUG_NTS} \
        --with-config-file-path=${PHP_INSTALL_DIR_DEBUG_NTS} \
        --with-config-file-scan-dir=${PHP_INSTALL_DIR_DEBUG_NTS}/conf.d; \
    make -j "$((`nproc`+1))"; \
    make install; \
    mkdir -p ${PHP_INSTALL_DIR_DEBUG_NTS}/conf.d;

FROM build as php-nts
RUN set -eux; \
    mkdir -p /tmp/build-php && cd /tmp/build-php; \
    /home/circleci/configure.sh \
        --prefix=${PHP_INSTALL_DIR_NTS} \
        --with-config-file-path=${PHP_INSTALL_DIR_NTS} \
        --with-config-file-scan-dir=${PHP_INSTALL_DIR_NTS}/conf.d; \
    make -j "$((`nproc`+1))"; \
    make install; \
    mkdir -p ${PHP_INSTALL_DIR_NTS}/conf.d;

FROM base as final
COPY --chown=circleci:circleci --from=build $PHP_SRC_DIR $PHP_SRC_DIR
COPY --chown=circleci:circleci --from=php-debug-zts-asan $PHP_INSTALL_DIR_DEBUG_ZTS_ASAN $PHP_INSTALL_DIR_DEBUG_ZTS_ASAN
COPY --chown=circleci:circleci --from=php-debug $PHP_INSTALL_DIR_DEBUG_NTS $PHP_INSTALL_DIR_DEBUG_NTS
COPY --chown=circleci:circleci --from=php-nts $PHP_INSTALL_DIR_NTS $PHP_INSTALL_DIR_NTS

# Build core extensions as shared libraries.
# We intentionally do not run 'make install' here so that we can test the
# scenario where headers are not installed for the shared library.
RUN set -eux; \
    for phpVer in $(ls ${PHP_INSTALL_DIR}); \
    do \
        echo "Build shared extensions for PHP ${phpVer}..."; \
        switch-php ${phpVer}; \
        mkdir -p $(php-config --extension-dir); \

        # ext/curl
        echo "Building ext/curl..."; \
        cd ${PHP_SRC_DIR}/ext/curl; \
        phpize; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; \
        mv ./modules/*.so $(php-config --extension-dir); \
        make clean; phpize --clean; \

        # ext/pdo
        echo "Building ext/pdo..."; \
        cd ${PHP_SRC_DIR}/ext/pdo; \
        phpize; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; \
        mv ./modules/*.so $(php-config --extension-dir); \
        make clean; phpize --clean; \


    done;

RUN set -eux; \
# Set the default PHP version
    switch-php debug;

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

COPY welcome /etc/motd

CMD ["php-fpm", "-F"]
