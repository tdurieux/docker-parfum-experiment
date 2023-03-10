FROM archlinux:latest

RUN pacman -Sy \
  npm qt5-base qt5-webengine gcc systemd-libs pkg-config make tcp-wrappers python git base-devel \
  --noconfirm

RUN useradd -m user
RUN chmod a+rwx /opt

USER user
WORKDIR /opt

COPY builds/PKGBUILD .
RUN makepkg