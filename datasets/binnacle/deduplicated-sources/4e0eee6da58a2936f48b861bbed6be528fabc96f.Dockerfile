FROM archlinux/base

RUN pacman -Syu --noconfirm && pacman -S --needed --noconfirm \
  autoconf \
  autoconf-archive \
  automake \
  base-devel \
  check \
  cmake \
  cmocka \
  curl \
  doxygen \
  expat \
  gcc \
  git \
  gpgme \
  gtk2 \
  libgcrypt \
  libmicrohttpd \
  libnotify \
  libotr \
  libtool \
  libxss \
  make \
  openssl \
  pkg-config \
  python \
  wget

RUN mkdir -p /usr/src/{stabber,profanity}

RUN useradd -mb /usr/src --shell=/bin/false aur && usermod -L aur
USER aur

WORKDIR /usr/src/aur
RUN wget https://aur.archlinux.org/cgit/aur.git/snapshot/libstrophe-git.tar.gz
RUN wget https://aur.archlinux.org/cgit/aur.git/snapshot/libsignal-protocol-c.tar.gz
RUN tar -zxvf libstrophe-git.tar.gz
RUN tar -zxvf libsignal-protocol-c.tar.gz
RUN pushd libstrophe-git && makepkg && popd
RUN pushd libsignal-protocol-c && makepkg && popd

USER root

RUN pacman -U --noconfirm libstrophe-git/libstrophe-git-*.pkg.tar.xz
RUN pacman -U --noconfirm libsignal-protocol-c/libsignal-protocol-c-*.pkg.tar.xz

WORKDIR /usr/src
RUN git clone git://github.com/boothj5/stabber.git

WORKDIR /usr/src/stabber
RUN ./bootstrap.sh
RUN ./configure --prefix=/usr --disable-dependency-tracking
RUN make
RUN make install

WORKDIR /usr/src/profanity
COPY . /usr/src/profanity
