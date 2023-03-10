FROM opensuse/tumbleweed
MAINTAINER Mathieu Tarral <mathieu.tarral@gmail.com>

# FRAMEWORKS            |       BUILD DEPENDENCY
#-----------------------|---------------------------------
# libdbusmenu-qt        |       libQt5DBus-devel ca-certificates-mozilla
# attica                |       libQt5Test-devel
# ki18n                 |       gettext-tools libQt5Concurrent-devel libqt5-qtscript-devel
# kwindowsystem         |       libqt5-x11extras-devel xcb-util-keysyms-devel xcb-util-wm-devel
# kdoctools             |       libxslt-devel docbook-xsl-stylesheets
# kwidgetsaddons        |       libqt5-qttools-devel
# kxml-gui              |       libQt5PrintSupport-devel
# solid                 |       libudev-devel
# kiconthemes           |       libqt5-qtsvg-devel
# kdeclarative          |       libepoxy-devel
# kactivities           |       boost-devel
# kdewebkit             |       libQt5WebkKit5-devel libQt5WebKitWidgets-devel
# khtml                 |       giflib-devel libjpeg8-devel
# frameworkintegration  |       libQt5PlatformSupport-private-headers-devel
# ktexteditor           |       libqt5-qtxmlpatters-devel
# phonon-vlc            |       vlc-devel
# phonon-gstreamer      |       libQt5OpenGL-devel gstreamer-editing-services-devel
# modemmanager-qt       |       ModemManager-devel
# networkmanager-qt     |       NetworkManager-devel
# baloo                 |       libxapian-devel lmdb-devel
# kcodecs               |       gperf
# polkit-qt-1           |       polkit-devel
# kservice              |       flex bison
# libgpg-error          |       automake autoconf makeinfo
# kirigami              |       libqt5-qtquickcontrols2 libqt5-qtquickcontrols2-private-headers-devel
# kdelibs4support       |       libSM-devel
#-----------------------|---------------------------------
# WORKSPACE             |       BUILD DEPENDENCY
#-----------------------|---------------------------------
# user-manager          |       libpwquality-devel
# kde-gtk-config        |       gtk2-devel gtk3-devel
# kfilemetadata         |       libattr-devel libtag-devel
# oxygen-fonts          |       fontforge-devel
# kwayland              |       wayland-devel libqt5-qtwayland-devel
# kwin                  |       xcb-util-image-devel xcb-util-cursor-devel
# kcm-touchpad          |       xf86-input-synaptics-devel xorg-x11-util-devel libX11-devel  libxkbcommon-x11-devel xf86-input-wacom-devel
# kscreenlocker         |       pam-devel
# kwin                  |       xcb-util-devel
# plasma-desktop        |       libxkbfile-devel
# breeze-gtk            |       python3-cairo-devel sassc
# kgamma                |       libXxf86vm-devel
# plasma-pa             |       libcanberra-devel
# plymouth-kcm          |       plymouth-devel
# xdg-desktop-portal-kde        pipewire-devel Mesa-devel libQt5PrintSupport-private-headers-devel
#-----------------------|---------------------------------
# APPLICATIONS          |       BUILD DEPENDENCY
#-----------------------|---------------------------------
# kdevplatform          |       grantlee5-devel
# gwenview              |       libexiv2-devel
# lokalize              |       hunspell-devel
# libksane              |       sane-backends-devel
# kalgebra              |       glu-devel
# parley                |       libqt5-qtmultimedia-devel
# step                  |       eigen3-devel
# kcalc                 |       gmp-devel mpfr-devel
# print-manager         |       cups-devel
# ark                   |       libarchive-devel
# kmix                  |       alsa-devel
# libkdegames           |       libsndfile-devel openal-soft-devel
# ksirk                 |       libqca-qt5-devel
# falkon                |       libqt5-qtwebengine-devel libopenssl-devel
#-----------------------|---------------------------------
# PIM                   |       BUILD DEPENDENCY
#-----------------------|---------------------------------
# prison                |       libdmtx-devel qrencode-devel
# kcalcore              |       libical-devel
# kimap                 |       cyrus-sasl-devel
# kldap                 |       openldap2-devel
# gpgmepp               |       libgpgme-devel
#-----------------------|---------------------------------


# install dependencies
#---------------------
RUN zypper --non-interactive in vim tar git bzr cmake doxygen mc x11vnc dbus-1-x11
RUN zypper --non-interactive in perl-libwww-perl perl-XML-Parser perl-JSON perl-YAML-LibYAML perl-IO-Socket-SSL \
                                    dialog python ca-certificates
RUN zypper --non-interactive in --force-resolution \
        libQt5DBus-devel ca-certificates-mozilla \
        libQt5Test-devel \
        gettext-tools libQt5Concurrent-devel libqt5-qtscript-devel \
        libqt5-qtx11extras-devel xcb-util-keysyms-devel xcb-util-wm-devel \
        libxslt-devel docbook-xsl-stylesheets \
        libqt5-qttools-devel \
        libQt5PrintSupport-devel \
        libudev-devel \
        libqt5-qtsvg-devel \
        libepoxy-devel \
        boost-devel \
        libQt5WebKit5-devel libQt5WebKitWidgets-devel \
        giflib-devel libjpeg8-devel \
        libQt5PlatformSupport-private-headers-devel \
        libqt5-qtxmlpatterns-devel \
        vlc-devel \
        libQt5OpenGL-devel gstreamer-editing-services-devel \
        ModemManager-devel \
        NetworkManager-devel \
        gperf polkit-devel flex bison automake autoconf makeinfo \
        libqt5-qtquickcontrols2 libqt5-qtquickcontrols2-private-headers-devel libqt5-qtwayland-devel libSM-devel
# Workspace runtime dependencies
RUN zypper --non-interactive in libqt5-qtquickcontrols libqt5-qtgraphicaleffects
RUN zypper --non-interactive in \
        libpwquality-devel \
        gtk2-devel gtk3-devel \
        libattr-devel libtag-devel \
        fontforge-devel \
        xcb-util-image-devel xcb-util-cursor-devel \
        xf86-input-synaptics-devel xorg-x11-util-devel libX11-devel  libxkbcommon-x11-devel xf86-input-wacom-devel \
        libxapian-devel lmdb-devel pam-devel xcb-util-devel libxkbfile-devel python3-cairo-devel sassc libXxf86vm-devel libcanberra-devel \
        plymouth-devel pipewire-devel Mesa-devel libQt5PrintSupport-private-headers-devel
RUN zypper --non-interactive in \
                              grantlee5-devel \
                              libexiv2-devel \
                              hunspell-devel \
                              sane-backends-devel \
                              glu-devel \
                              libqt5-qtmultimedia-devel \
                              eigen3-devel \
                              gmp-devel mpfr-devel \
                              cups-devel \
                              libarchive-devel \
                              alsa-devel \
                              libsndfile-devel openal-soft-devel \
                              libqca-qt5-devel \
                              libqt5-qtwebengine-devel libopenssl-devel
RUN zypper --non-interactive in \
                                libdmtx-devel qrencode-devel \
                                libical-devel \
                                cyrus-sasl-devel \
                                openldap2-devel \
                                libgpgme-devel
# some commands needed by startkde script
RUN zypper --non-interactive in xset xsetroot xprop

RUN groupadd --gid=1000 kdedev && useradd -d /home/kdedev -m -G users,kdedev --uid=1000 kdedev && \
    mkdir /work /qt && \
    chown kdedev /work /qt

# some symlinks in /root to handle sudo ./kdesrc-build
RUN ln -s /home/kdedev/.kdesrc-buildrc /root/.kdesrc-buildrc && \
    ln -s /home/kdedev/kdesrc-build /root/kdesrc-build
# setup kdedev account
RUN zypper --non-interactive in sudo && \
    echo 'kdedev ALL=NOPASSWD: ALL' >> /etc/sudoers && \
    gpasswd -a kdedev video
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