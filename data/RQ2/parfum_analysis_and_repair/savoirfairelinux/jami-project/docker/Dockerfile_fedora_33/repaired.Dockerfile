FROM fedora:33

RUN dnf clean all

RUN dnf install -y dnf-command\(builddep\) rpmdevtools && \
    dnf install -y mock

RUN dnf groupinstall -y "X Software Development"

RUN dnf install -y \
        git \
        rpm-build \
        tar \
        make \
        autoconf \
        automake \
        nasm \
        speexdsp-devel \
        pulseaudio-libs-devel \
        libcanberra-devel \
        libcurl-devel \
        libtool \
        mesa-libgbm-devel \
        mesa-dri-drivers \
        dbus-devel \
        expat-devel \
        pcre-devel \
        yaml-cpp-devel \
        dbus-c++-devel \
        dbus-devel \
        libXext-devel \
        libXfixes-devel \
        yasm \
        speex-devel \
        gsm-devel \
        chrpath \
        check \
        astyle \
        uuid-c++-devel \
        gettext-devel \
        gcc-c++ \
        which \
        alsa-lib-devel \
        systemd-devel \
        libuuid-devel \
        uuid-devel \
        gnutls-devel \
        nettle-devel \
        opus-devel \
        patch \
        python2.7 \
        jsoncpp-devel \
        libnatpmp-devel \
        webkitgtk4-devel \
        cryptopp-devel \
        libva-devel \
        libvdpau-devel \
        msgpack-devel \
        NetworkManager-libnm-devel \
        openssl-devel \
        openssl-static \
        clutter-devel \
        clutter-gtk-devel \
        libappindicator-gtk3-devel \
        libnotify-devel \
        libupnp-devel \
        qrencode-devel \
        libargon2-devel \
        libsndfile-devel \
        libdrm \
        gperf \
        clang \
        clang-devel \
        llvm-devel \
        nodejs \
        bison \
        flex \
        gstreamer1 gstreamer1-devel \
        gstreamer1-plugins-base-devel \
        gstreamer1-plugins-good \
        gstreamer1-plugins-bad-free-devel \
        nss-devel \
        libxcb* \
        libxkb* \
        libXrender-devel \
        xcb-util-* \
        libX11-devel \
        xz \
        xkeyboard-config \
        libnotify \
        wget \
        libstdc++-static \
        sqlite-devel \
        perl-generators \
        perl-English \
        libxshmfence-devel \
        ninja-build \
        vulkan-devel \
        python2-six \
        cmake

ADD scripts/build-package-rpm.sh /opt/build-package-rpm.sh

CMD ["/opt/build-package-rpm.sh"]