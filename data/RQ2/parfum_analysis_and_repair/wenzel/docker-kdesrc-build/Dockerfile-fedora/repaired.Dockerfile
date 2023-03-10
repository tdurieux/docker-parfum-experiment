FROM fedora:rawhide
MAINTAINER Mathieu Tarral <mathieu.tarral@gmail.com>

# FRAMEWORKS            |       BUILD DEPENDENCY
#-----------------------|---------------------------------
# ki18n                 |       qt5-qtscript-devel gettext-devel
# kcodecs               |       gperf
# kservice              |       flex bison
# kwindowsystem         |       qt5-qtx11extras-devel libXrender-devel xcb-util-keysyms-devel xcb-util-wm-devel
# karchive              |       zlib-devel
# kdoctools             |       libxslt-devel docbook-style-xsl
# kwidgetsaddons        |       qt5-qttools-devel qt5-qttools-static
# kiconthemes           |       qt5-qtsvg-devel
# solid                 |       systemd-devel
# kdeclarative          |       qt5-qtquickcontrols2-devel libepoxy-devel
# kactivities           |       boost-devel
# kdewebkit             |       qt5-qtwebkit-devel
# kdelibs4support       |       libSM-devel pcre-devel qca-ossl openssl-devel
# khtml                 |       giflib-devel libjpeg-turbo-devel libpng-devel
# frameworkintegration  |       libXcursor-devel oxygen-fonts-devel
# ktexteditor           |       qt5-qtxmlpatterns-devel
# polkit-qt-1           |       polkit-devel
# phonon-gstreamer      |       gstreamer-devel gstreamer-plugins-bad-free-devel gstreamer1-plugins-bad-free-devel gstreamer1-plugins-base-devel
# networkmanager-qt     |       NetworkManager-devel NetworkManager-glib-devel
# baloo                 |       lmdb-devel
# kidletime             |       libXext-devel
# kross                 |       qt5-qttools-static
# phonon-vlc            |       vlc-devel
# khelpcenter           |       xapian-core-devel
#-----------------------|---------------------------------
# WORKSPACE             |       BUILD DEPENDENCY
#-----------------------|---------------------------------
# kwayland              |       wayland-devel libwayland-cursor-devel libwayland-server-devel qt5-qtwayland-devel
# kfilemetadata         |       libattr-devel taglib-devel
# libmm-qt              |       ModemManager-devel
# sddm-kcm              |       xcb-util-image-devel
# plasma-desktop        |       PackageKit-Qt5-devel xorg-x11-xkb-utils-devel xorg-x11-drv-libinput-devel xkeyboard-config-devel
# user-manager          |       libpwquality-devel
# kcm-touchpad          |       xorg-x11-drv-synaptics-devel xorg-x11-server-devel
# kde-gtk-config        |       gtkmm24-devel gtkmm30-devel
# kwin                  |       libepoxy-devel qt5-qtbase-static qt5-qtsensors-devel xcb-util-cursor-devel xcb-util-devel
# oxygen-fonts          |       fontforge-devel
# gwenview              |       exiv2-devel
# libksane              |       sane-backends-devel
# plasma-workspace      |       appstream-qt-devel libXtst-devel
# breeze-gtk            |       sassc python3-cairo-devel
# kgamma5               |       libXxf86vm-devel
# plasma-pa             |       libcanberra-devel
# plymouth-kcm          |       plymouth-devel
# xdg-desktop-portal-kde|       pipewire-devel mesa-libgbm-devel
# kscreenlocker         |       pam-devel
#-----------------------|---------------------------------
# APPLICATIONS          |       BUILD DEPENDENCY
#-----------------------|---------------------------------
# gwenview              |       lcms2-devel
# lokalize              |       hunspell-devel
# kalgebra              |       glu
# parley                |       qt5-qtmultimedia qt5-qtmultimedia-devel
# step                  |       eigen3-devel
# rocs                  |       grentlee-devel
# telepathy-qt          |       qtsinglecoreapplication-devel
# ark                   |       libarchive-devel
# kmix                  |       alsa-lib alsa-lib-devel
# libkdegames           |       openal-soft-devel libsndfile-devel
# kcalc                 |       gmp-devel
# cups                  |       cups-devel
# ksirk                 |       qca2-devel qca-ossl qca-gnupg qca-pkcs11
#-----------------------|---------------------------------
# PIM                   |       BUILD DEPENDENCY
#-----------------------|---------------------------------
# prison                |       libdmtx-devel qrencode-devel
# kcalcore              |       libical-devel
# kimap                 |       cyrus-sasl-devel
# kldap                 |       openldap-devel
# gpgmepp               |       gpgme-devel
#-----------------------|---------------------------------

# Install dependencies
#---------------------------
RUN dnf -y install gcc-c++ git doxygen cmake bzr vim tar xorg-x11-server-Xvfb x11vnc dbus-tools dbus-x11 && \
    dnf -y install dialog perl perl-libwww-perl perl-JSON perl-JSON-PP perl-XML-Parser perl-IPC-Cmd \
                    perl-YAML-LibYAML qt5-qtbase-devel qt5-qtbase-private-devel && \
    dnf install -y \
                    qt5-qtscript-devel gettext-devel \
                    gperf \
                    flex bison \
                    qt5-qtx11extras-devel libXrender-devel xcb-util-keysyms-devel xcb-util-wm-devel \
                    zlib-devel \
                    libxslt-devel docbook-style-xsl \
                    qt5-qttools-devel qt5-qttools-static \
                    qt5-qtsvg-devel \
                    systemd-devel \
                    qt5-qtquickcontrols2-devel libepoxy-devel\
                    boost-devel \
                    qt5-qtwebkit-devel \
                    libSM-devel pcre-devel qca-ossl openssl-devel \
                    giflib-devel libjpeg-turbo-devel libpng-devel \
                    libXcursor-devel oxygen-fonts-devel \
                    qt5-qtxmlpatterns-devel \
                    polkit-devel \
                    gstreamer1-devel gstreamer1-plugins-bad-free-devel gstreamer1-plugins-bad-free-devel gstreamer1-plugins-base-devel \
                                libnma-devel NetworkManager-libnm-devel xapian-core-devel && \
    dnf install -y \
                    wayland-devel libwayland-cursor-devel libwayland-server-devel qt5-qtwayland-devel \
                    libattr-devel taglib-devel \
                    ModemManager-devel \
                    xcb-util-image-devel \
                    PackageKit-Qt5-devel xorg-x11-xkb-utils-devel xorg-x11-drv-libinput-devel xkeyboard-config-devel \
                    libpwquality-devel \
                    xorg-x11-drv-synaptics-devel xorg-x11-server-devel \
                    gtkmm24-devel gtkmm30-devel \
                    lmdb-devel \
                    libepoxy-devel qt5-qtbase-static qt5-qtsensors-devel xcb-util-cursor-devel xcb-util-devel \
                    fontforge-devel \
                    exiv2-devel \
                    sane-backends-devel \
                    appstream-qt-devel libXtst-devel sassc python3-cairo-devel libXxf86vm-devel libcanberra-devel plymouth-devel pipewire-devel mesa-libgbm-devel pam-devel && \
    dnf install -y \ 
                    lcms2-devel \
                    hunspell-devel \
                    glui-devel \
                    qt5-qtmultimedia qt5-qtmultimedia-devel \
                    eigen3-devel \
                    grantlee-devel \
                    qtsinglecoreapplication-devel \
                    libarchive-devel \
                    alsa-lib alsa-lib-devel \
                    openal-soft-devel libsndfile-devel \
                    gmp-devel \
                    cups-devel \
                    qca-devel qca-ossl qca-gnupg qca-pkcs11 && \
    dnf install -y \ 
                    libdmtx-devel qrencode-devel \
                    libical-devel \
                    cyrus-sasl-devel \
                    openldap-devel \
                    gpgme-devel && \
    useradd -d /home/kdedev -m kdedev && \
    mkdir /work /qt && \
    chown kdedev /work /qt

# some symlinks in /root to handle sudo ./kdesrc-build
RUN ln -s /home/kdedev/.kdesrc-buildrc /root/.kdesrc-buildrc && \
    ln -s /home/kdedev/kdesrc-build /root/kdesrc-build
# setup kdedev account
RUN dnf install -y sudo && echo 'kdedev ALL=NOPASSWD: ALL' >> /etc/sudoers
# rpmfusion for phonon-vlc
RUN dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-rawhide.noarch.rpm ; dnf install -y vlc-devel
USER kdedev
ENV HOME /home/kdedev
WORKDIR /home/kdedev/
# kde anongit url alias
RUN git config --global user.name "Your Name" && \
    git config --global user.email "you@email.com" && \
    git clone https://invent.kde.org/sdk/kdesrc-build.git \
    && /home/kdedev/kdesrc-build/kdesrc-build --initial-setup

VOLUME /work
VOLUME /qt

CMD ["bash"]