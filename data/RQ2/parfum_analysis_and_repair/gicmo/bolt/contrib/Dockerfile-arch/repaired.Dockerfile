## -*- mode: dockerfile -*-
FROM archlinux/archlinux:base-devel
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm base-devel
RUN pacman -S --noconfirm \
    asciidoc \
    dbus-glib \
    git \
    gobject-introspection \
    gtk-doc \
    meson \
    perl-sgmls \
    polkit \
    python-dbus \
    python-gobject \
    python-pip \
    umockdev \
    valgrind

RUN pip3 install --no-cache-dir python-dbusmock pylint==2.4.1

RUN mkdir /src /build
WORKDIR /src
