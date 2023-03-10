FROM alpine:3.10 as rootfs-stage

# environment
ENV REL=v3.12
ENV ARCH=x86
ENV MIRROR=http://dl-cdn.alpinelinux.org/alpine
ENV PACKAGES=alpine-baselayout,\
alpine-keys,\
apk-tools,\
busybox,\
libc-utils,\
xz

# install packages
RUN \
 apk add --no-cache \
	bash \
	curl \
	tzdata \
	xz

# fetch builder script from gliderlabs
RUN \
 curl -f -o \
 /mkimage-alpine.bash -L \
	https://raw.githubusercontent.com/gliderlabs/docker-alpine/master/builder/scripts/mkimage-alpine.bash && \
 chmod +x \
	/mkimage-alpine.bash && \
 ./mkimage-alpine.bash && \
 mkdir /root-out && \
 tar xf \
	/rootfs.tar.xz -C \
	/root-out && \
 sed -i -e 's/^root::/root:!:/' /root-out/etc/shadow && rm /rootfs.tar.xz

# Runtime stage
FROM scratch
COPY --from=rootfs-stage /root-out/ /
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheLamer"

# set version for s6 overlay
ARG OVERLAY_VERSION="v2.1.0.2"
ARG OVERLAY_ARCH="x86"

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer /tmp/
RUN chmod +x /tmp/s6-overlay-${OVERLAY_ARCH}-installer && /tmp/s6-overlay-${OVERLAY_ARCH}-installer / && rm /tmp/s6-overlay-${OVERLAY_ARCH}-installer

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
HOME="/root" \
TERM="xterm"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	tar && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	bash \
	ca-certificates \
	coreutils \
	procps \
	shadow \
	tzdata && \
 echo "**** create abc user and make our folders ****" && \
 groupmod -g 1000 users && \
 useradd -u 911 -U -d /config -s /bin/false abc && \
 usermod -G users abc && \
 mkdir -p \
	/app \
	/config \
	/defaults && \
 mv /usr/bin/with-contenv /usr/bin/with-contenvb && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root-i386/ /


# install packages
RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
	apache2-utils \
	git \
	libressl3.1-libssl \
	logrotate \
	nano \
	nginx \
	openssl \
	php7 \
	php7-fileinfo \
	php7-fpm \
	php7-json \
       php7-gettext \
	php7-mbstring \
	php7-openssl \
	php7-session \
	php7-simplexml \
	php7-xml \
	php7-xmlwriter \
	php7-zlib && \
 echo "**** configure nginx ****" && \
 echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> \
	/etc/nginx/fastcgi_params && \
 rm -f /etc/nginx/conf.d/default.conf && \
 echo "**** fix logrotate ****" && \
 sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
 sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
	/etc/periodic/daily/logrotate


# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="BarcodeBuddy DevBuild Build-date: ${BUILD_DATE} Based on: ${VERSION}"
LABEL maintainer="Marc Ole Bulling"



RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies git && \
 echo "**** Installing runtime packages ****" && \
 apk add --no-cache \
        curl \
        evtest \
        php7 \
        php7-curl \
        php7-openssl \
        php7-pdo \
        php7-gettext \
        php7-mbstring \
        php7-pdo_sqlite \
        php7-sqlite3 \
        php7-sockets \
        php7-redis \
        redis \
        screen \
        sudo
RUN \
echo "**** Installing BarcodeBuddy ****" && \
 mkdir -p /app/bbuddy/ && \
 git clone https://github.com/Forceu/barcodebuddy.git /app/bbuddy/ &&  \
 rm -r /app/bbuddy/.git/ && \
   sed -i 's/[[:blank:]]*const[[:blank:]]*IS_DOCKER[[:blank:]]*=[[:blank:]]*false;/const IS_DOCKER = true;/g' /app/bbuddy/config-dist.php && \
 echo "Set disable_coredump false" > /etc/sudo.conf && \
sed -i 's/SCRIPT_LOCATION=.*/SCRIPT_LOCATION="\/app\/bbuddy\/index.php"/g' /app/bbuddy/example/grabInput.sh && \
 sed -i 's/pm.max_children = 5/pm.max_children = 20/g' /etc/php7/php-fpm.d/www.conf && \
sed -i 's/WWW_USER=.*/WWW_USER="abc"/g' /app/bbuddy/example/grabInput.sh && \
sed -i 's/IS_DOCKER=.*/IS_DOCKER=true/g' /app/bbuddy/docker/parseEnv.sh && \
sed -i 's/IS_DOCKER=.*/IS_DOCKER=true/g' /app/bbuddy/example/grabInput.sh && \
sed -i 's/const DEFAULT_USE_REDIS =.*/const DEFAULT_USE_REDIS = "1";/g' /app/bbuddy/incl/db.inc.php && \
(crontab -l 2>/dev/null; echo "* * * * * sudo -u abc /usr/bin/php /app/bbuddy/cron.php >/dev/null 2>&1") | crontab - && \
echo "**** Cleanup ****" && \
 rm -rf \
	/root/.cache \
	/tmp/* && \
 apk del --purge build-dependencies


#Bug in sudo requires disable_coredump
#Max children need to be a higher value, otherwise websockets / SSE might not work properly
EXPOSE 80 443
VOLUME /config

ENTRYPOINT ["/init"]

