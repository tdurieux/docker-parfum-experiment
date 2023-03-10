FROM archlinux:base

# Fix from https://www.reddit.com/r/archlinux/comments/lek2ba/arch_linux_on_docker_ci_could_not_find_or_read/
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
  curl -f -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
  bsdtar -C / -xvf "$patched_glibc"

RUN pacman -Syu --noconfirm --needed \
  cairo \
  cmake \
  docbook2x \
  git \
  glib2 \
  imlib2 \
  iw \
  libical \
  libircclient \
  libmicrohttpd \
  libpulse \
  librsvg \
  libxdamage \
  libxext \
  libxft \
  libxinerama \
  libxnvctrl \
  lua \
  make \
  man-db \
  mariadb-libs \
  patch \
  pkg-config \
  wireless_tools \
  && git clone https://github.com/linux-test-project/lcov.git \
  && cd lcov \
  && make install \
  && cd .. \
  && rm -rf lcov
