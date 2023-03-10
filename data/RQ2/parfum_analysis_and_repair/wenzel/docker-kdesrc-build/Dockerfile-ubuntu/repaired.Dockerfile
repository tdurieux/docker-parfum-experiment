FROM ubuntu:18.04
MAINTAINER Mathieu Tarral <mathieu.tarral@gmail.com>

# FRAMEWORKS            |       BUILD DEPENDENCY
#-----------------------|---------------------------------
# kcodecs               |       gperf
# kservice              |       flex bison
# ki18n                 |       qtscript5-dev
# kwindowsystem         |       libqt5x11extras5-dev
# kwidgetsaddons        |       qttools5-dev
# kiconthemes           |       libqt5svg5-dev
# kwallet               |       libgcrypt20-dev
# kdeclarative          |       qtdeclarative5-dev libepoxy-dev
# kactivities           |       libboost-all-dev
# kdewebkit             |       libqt5webkit5-dev
# kdelib4support        |       libsm-dev
# khtml                 |       libgif-dev libjpeg-dev libpng-dev
# frameworkintegration  |       libxcursor-dev
# ktexteditor           |       libqt5xmlpatterns5-dev
# polkit-qt-1           |       libpolkit-agent-1-dev
# phonon-vlc            |       libvlc-dev libvlccore-dev
# phonon-gstreamer      |       libgstreamer-plugins-base1.0-dev
# akonadi               |       xsltproc
# networkmanager-qt     |       libnm-glib-dev modemmanager-dev
#-----------------------|---------------------------------

# Install dependencies
#---------------------------
# set noninteractive frontend only during build
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -y git bzr vim g++ cmake tar doxygen gnupg && \
    apt-get install --no-install-recommends -y libwww-perl libxml-parser-perl libjson-perl libyaml-libyaml-perl dialog gettext libxrender-dev pkg-config libxcb-keysyms1-dev docbook-xsl libxslt1-dev libxml2-utils libudev-dev libqt4-dev && \
    apt-get install --no-install-recommends -y \
                        gperf \
                        flex bison \
                        qtscript5-dev \
                        libqt5x11extras5-dev \
                        qttools5-dev \
                        libqt5svg5-dev \
                        libgcrypt20-dev \
                        qtdeclarative5-dev libepoxy-dev \
                        libboost-all-dev \
                        libqt5webkit5-dev \
                        libsm-dev \
                        libgif-dev libjpeg-dev libpng-dev \
                        libxcursor-dev \
                        libqt5xmlpatterns5-dev \
                        libpolkit-agent-1-dev \
                        libvlc-dev libvlccore-dev \
                        libgstreamer-plugins-base1.0-dev \
                        xsltproc \
                        libnm-glib-dev modemmanager-dev && \
    useradd -d /home/kdedev -m kdedev && \
    mkdir /work /qt && \
    chown kdedev /work /qt && rm -rf /var/lib/apt/lists/*;

# some symlinks in /root to handle sudo ./kdesrc-build
RUN ln -s /home/kdedev/.kdesrc-buildrc /root/.kdesrc-buildrc && \
    ln -s /home/kdedev/kdesrc-build /root/kdesrc-build
# setup kdedev account
RUN apt-get install --no-install-recommends -y sudo && echo 'kdedev ALL=NOPASSWD: ALL' >> /etc/sudoers && rm -rf /var/lib/apt/lists/*;
USER kdedev
ENV HOME /home/kdedev
WORKDIR /home/kdedev/
# kde anongit url alias
RUN git config --global user.name "Your Name" && \
    git config --global user.email "you@email.com" && \
    git clone https://invent.kde.org/sdk/kdesrc-build.git

VOLUME /work
VOLUME /qt

CMD ["bash"]
