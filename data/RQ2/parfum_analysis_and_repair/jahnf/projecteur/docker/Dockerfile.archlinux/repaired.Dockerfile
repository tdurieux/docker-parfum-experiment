# Container for building the Projecteur package
# Images available at: https://hub.docker.com/r/jahnf/projecteur/tags

FROM archlinux

RUN pacman --noconfirm -Sy && pacman --noconfirm -S \
  lsb-release \
  file \
  awk \
  fakeroot \
  sudo \
  tar \
  pkg-config \
  gcc \
  make \
  cmake \
  git \
  qt5-tools \
  qt5-base \
  qt5-declarative \
  qt5-x11extras \
  qt5-graphicaleffects

RUN pacman --noconfirm -Sy && pacman --noconfirm -S \
  libusb

# makepkg cannot run as root
RUN useradd builduser
RUN mkdir /build && chown builduser /build

# Allow builduser to run stuff as root:
RUN echo "builduser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builduser

# Continue execution as builduser: