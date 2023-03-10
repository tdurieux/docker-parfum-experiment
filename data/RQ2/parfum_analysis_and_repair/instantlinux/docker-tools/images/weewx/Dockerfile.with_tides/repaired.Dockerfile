FROM alpine:3.12
MAINTAINER Rich Braun "docker@instantlinux.net"
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.license=GPL-3.0 \
    org.label-schema.name=weewx \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=https://github.com/instantlinux/docker-tools

ENV ALTITUDE="100, foot" \
    LATITUDE=50.00 \
    LONGITUDE=-80.00 \
    DB_BINDING_SUFFIX=mysql \
    DB_DRIVER=weedb.mysql \
    DB_HOST=db \
    DB_NAME=weewx_a \
    DB_NAME_FORECAST=weewx_f \
    DB_USER=weewx \
    DEBUG=0 \
    DEVICE_PORT=/dev/ttyUSB0 \
    HTML_ROOT=/var/www/weewx \
    LOCATION="Anytown, USA" \
    LOGGING_INTERVAL=300 \
    RAIN_YEAR_START=7 \
    RAPIDFIRE=True \
    RSYNC_HOST=web01 \
    RSYNC_PORT=22 \
    RSYNC_DEST=/usr/share/nginx/html \
    RSYNC_USER=wx \
    SKIN=Standard \
    STATION_ID=unset \
    STATION_TYPE=Vantage \
    STATION_URL= \
    SYSLOG_DEST=/var/log/messages \
    TZ=US/Eastern \
    TZ_CODE=10 \
    WEEK_START=6 \
    WX_USER=weewx \
    XTIDE_LOCATION=unset

ARG HARMONICS_VERSION=20190620
ARG LIBTCD_VERSION=2.2.7-r2
ARG WEEWX_VERSION=4.1.1
ARG XTIDE_VERSION=2.15.1
ARG HARMONICS_SHA=879546f30761c129610f2bcca50fa1f38c043f67721eefa51cf8c5a1e949f616
ARG LIBTCD_SHA=aff1f218b84106c572d094912cd11c828e1ea212db5661cdcc0e2e6253020a94
ARG WEEWX_SHA=f9c30d6e5f491c003dfaac2a71d9e05b5a65146623d42f50837991b6f2093419
ARG WX_GROUP=dialout
ARG WX_UID=2071
ARG XTIDE_SHA=e5c4afbb17269fdde296e853f2cb84845ed1c1bb1932f780047ad71d623bc681

COPY install-input.txt requirements.txt /root/
RUN apk add --no-cache --update \
      curl freetype libjpeg libstdc++ openssh openssl python3 py3-cheetah \
      py3-configobj py3-mysqlclient py3-pillow py3-six rsync rsyslog && \
    adduser -u $WX_UID -s /bin/sh -G $WX_GROUP -D $WX_USER && \
    mkdir -p /usr/share/xtide /build/libtcd /build/xtide && cd build && \
    curl -f -sLo harmonics.tar.bz2 \
      ftp://ftp.flaterco.com/xtide/harmonics-dwf-$HARMONICS_VERSION-free.tar.bz2 && \
    curl -f -sLo libtcd.tar.bz2 \
      ftp://ftp.flaterco.com/xtide/libtcd-$LIBTCD_VERSION.tar.bz2 && \
    curl -f -sLo weewx.tar.gz \
      https://www.weewx.com/downloads/released_versions/weewx-$WEEWX_VERSION.tar.gz && \
    curl -f -sLo xtide.tar.bz2 \
      ftp://ftp.flaterco.com/xtide/xtide-$XTIDE_VERSION.tar.bz2 && \
    echo "$HARMONICS_SHA  harmonics.tar.bz2" >> /build/checksums && \
    echo "$LIBTCD_SHA  libtcd.tar.bz2" >> /build/checksums && \
    echo "$WEEWX_SHA  weewx.tar.gz" >> /build/checksums && \
    echo "$XTIDE_SHA  xtide.tar.bz2" >> /build/checksums && \
    sha256sum -c /build/checksums && \
    apk add --no-cache --virtual .fetch-deps \
      file freetype-dev g++ gawk gcc git jpeg-dev libpng-dev make musl-dev \
      py3-pip py3-wheel python3-dev zlib-dev && \
    pip install --no-cache-dir -r /root/requirements.txt && \
    ln -s python3 /usr/bin/python && \
    tar xf weewx.tar.gz --strip-components=1 && \
    cd /build && \
    ./setup.py build && ./setup.py install < /root/install-input.txt && \
    git clone -b master --depth 1 \
      https://github.com/instantlinux/weewx-WeeGreen.git \
      /home/$WX_USER/skins/WeeGreen && \
    cd /build/libtcd && \
    tar xf /build/libtcd.tar.bz2 --strip-components=1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install && \
    cd /build/xtide && \
    tar xf /build/xtide.tar.bz2 --strip-components=1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make install && \
    cd /build && tar xf harmonics.tar.bz2 --strip-components=1 && \
    mv harmonics*.tcd /usr/share/xtide/harmonics.tcd && \
    echo /usr/share/xtide > /etc/xtide.conf && \
    apk del .fetch-deps && \
    rm -fr /build /home/$WX_USER/weewx.conf.2* /home/$WX_USER/docs \
      /home/$WX_USER/skins/WeeGreen/.git \
      /root/.cache /var/cache/apk/* /var/log/* && \
    find /home/$WX_USER/bin -name '*.pyc' -exec rm '{}' +; rm weewx.tar.gz

COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
