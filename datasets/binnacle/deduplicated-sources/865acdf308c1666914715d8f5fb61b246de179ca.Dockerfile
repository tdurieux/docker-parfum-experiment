# Chaosreader 0.95
#
# VERSION               0.1
FROM      opennsm/debian
MAINTAINER Jon Schipp <jonschipp@gmail.com>

# Metadata
LABEL organization=opennsm
LABEL program=chaosreader

# Specify container username e.g. training, demo
ENV VIRTUSER opennsm
# Specify program
ENV PROG chaosreader
# Specify version to download and install
ENV VERS 0.95
# Install directory
ENV PREFIX /opt
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/bin
 
# Install dependencies
RUN apt-get update -qq
RUN apt-get install -yq libnet-dns-perl --no-install-recommends

# Install chaosreader
RUN mkdir -p $PREFIX/bin
RUN wget --no-check-certificate https://raw.githubusercontent.com/brendangregg/Chaosreader/master/chaosreader -O $PREFIX/bin/$PROG
RUN chmod 4755 $PREFIX/bin/$PROG

# Environment
WORKDIR /home/$VIRTUSER
USER opennsm
