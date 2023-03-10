FROM commerceblock/mercury:latest AS mercury
FROM ubuntu:20.04

ENV TZ="Europe/London" \
    DEBIAN_FRONTEND=noninteractive
ENV PRIMUS_HOME=/usr/local/primus \
    PATH=$PRIMUS_HOME/bin:$PATH \
    LD_LIBRARY_PATH=$PRIMUS_HOME/lib:$LD_LIBRARY_PATH \
    PKCS11_LIB=$PRIMUS_HOME/lib/libprimusP11.so

COPY --from=mercury /usr/local/bin/mercury /usr/local/bin/mercury
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY hsm/primus.module /usr/share/p11-kit/modules/
COPY hsm/primusopenssl.cnf /usr/lib/ssl/primusopenssl.cnf
ADD hsm/primus-rhel7-1.5.6.tar /
WORKDIR /mercury

RUN set -x \
    && apt update \
    && apt install --no-install-recommends -y emacs-nox git zlib1g-dev libssl-dev git p11-kit opensc libengine-pkcs11-openssl \
    && ln -s /usr/local/primus/lib/libprimusP11.so /usr/lib/x86_64-linux-gnu/pkcs11/libprimusP11.so \
    && ln -s /usr/local/primus/lib/libprimusP11.so /usr/lib/x86_64-linux-gnu/libprimusP11.so \
    && p11-kit list-modules \
    && openssl version \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/docker-entrypoint.sh"]
