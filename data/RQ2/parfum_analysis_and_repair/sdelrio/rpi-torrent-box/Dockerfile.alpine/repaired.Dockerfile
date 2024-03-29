ARG BASE_IMAGE=alpine:3.8

FROM $BASE_IMAGE

USER root

RUN apk add --no-cache openssl c-ares libssl1.0 libxml2 cppunit apache2-utils nginx php5-cli php5-fpm geoip supervisor unzip unrar mediainfo sox && \
    openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout /etc/ssl/private/rutorrent.key -out /etc/ssl/private/rutorrent.crt -subj /CN=rutorrent && \
    chmod 600 /etc/ssl/private/rutorrent.key

#RUN apt-get update && \
#    apt-get install -y libc-ares2 libssl1.0.0 libxml2 libcppunit-1.13-0 && \
#    apt-get install -y --no-install-recommends openssl apache2-utils nginx php5-cli php5-fpm geoip-database php5-geoip && \
#    apt-get install -y --force-yes unzip unrar-free mediainfo python-setuptools sox && \
#    openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout /etc/ssl/private/rutorrent.key -out /etc/ssl/private/rutorrent.crt -subj /CN=rutorrent && \
#    chmod 600 /etc/ssl/private/rutorrent.key && \
#    easy_install supervisor && \
#    apt-get autoremove -y; apt-get clean; rm /var/lib/apt/lists/* -r; rm -rf /usr/share/man/*
#
# TODO FFMPEG

# Compiled curl

ENV CURL_VERSION 7.39.0
ENV CURL_LIB libcurl.so.4.5.0

RUN ls -la /usr/local/bin
COPY build/curl-${CURL_VERSION}/src/.libs/curl build/curl-${CURL_VERSION}/curl-config /usr/local/bin/
COPY build/curl-${CURL_VERSION}/src/.libs/curl build/curl-${CURL_VERSION}/curl-config /usr/local/bin/
COPY build/curl-${CURL_VERSION}/lib/.libs/${CURL_LIB} /usr/local/lib/${CURL_LIB}
RUN ln -s /usr/local/lib/${CURL_LIB} /usr/local/lib/libcurl.so
RUN ln -s /usr/local/lib/${CURL_LIB} /usr/local/lib/libcurl.so.4
RUN ls -la /usr/local/bin
RUN ls -la /usr/local/lib
RUN ldd /usr/local/lib/libcurl.so.4
RUN ldd /usr/local/bin/curl
#RUN ldconfig

RUN curl -f --version && \
    curl -f -LOks https://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && \
    gunzip GeoLiteCity.dat.gz && \
    mkdir -p /usr/share/GeoIP && \
    mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat


# XMLRPC
# find build/xmlrpc-c/ -type f -perm +111

COPY build/xmlrpc-c/src/libxmlrpc_server.so.3.42 \
     build/xmlrpc-c/src/libxmlrpc.so.3.42 \
     build/xmlrpc-c/lib/libutil/libxmlrpc_util.so.3.42 \
     \
     /usr/local/lib/

#     build/xmlrpc-c/src/cpp/libxmlrpc_server_pstream++.so.8.42 \
#     build/xmlrpc-c/src/cpp/libxmlrpc_packetsocket.so.8.42 \
#     build/xmlrpc-c/src/cpp/libxmlrpc_server_cgi++.so.8.42 \
#     build/xmlrpc-c/src/cpp/libxmlrpc_server++.so.8.42 \
#     build/xmlrpc-c/src/cpp/libxmlrpc++.so.8.42 \
#     build/xmlrpc-c/src/cpp/libxmlrpc_cpp.so.8.42 \

#COPY build/xmlrpc-c/src/libxmlrpc.a \
#     build/xmlrpc-c/src/libxmlrpc_server.a \
#     build/xmlrpc-c/src/cpp/libxmlrpc_server_pstream++.a \
#     build/xmlrpc-c/src/cpp/libxmlrpc_packetsocket.a \
#     build/xmlrpc-c/src/cpp/libxmlrpc_server_cgi++.a \
#     build/xmlrpc-c/src/cpp/libxmlrpc_server++.a \
#     build/xmlrpc-c/src/cpp/libxmlrpc++.a \
#     build/xmlrpc-c/src/cpp/libxmlrpc_cpp.a \
#     build/xmlrpc-c/lib/libutil/libxmlrpc_util.a \
#     \
#     /usr/local/lib/

RUN ln -s /usr/local/lib/libxmlrpc.so.3.42 /usr/local/lib/libxmlrpc.so.3 && \
    ln -s /usr/local/lib/libxmlrpc.so.3.42 /usr/local/lib/libxmlrpc.so && \
    ln -s /usr/local/lib/libxmlrpc_server.so.3.42 /usr/local/lib/libxmlrpc_server.so.3 && \
    ln -s /usr/local/lib/libxmlrpc_server.so.3.42 /usr/local/lib/libxmlrpc_server.so && \
    ln -s /usr/local/lib/libxmlrpc_util.so.3.42 /usr/local/lib/libxmlrpc_util.so.3 && \
    ln -s /usr/local/lib/libxmlrpc_util.so.3.42 /usr/local/lib/libxmlrpc_util.so

#    ln -s /usr/local/lib/libxmlrpc++.so.8.42 /usr/local/lib/libxmlrpc++.so.8 && \
#    ln -s /usr/local/lib/libxmlrpc++.so.8.42 /usr/local/lib/libxmlrpc++.so && \
#    ln -s /usr/local/lib/libxmlrpc_cpp.so.8.42 /usr/local/lib/libxmlrpc_cpp.so.8 && \
#    ln -s /usr/local/lib/libxmlrpc_cpp.so.8.42 /usr/local/lib/libxmlrpc_cpp.so && \
#    ln -s /usr/local/lib/libxmlrpc_packetsocket.so.8.42 /usr/local/lib/libxmlrpc_packetsocket.so.8 && \
#    ln -s /usr/local/lib/libxmlrpc_packetsocket.so.8.42 /usr/local/lib/libxmlrpc_packetsocket.so && \
#    ln -s /usr/local/lib/libxmlrpc_server_cgi++.so.8.42 /usr/local/lib/libxmlrpc_server_cgi++.so.8 && \
#    ln -s /usr/local/lib/libxmlrpc_server_cgi++.so.8.42 /usr/local/lib/libxmlrpc_server_cgi++.so && \
#    ln -s /usr/local/lib/libxmlrpc_server_pstream++.so.8.42 /usr/local/lib/libxmlrpc_server_pstream++.so.8 && \
#    ln -s /usr/local/lib/libxmlrpc_server_pstream++.so.8.42 /usr/local/lib/libxmlrpc_server_pstream++.so && \
#    ln -s /usr/local/lib/libxmlrpc_util++.so.8.42 /usr/local/lib/libxmlrpc_util++.so.8 && \
#    ln -s /usr/local/lib/libxmlrpc_util++.so.8.42 /usr/local/lib/libxmlrpc_util++.so && \

#    ln -s /usr/local/lib/libxmlrpc_server++.so.8.42 /usr/local/lib/libxmlrpc_server++.so.8 && \
#    ln -s /usr/local/lib/libxmlrpc_server++.so.8.42 /usr/local/lib/libxmlrpc_server++.so && \

COPY build/xmlrpc-c/xmlrpc-c-config /usr/local/bin/

# LIBTORRENT

ENV VER_LIBTORRENT 0.13.7

# build/libtorrent-0.13.6/src/.libs/libtorrent.la \
COPY build/libtorrent-${VER_LIBTORRENT}/src/.libs/libtorrent.so.20.0.0 \
     \
     /usr/local/lib/

RUN ln -s /usr/local/lib/libtorrent.so.19.0.0 /usr/local/lib/libtorrent.so.19 && \
    ln -s /usr/local/lib/libtorrent.so.19.0.0 /usr/local/lib/libtorrent.so

# RTORRENT

ENV VER_RTORRENT 0.9.7

## Copy compiled binary

COPY build/rtorrent-${VER_RTORRENT}/src/rtorrent /usr/local/bin/

## Basic rtorrent config for first start

COPY rtorrent/config/.rtorrent.rc /usr/local/src/.rtorrent.rc

## rTorrent startup script

COPY rtorrent/runrtorrent.sh /usr/local/src/runrtorrent.sh

RUN ldconfig
#
#root@d230e572d855:/# ldd /usr/local/bin/rtorrent
# linux-vdso.so.1 (0x00007ffd8c9cc000)
# libncurses.so.5 => /lib/x86_64-linux-gnu/libncurses.so.5 (0x00007f1347450000)
# libtinfo.so.5 => /lib/x86_64-linux-gnu/libtinfo.so.5 (0x00007f1347226000)
# libcurl.so.4 => /usr/local/lib/libcurl.so.4 (0x00007f1346fc5000)
# libtorrent.so.19 => /usr/local/lib/libtorrent.so.19 (0x00007f1346cb6000)
# libxmlrpc_server.so.3 => /usr/local/lib/libxmlrpc_server.so.3 (0x00007f1346ab0000)
# libxmlrpc.so.3 => /usr/local/lib/libxmlrpc.so.3 (0x00007f1346894000)
# libxml2.so.2 => /usr/lib/x86_64-linux-gnu/libxml2.so.2 (0x00007f134652d000)
# libxmlrpc_util.so.3 => /usr/local/lib/libxmlrpc_util.so.3 (0x00007f1346328000)
# libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f134610b000)
# libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f1345e00000)
# libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f1345aff000)
# libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f13458e9000)
# libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f134553e000)
# libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f134533a000)
# libcares.so.2 => /usr/lib/x86_64-linux-gnu/libcares.so.2 (0x00007f1345128000)
# libssl.so.1.0.0 => /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 (0x00007f1344ec7000)
# libcrypto.so.1.0.0 => /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 (0x00007f1344aca000)
# libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f13448af000)
# liblzma.so.5 => /lib/x86_64-linux-gnu/liblzma.so.5 (0x00007f134468c000)
# /lib64/ld-linux-x86-64.so.2 (0x00007f1347675000)


# RUTORRENT

## Download base for ruTorent

COPY rutorrent/getrutorrent.sh /usr/local/src/getrutorrent.sh
RUN /usr/local/src/getrutorrent.sh

## ruTorrent Base configuration

COPY rutorrent/config/config.php /usr/local/src/config.php

## Configure rtorrent user

RUN useradd -d /home/rtorrent -m -s /bin/bash rtorrent
RUN chown -R rtorrent:rtorrent /home/rtorrent

# NGINX

## Base ruTorrent startup with NGinx no-daemon mode

COPY rutorrent/runrutorrent.sh /usr/local/src/runrutorrent.sh

## Base configuration for NGinx

COPY nginx/config/rutorrent.conf     /etc/nginx/sites-enabled/default
COPY nginx/config/rutorrent-ssl.conf /etc/nginx/sites-enabled/tls
COPY nginx/config/nginx.conf         /etc/nginx/nginx.conf

# SUPERVISORD

## Configure supervisor

ADD supervisord/supervisord-php5.conf /etc/supervisor/supervisord.conf

ENV VERSION 1.20

# Ports

EXPOSE 80
EXPOSE 443
EXPOSE 49160
EXPOSE 49161

# Volume for data and rtorrent configuration

VOLUME /rtorrent

#  Change the default login/password of ruTorrent

ENV WEB_USER=user
ENV WEB_PASS=password

RUN PASSWORD="$WEB_PASS";SALT="$(openssl rand -base64 3)";SHA1=$(printf "$PASSWORD$SALT" | openssl dgst -binary -sha1 | sed 's#$#'"$SALT"'#' | base64);printf "$WEB_USER:{SSHA}$SHA1\n" >>  /usr/share/nginx/html/rutorrent/.htpasswd

CMD ["supervisord"]
#CMD ["curl", "-s", "http://ipinfo.io/ip"]

