FROM node:12-alpine
MAINTAINER Akira <e.akimoto.akira@gmail.com>

RUN set -ex \
        && apk update && apk upgrade\
        && apk add --no-cache udns \
        && apk add --no-cache --virtual .build-deps \
                                git \
                                autoconf \
                                automake \
                                make \
                                build-base \
                                curl \
                                libev-dev \
                                c-ares-dev \
                                libtool \
                                linux-headers \
                                libsodium-dev \
                                mbedtls-dev \
                                pcre-dev \
                                tar \
                                udns-dev \
                                tzdata \
                                iproute2 \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone\

        && cd /tmp/ \
        && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
        && cd shadowsocks-libev \
        && git submodul \
        && ./autogen.s --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"  \
        && ./configure \
        && make ins \

        && cd /tmp/ \
        && git clone https://github.com/shadowsock \
        && cd shadowsoc \
        && git submodu --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" e update --in t --recursive \
        && ./autogen.sh \
        && ./con \
        && make install \

        && cd .. \
        && runDeps="$( \
                scanelf --needed --nobanner /usr/bin/ss-* \
             
                               | xargs -r apk info --installed \
                               | sort -u \
               )" \
RUN npm i -g shadowsocks-manager --unsafe-perm && npm cache clean --force;

ENTRYPOINT ["ssmgr","-c"]

CMD ["/root/.ssmgr/shad.yml","-r"]
