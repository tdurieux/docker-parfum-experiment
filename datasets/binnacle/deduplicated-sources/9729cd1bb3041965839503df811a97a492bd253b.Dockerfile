FROM ubuntu:15.10

RUN apt-get -y update && \
  apt-get -y install \
  wget \
  tar \
  git \
  autoconf \
  libtool \
  automake \
  build-essential \
  mono-devel \
  gettext

RUN wget http://download.mono-project.com/sources/mono/mono-4.6.0.125.tar.bz2 -O mono-4.6.0.125.tar.bz2
RUN tar xvf mono-4.6.0.125.tar.bz2
RUN cd "mono-4.6.0/" ; \
  ./configure ; \
  make ; \
  make install


COPY scripts /scripts

CMD bash scripts/init; bash '/etc/shared/scripts/drive'
