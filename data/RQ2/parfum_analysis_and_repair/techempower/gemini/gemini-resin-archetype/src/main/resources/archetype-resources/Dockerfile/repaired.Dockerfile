FROM openjdk:11-jdk
RUN apt update -qqy && apt install --no-install-recommends -yqq curl > /dev/null && rm -rf /var/lib/apt/lists/*;

WORKDIR /resin
RUN curl -f -sL https://caucho.com/download/resin-4.0.63.tar.gz | tar xz --strip-components=1
# Taken from buildpack-deps:stretch - Resin compilation requires JAVA_HOME
# also added several missing dependencies
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        bzip2 \
        dpkg-dev \
        file \
        g++ \
        gcc \
        gcc-multilib \
        imagemagick \
        libbz2-dev \
        libc6-dev \
        libcurl4-openssl-dev \
        libdb-dev \
        libevent-dev \
        libffi-dev \
        libgdbm-dev \
        libgeoip-dev \
        libglib2.0-dev \
        libgmp-dev \
        libjpeg-dev \
        libkrb5-dev \
        liblzma-dev \
        libmagickcore-dev \
        libmagickwand-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libpng-dev \
        libpq-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libwebp-dev \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        linux-libc-dev \
        linux-headers-amd64 \
        make \
        patch \
        unzip \
        xz-utils \
        zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=`pwd` --enable-64bit
RUN make
RUN make install
RUN rm -rf webapps/*
COPY target/*.war webapps/ROOT.war

EXPOSE 8080

RUN mkdir logs
ENTRYPOINT ["java", "-Xmx512m", "-Xms512m", "-jar", "lib/resin.jar", "console"]
