# argus 3.0.8
#
# VERSION               1
# NOTES:
#
FROM      opennsm/debian
MAINTAINER Jon Schipp <jonschipp@gmail.com>

# Metadata
LABEL organization=opennsm
LABEL program=argus

# Specify container username e.g. training, demo
ENV VIRTUSER opennsm
# Specify program
ENV PROG argus
# Specify source extension
ENV EXT tar.gz
# Specify argus version to download and install
ENV VERS 3.0.8
# Install directory
ENV PREFIX /opt
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/sbin:$PREFIX/bin

# Install dependencies
RUN apt-get update -qq && apt-get install -yq gcc make bison flex libpcap-dev libsasl2-dev libwrap0-dev libgeoip-dev libpcre3-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# Compile and install argus
USER $VIRTUSER
WORKDIR /home/$VIRTUSER
RUN wget --no-check-certificate https://qosient.com/argus/src/$PROG-$VERS.$EXT
RUN tar -zxf $PROG-$VERS.$EXT
WORKDIR /home/$VIRTUSER/$PROG-$VERS
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-sasl --prefix=/opt && make
USER root
RUN make install
RUN chmod u+s $PREFIX/sbin/argus

# Compile and install argus client
USER $VIRTUSER
WORKDIR /home/$VIRTUSER
RUN wget --no-check-certificate https://qosient.com/argus/src/$PROG-clients-$VERS.$EXT
RUN tar -zxf $PROG-clients-$VERS.$EXT
WORKDIR /home/$VIRTUSER/$PROG-clients-$VERS
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-sasl --with-GeoIP --with-libpcre --prefix=/opt && make
USER root
RUN make install

# Cleanup
RUN rm -rf /home/$VIRTUSER/$PROG-$VERS
RUN rm -rf /home/$VIRTUSER/$PROG-clients-$VERS

# Environment
WORKDIR /home/$VIRTUSER
USER opennsm
