# Suricata 2.0.9
#
# VERSION               1
FROM      opennsm/debian
MAINTAINER Jon Schipp <jonschipp@gmail.com>

# Metadata
LABEL organization=opennsm
LABEL program=suricata
# Specify container username e.g. training, demo
ENV VIRTUSER opennsm
# Specify program
ENV PROG suricata
# Specify Suricata version to download and install (e.g. 2.0.9)
ENV VERS 2.0.9
# Install directory
ENV PREFIX /opt
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/bin

# Install dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -yq libpcre3 libpcre3-dbg libpcre3-dev \
build-essential autoconf automake libtool libpcap-dev libnet1-dev \
libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libmagic-dev libcap-ng-dev \
libjansson-dev pkg-config libgeoip-dev libnetfilter-queue-dev && rm -rf /var/lib/apt/lists/*;

# Compile and install libpcap
USER $VIRTUSER
WORKDIR /home/$VIRTUSER
RUN wget https://www.openinfosecfoundation.org/download/$PROG-$VERS.tar.gz
RUN tar -xvzf $PROG-$VERS.tar.gz && rm $PROG-$VERS.tar.gz
WORKDIR /home/$VIRTUSER/$PROG-$VERS
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-nfqueue --enable-geoip --prefix=$PREFIX --enable-profiling --enable-debug --enable-debug-validation --enable-unittests --sysconfdir=/etc --localstatedir=/var && make
USER root
RUN make install && make install-full
RUN chmod u+s $PREFIX/bin/$PROG

# Cleanup
RUN rm -rf /home/$VIRTUSER/$PROG-$VERS

# Environment
WORKDIR /home/$VIRTUSER
USER opennsm
