# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 9777/udp 8080/tcp

# Add local files
ADD src/ /root/

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# set kodi checkout version as variable
kodiCheckout=14.2-Helix && \

# Configure user nobody to match unRAID's settings
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# move startup files and set permissions
mkdir /etc/service/xbmc && \
mv /root/kodi.sh /etc/service/xbmc/run && \
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/service/xbmc/run && \
chmod +x /etc/my_init.d/firstrun.sh && \

# set build dependencies as variable
buildDeps="build-essential \
zip \
unzip \
yasm \
gawk \
cmake \
wget \
git-core \
autoconf \
libtool \
automake \
autopoint \
swig \
doxygen \
openjdk-7-jre-headless \
gperf \
libsqlite3-dev \
libpcre3-dev \
libtag1-dev \
libbluray-dev \
libjasper-dev \
libmicrohttpd-dev \
libavahi-client-dev \
libxrandr-dev \
libssh-dev \
libsmbclient-dev \
libnfs-dev \
libboost1.54-dev \
python-dev \
libmysqlclient-dev \
libgle3-dev \
libglew-dev \
libass-dev \
libmpeg2-4-dev \
libjpeg-dev \
libflac-dev \
libvorbis-dev \
libgnutls-dev \
libbz2-ocaml-dev \
libtiff5-dev \
libyajl-dev \
libssl-dev \
libxml2-dev \
libxslt-dev \
libiso9660-dev \
libtinyxml-dev \
libmodplug-dev \
libsdl1.2-dev \
libsdl-ocaml-dev \
liblzo2-dev" && \

# set runtime dependencies as variable
runtimeDeps="zip \
libpcrecpp0 \
libtag1-vanilla \
libtag1c2a \
libaacs0 \
libbluray1 \
libjasper1 \
libjpeg-turbo8 \
libjpeg8 \
libmicrohttpd10 \
libavahi-client3 \
libavahi-common-dev \
libdbus-1-dev \
libssh-4 \
libsmbclient \
libnfs1 \
libmysqlclient18 \
libgle3 \
libglew1.10 \
libass4 \
libmpeg2-4 \
libjpeg-turbo8 \
libflac8 \
libogg0 \
libvorbis0a \
libvorbisenc2 \
libvorbisfile3 \
libbz2-ocaml \
libtiff5 \
libtiffxx5 \
libyajl2 \
libxslt1.1 \
libiso9660-8 \
libtinyxml2.6.2 \
liblzo2-2 \
libxrandr2 \
libmodplug1 \
libsdl1.2debian \
libsdl-ocaml \
unzip" && \

# update apt
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \
apt-get update -qq && \

# Install build dependencies
apt-get install \
$buildDeps -qy && \

 # fetch sou --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
cd /tmp/ && \
git clone \
wget http:/ cu \

# compile cu l \
cd /tmp && \
tar xvf curl * \
cd curl-* && \
./configure \
--prefix=/usr \
--with-ssl \
--with-zlib && \
 make && \ --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
make install \

# checkout r \
cd /tmp/xbmc && \
mv /root/headle \
git checkout $k \
git apply headl \
# Configure, make, \
./bootstrap && \
./configure \
--enable-nfs \
--enable-upnp \
--enable-ssh \
--enable-libbluray \
--disable-debu \
--disable-vdpau \
--disable-vaapi \
--disable-crysta \
--disable-vdadecoder \
--disable-vtbdec \
--disable-openma \
--disable-joystick \
--disable-rsxs \
--disable-proj \
--disable-rtmp \
--disable-airplay \
--disable-airtunes \
--disable-dvdc \
--disable-optical \
--disable-libusb \
--disable-libcec \
--disable-libmp \
--disable-libcap \
--disable-udev \
--disable-libvo \
--disable-asap \
--disable-afpc \
--disable-goo \
--disable-fishbmc \
--di ab \
--disable-wa ef \
--disable-avahi \
--disable-non-free \
--disable-texturepacker \
--disable- ul \
--disable-dbus \
--disable-alsa \
--disable-hal \
--prefix=/opt/ko i- \
make && \
make install && \
chown -R nobody:us rs \

# clean build area of no longer re \
apt-get purge -y --remove \
$buildDeps && \
apt-get -y autoremove && \

# install run im \
apt-get install \
$runtimeDeps -qy && \

# install kodisend \
add-apt-repository ppa:team-xbmc/ppa && \
