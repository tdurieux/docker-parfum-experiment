FROM ubuntu:latest

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  wget \
  tar \
  git \
  autoconf \
  libtool \
  automake \
  build-essential \
  mono-devel \
  gettext && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.mono-project.com/sources/mono/mono-4.4.2.11.tar.bz2 -O mono-4.4.2.11.tar.bz2
RUN tar xvf mono-4.4.2.11.tar.bz2 && rm mono-4.4.2.11.tar.bz2
RUN cd "mono-4.4.2/" ; \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
  make ; \
  make install


COPY scripts /scripts

CMD bash scripts/init; bash '/etc/shared/scripts/drive'
