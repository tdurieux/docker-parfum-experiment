# Tshark 1.99.8
#
# VERSION               1
# NOTES:
# wouldn't build with --disable-reordercap --disable-dumpcap
# You must have libtool 1.4 or later installed to compile Wireshark
#
FROM      opennsm/debian
MAINTAINER Jon Schipp <jonschipp@gmail.com>

# Metadata
LABEL organization=opennsm
LABEL program=tshark

# Specify container username e.g. training, demo
ENV VIRTUSER opennsm
# Specify program
ENV PROG wireshark
# Specify source extension
ENV EXT tar.bz2
# Specify Tshark version to download and install
ENV VERS 1.99.8
# Specific Libtool to download and install
ENV LIBTOOL libtool-2.4.2
# Install directory
ENV PREFIX /opt
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/bin

# Install dependencies
RUN apt-get update -qq
RUN apt-get install -yq build-essential autoconf automake libtool bison flex \
  libpcap-dev libglib2.0-dev libgeoip-dev libkrb5-dev libgnutls28-dev \
  libgcrypt-dev libcap-dev libsbc-dev libsmi-dev libc-ares-dev --no-install-recommends
RUN  wget --no-check-certificate https://ftp.gnu.org/gnu/libtool/$LIBTOOL.tar.gz
RUN tar zxf $LIBTOOL.tar.gz && cd $LIBTOOL && ./configure && make && make install

# Compile and install libpcap
USER $VIRTUSER
WORKDIR /home/$VIRTUSER
RUN wget --no-check-certificate https://www.wireshark.org/download/src/all-versions/$PROG-$VERS.$EXT
RUN tar -jxf $PROG-$VERS.$EXT
WORKDIR /home/$VIRTUSER/$PROG-$VERS
RUN ./autogen.sh && ./configure --disable-wireshark --enable-profile-build --prefix=/opt \
 CFLAGS="-I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include" && \
 make CFLAGS="-fPIC -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include"
USER root
RUN make install
RUN chmod u+s $PREFIX/bin/dumpcap

# Cleanup
RUN rm -rf /home/$VIRTUSER/$PROG-$VERS
RUN rm -rf /root/$LIBTOOL*

# Environment
WORKDIR /home/$VIRTUSER
USER opennsm
