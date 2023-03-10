# Base Distro Arg
ARG LATEST_ALPINE_VERSION

FROM alpine:$LATEST_ALPINE_VERSION

# Build Args
ARG HYDRA_DOWNLOAD_URL

# Content
WORKDIR /hydra
ADD $HYDRA_DOWNLOAD_URL hydra.tar.gz
RUN apk --no-cache add \
        gcc \
        musl-dev \
        make \
        openssl-dev \
        libssh \
        libssh-dev \
        mariadb-connector-c \
        mariadb-connector-c-dev \
        postgresql-dev \
        mariadb-dev \
        libgpg-error-dev \
        libgcrypt-dev \
        pcre-dev \
        libidn \
        libidn-dev \
        libpq \
    && tar -xvf hydra.tar.gz -C /hydra --strip-components=1 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
    && apk del --purge \
        gcc \
        musl-dev \
        libidn-dev \
        libssh-dev \
        mariadb-connector-c-dev \
        mariadb-dev \
        postgresql-dev && rm hydra.tar.gz
ENTRYPOINT ["hydra"]