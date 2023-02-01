FROM debian:jessie
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

RUN apt-get update --fix-missing && \
  apt-get install --no-install-recommends -q -y bc wget curl vim nano unzip make gcc g++ gfortran && \
  apt-get install --no-install-recommends -q -y perl-modules libnet-ssleay-perl libcrypt-ssleay-perl libssl-dev libexpat1 libexpat1-dev liblwp-protocol-https-perl && \
  apt-get install --no-install-recommends -q -y libglib2.0-0 && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN wget -q cpanmin.us -O /usr/local/bin/cpanm && \
  chmod +x /usr/local/bin/cpanm  

RUN apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /root
ENV HOME /root 
WORKDIR /root

#
# Install deps
#
RUN apt-get update --fix-missing && \
  apt-get install --no-install-recommends -y antiword curl wget build-essential automake openjdk-7-jre-headless git ghostscript unzip && rm -rf /var/lib/apt/lists/*;


#
# Installbuilder
#
RUN curl -f -s https://s3-eu-west-1.amazonaws.com/cbcrg-eu/tcoffee-ci/installbuilder-8.6.0.tar.gz | tar xz && \
  ln -s $HOME/installbuilder-8.6.0 $HOME/installbuilder



#
# Install argtable2
#
RUN curl -fsSL https://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz | tar xz && \
  cd argtable2-13 && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  make && \
  make install

ENV OSNAME=linux OSARCH=x64 WORKSPACE=$HOME PERL_MM_USE_DEFAULT=1 PERL_EXTUTILS_AUTOINSTALL=--defaultdeps


