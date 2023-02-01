# Build the latest Debian testing image
FROM debian:testing

RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  autoconf-archive \
  automake \
  expect \
  gcc \
  git \
  libcmocka-dev \
  libcurl3-dev \
  libgcrypt-dev \
  libglib2.0-dev \
  libgpgme11-dev \
  libgtk2.0-dev \
  libmicrohttpd-dev \
  libncursesw5-dev \
  libnotify-dev \
  libotr5-dev \
  libreadline-dev \
  libsignal-protocol-c-dev \
  libssl-dev \
  libtool \
  libxss-dev \
  make \
  pkg-config \
  python-dev

RUN mkdir -p /usr/src/{stabber,libmesode,profanity}
WORKDIR /usr/src

RUN git clone git://github.com/boothj5/stabber.git
RUN git clone git://github.com/profanity-im/libmesode.git

WORKDIR /usr/src/stabber
RUN ./bootstrap.sh
RUN ./configure --prefix=/usr --disable-dependency-tracking
RUN make
RUN make install

WORKDIR /usr/src/libmesode
RUN ./bootstrap.sh
RUN ./configure --prefix=/usr
RUN make
RUN make install

WORKDIR /usr/src/profanity
COPY . /usr/src/profanity
