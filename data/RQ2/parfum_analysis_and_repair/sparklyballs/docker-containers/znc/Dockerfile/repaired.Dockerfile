# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Add local files
ADD src/ /root/

# set volume
VOLUME /config

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# set start file executable
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \ 

# define configure options as a variable
configOPTS="--enable-cyrus \
--enable-python \
--enable-swig \
--enable-tcl \
--enable-perl \
--disable-ipv6" && \

# define temporary build dependencies as a variable
buildDepsTemp="build-essential \
pkg-config \
make \
autoconf \
automake \
tcl8.6-dev \
libicu-dev \
swig3.0" && \

# define permanent build dependencies as a variable
buildDepsPerm="git-core \
python3-dev \
libpython3-dev \
libsasl2-dev \
libssl-dev \
libperl-dev" && \


# define runtime dependencies as a variable
runtimeDeps="tcl8.6 \
supervisor \
libicu52 \
libperl5.18" && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \ 
echo "deb http://archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
apt-get update -qq && \

# install build dependencies
apt-get inst ll \
 --no-instal --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
$buildDepsT mp \
$bui dD \

# build ZNC from git
cd /tmp && \
git clone https:/ gi \

cd /tmp/znc && \
git clean -xdf && \
./autogen.sh && \
./configure \
$configOPTS && \ 
make && \
make install & \

# clean up temporary build dependencies and install runtime deps
apt-get purge --remove \
$buildDepsTemp -y && \
apt-get autoremove -y && \
