FROM fedora:33

RUN dnf update -y -q \
  && dnf -y -q install \
  audacious-devel \
  cairo-devel \
  cmake \
  dbus-glib-devel \
  docbook2X \
  freetype-devel \
  git \
  imlib2-devel \
  lcov \
  libcurl-devel \
  libical-devel \
  libircclient-devel \
  libmicrohttpd-devel \
  librsvg2-devel \
  libX11-devel \
  libXdamage-devel \
  libXext-devel \
  libXft-devel \
  libXinerama-devel \
  libxml2-devel \
  libXNVCtrl-devel \
  lua-devel \
  make \
  man \
  mysql-devel \
  ncurses-devel \
  openssl-devel \
  patch \
  pulseaudio-libs-devel \
  readline-devel \
  systemd-devel \
  xmms2-devel