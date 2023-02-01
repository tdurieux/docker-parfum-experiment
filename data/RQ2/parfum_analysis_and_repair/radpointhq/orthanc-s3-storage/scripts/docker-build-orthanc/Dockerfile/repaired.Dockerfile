FROM debian:buster-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -qy apt-utils && \
    apt-get install --no-install-recommends -qy \
    build-essential git mercurial cmake \
    coreutils xz-utils zip unzip wget \
    libssl-dev zlib1g-dev \
    libgnutls30 && rm -rf /var/lib/apt/lists/*;


#build custom version on curl that doesn't depend on libgnutls
#the version of curl is the same as the one linked by orthanc (Orthanc-1.4.0/Resources/CMake/LibCurlConfiguration.cmake)
RUN wget https://www.orthanc-server.com/downloads/third-party/curl-7.57.0.tar.gz && \
tar xzf curl-7.57.0.tar.gz && \
cd curl-7.57.0 && \
 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --disable-ldaps --disable-ldap --without-gnutls --without-librtmp && \
make -j4 && \
make install && rm curl-7.57.0.tar.gz

WORKDIR /app

CMD ["bash", "scripts/docker-build-orthanc/build-s3-plugin.sh"]
