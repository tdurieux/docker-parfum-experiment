#compiling qB
FROM alpine:3.16 as compilingqB

ARG LIBTORRENT_VER=2.0.6
ARG QBITTORRENT_VER=4.4.3.1
ARG QBITTORRENT_EE_VER=4.4.3.12

RUN apk add --no-cache ca-certificates cmake build-base boost-dev python3-dev \
         py3-setuptools samurai qt6-qttools-dev libexecinfo-dev \
#libtorrent-rasterbar
&& mkdir /qbbuild \
&& wget -P /qbbuild https://github.com/arvidn/libtorrent/releases/download/v${LIBTORRENT_VER}/libtorrent-rasterbar-${LIBTORRENT_VER}.tar.gz \
&& tar -zxf /qbbuild/libtorrent-rasterbar-${LIBTORRENT_VER}.tar.gz -C /qbbuild \
# fix armv7 build
&& wget -O /qbbuild/libtorrent-rasterbar-${LIBTORRENT_VER}/test/test_copy_file.cpp https://raw.githubusercontent.com/arvidn/libtorrent/fac8d18e72cdd16a56a34dd805df9fefe46d8f0a/test/test_copy_file.cpp \
&& cd /qbbuild/libtorrent-rasterbar-${LIBTORRENT_VER} \
&& cmake -B build -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_STANDARD=17 -DCMAKE_VERBOSE_MAKEFILE=ON \
         -DCMAKE_INSTALL_PREFIX=/usr -Dbuild_tests=ON -Dpython-bindings=ON -Dpython-egg-info=ON \
&& cmake --build build -- -j 2 \
&& cmake --install build \
&& strip /usr/lib/libtorrent-rasterbar.so.2.0 \
#qBittorrent-Enhanced-Edition
&& wget -P /qbbuild https://github.com/c0re100/qBittorrent-Enhanced-Edition/archive/release-${QBITTORRENT_EE_VER}.zip \
&& unzip /qbbuild/release-${QBITTORRENT_EE_VER}.zip -d /qbbuild \
&& cd /qbbuild/qBittorrent-Enhanced-Edition-release-${QBITTORRENT_EE_VER} \
&& cmake -B build-nox -G Ninja -D CMAKE_CXX_STANDARD_LIBRARIES="/usr/lib/libexecinfo.so" \
         -D CMAKE_CXX_STANDARD=17 -DCMAKE_BUILD_TYPE=Release -DQT6=ON -DGUI=OFF \
&& cmake --build build-nox -- -j 2 \
&& cmake --install build-nox \
&& strip /usr/local/bin/qbittorrent-nox \
&& mv /usr/local/bin/qbittorrent-nox /usr/local/bin/qbittorrentee-nox \
#qBittorrent
&& wget -P /qbbuild https://github.com/qbittorrent/qBittorrent/archive/release-${QBITTORRENT_VER}.zip \
&& unzip /qbbuild/release-${QBITTORRENT_VER}.zip -d /qbbuild \
&& cd /qbbuild/qBittorrent-release-${QBITTORRENT_VER} \
# fix Qt 6.3
&& wget -O /qbbuild/qBittorrent-release-${QBITTORRENT_VER}/src/base/net/downloadhandlerimpl.cpp https://raw.githubusercontent.com/qbittorrent/qBittorrent/af07a987849de7180226596f878203c6ea3070b2/src/base/net/downloadhandlerimpl.cpp \
&& cmake -B build-nox -G Ninja -D CMAKE_CXX_STANDARD_LIBRARIES="/usr/lib/libexecinfo.so" \
         -D CMAKE_CXX_STANDARD=17 -DCMAKE_BUILD_TYPE=Release -DQT6=ON -DGUI=OFF \
&& cmake --build build-nox -- -j 2 \
&& cmake --install build-nox \
&& strip /usr/local/bin/qbittorrent-nox \
&& mkdir /qbittorrent \
&& cp --parents /usr/local/bin/qbittorrent-nox /qbittorrent \
&& cp --parents /usr/local/bin/qbittorrentee-nox /qbittorrent \
&& cp --parents /usr/lib/libtorrent-rasterbar.so.2.0 /qbittorrent

# docker qB
FROM alpine:3.16

ARG S6_VER=2.2.0.3

ENV UID=1000
ENV GID=1000
ENV UMASK=022
ENV TZ=Asia/Shanghai
ENV QB_WEBUI_PORT=8989
ENV QB_EE_BIN=false
ENV QB_TRACKERS_UPDATE_AUTO=true
ENV QB_TRACKERS_LIST_URL=https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt

COPY root /
COPY --from=compilingqB /qbittorrent /

#install bash curl tzdata python3 shadow qt6
RUN apk add --no-cache bash curl ca-certificates tzdata python3 shadow qt6-qtbase-sqlite qt6-qtbase libexecinfo \
#install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz \
&& tar -xvzf s6-overlay-${s6_arch}.tar.gz \
#create qbittorrent user
&& useradd -u 1000 -U -d /config -s /bin/false qbittorrent \
&& usermod -G users qbittorrent \
#install Search
&& wget -P /tmp https://github.com/qbittorrent/search-plugins/archive/refs/heads/master.zip \
&& unzip /tmp/master.zip -d /tmp \
&& mkdir -p /usr/local/qbittorrent/defaults/Search \
&& cp /tmp/search-plugins-master/nova3/engines/*.py /usr/local/qbittorrent/defaults/Search \
#conf trackers
&& curl -so /tmp/trackers_all.txt $QB_TRACKERS_LIST_URL \
&& Newtrackers="Session\AdditionalTrackers=$(awk '{if(!NF){next}}1' /tmp/trackers_all.txt|sed ':a;N;s/\n/\\n/g;ta' )" \
&& echo $Newtrackers >/tmp/Newtrackers.txt \
&& sed -i '/Session\\AdditionalTrackers=/r /tmp/Newtrackers.txt' /usr/local/qbittorrent/defaults/qBittorrent.conf \
&& sed -i '1,/^Session\\AdditionalTrackers=.*/{//d;}' /usr/local/qbittorrent/defaults/qBittorrent.conf \
#clear
&& rm s6-overlay-${s6_arch}.tar.gz \
&& rm -rf /var/cache/apk/* /tmp/* \
&& chmod a+x /usr/local/qbittorrent/updatetrackers.sh \
&& chmod a+x /usr/local/bin/qbittorrent-nox \
&& chmod a+x /usr/local/bin/qbittorrentee-nox

VOLUME /Downloads /config
EXPOSE 8989 6881 6881/udp
ENTRYPOINT [ "/init" ]
