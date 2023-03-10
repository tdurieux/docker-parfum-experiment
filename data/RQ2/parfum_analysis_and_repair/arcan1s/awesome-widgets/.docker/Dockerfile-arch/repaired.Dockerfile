FROM archlinux

RUN pacman -Sy

# toolchain
RUN echo -e 'y\ny' | pacman -S util-linux-libs
RUN pacman -S --noconfirm base-devel cmake extra-cmake-modules python util-linux-libs
# kf5 and qt5 libraries
RUN pacman -S --noconfirm plasma-framework

# required by tests
RUN pacman -S --noconfirm xorg-server-xvfb