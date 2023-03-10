# Tcpdump 3.5.2
#
# VERSION               1.1
FROM      opennsm/debian
MAINTAINER Jon Schipp <jonschipp@gmail.com>

# Metadata
LABEL organization=opennsm
LABEL program=tcpdump

# Specify container username e.g. training, demo
ENV VIRTUSER opennsm
# Specify program
ENV PROG tcpdump
# Specify source extension
ENV EXT tar.gz
# Specify Tcpdump version to download and install (e.g. 4.7.4)
ENV TVERS 3.5.2
# Specify Libpcap version to download and install (e.g. 1.7.4)
ENV LVERS 0.5.2
# Install directory
ENV PREFIX /opt
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/sbin

# Install dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -yq make gcc flex bison libcap-ng-dev && rm -rf /var/lib/apt/lists/*;

# Compile and install libpcap
USER $VIRTUSER
WORKDIR /home/$VIRTUSER
RUN wget https://www.tcpdump.org/release/libpcap-$LVERS.$EXT && tar -xvzf libpcap-$LVERS.$EXT
WORKDIR /home/$VIRTUSER/libpcap_0_5rel2
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make
USER root
RUN make install

# Compile and install tcpdump
USER $VIRTUSER
WORKDIR /home/$VIRTUSER
RUN wget https://www.tcpdump.org/release/$PROG-$TVERS.$EXT && tar -xvzf $PROG-$TVERS.$EXT
WORKDIR /home/$VIRTUSER/tcpdump_3_5rel2
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$PREFIX && make
USER root
RUN make install
RUN chmod u+s $PREFIX/sbin/$PROG

# Cleanup
RUN rm -rf /home/$VIRTUSER/libpcap_0_5rel2
RUN rm -rf /home/$VIRTUSER/tcpdump_3_5rel2

# Environment
WORKDIR /home/$VIRTUSER
USER opennsm
