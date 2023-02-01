FROM rockylinux:8

RUN yum -y update
RUN yum -y install epel-release dnf-plugins-core && rm -rf /var/cache/yum
RUN dnf config-manager --set-enabled powertools
RUN yum -y update

RUN yum -y install gcc-toolset-11 \
           glibc-devel alsa-lib-devel mesa-libGL-devel libxkbcommon-x11-devel zlib-devel ncurses-devel \
           wget xz git cmake xcb-util xcb-util-devel libX11-devel libXrender-devel libXi-devel dbus-devel glib2-devel mesa-libGL-devel \
    nasm libxkbcommon-x11-devel alsa-lib-devel glib2-devel libxcb-devel xcb-util xcb-util-image xcb-util-keysyms xcb-util-image-devel xcb-util-renderutil-devel \
    vulkan vulkan-devel xcb-util-wm xcb-util-wm-devel libxkbcommon-devel libXcomposite-devel xcb-util-keysyms-devel \
    libxcb-devel pulseaudio-libs-devel \
    rsync \
    pipewire-devel \
    bluez-libs-devel avahi-devel wayland-devel wayland-protocols-devel libwayland-egl libwayland-cursor libwayland-client ninja-build && rm -rf /var/cache/yum


RUN ls \
    && wget -nv --no-check-certificate -c https://github.com/jcelerier/cninja/releases/download/v3.7.6/cninja-v3.7.6-Linux.tar.gz \
    && tar xaf cninja-*.tar.gz \
    && rm -rf cninja-*.tar.gz \
    && mv cninja /usr/bin/

#ADD Recipe.llvm /Recipe.llvm
#RUN bash -ex Recipe.llvm
