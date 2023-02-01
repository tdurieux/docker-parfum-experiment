FROM muttleyxd/a3ul_ubuntu-16.04_build

USER root

RUN apt-get update
RUN apt-get install --no-install-recommends -y patchelf zsync pkg-config fuse libfuse2 libtool zlib1g-dev zlibc libjpeg-dev libpng-dev libxkbcommon-x11-0 libegl1-mesa libfontconfig1-dev autotools-dev automake xxdiff desktop-file-utils libglib2.0-dev libcairo2-dev libfuse-dev libssl-dev vim python2.7 python2.7-dev && rm -rf /var/lib/apt/lists/*;

# Qt appimage stuff
RUN apt-get install --no-install-recommends -y libxcb-icccm4 libxcb-icccm4-dev libxcb-image0-dev libxcb-image0 libxcb-keysyms1 libxcb-keysyms1-dev libxcb-render-util0 libxcb-render-util0-dev libxcb-xinerama0 libxcb-xinerama0-dev && rm -rf /var/lib/apt/lists/*;

# Install boost
RUN mkdir /tmp/boost && cd /tmp/boost && wget https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.gz && tar xf boost_1_78_0.tar.gz && cd boost_1_78_0 && ./bootstrap.sh --prefix=/usr && ./b2 install --prefix=/usr && rm boost_1_78_0.tar.gz

ADD https://raw.githubusercontent.com/muttleyxd/docker-linuxdeploy/master/entrypoint.sh /
ADD https://raw.githubusercontent.com/muttleyxd/docker-linuxdeploy/master/install-appimagekit.sh /
ADD https://raw.githubusercontent.com/muttleyxd/docker-linuxdeploy/master/install-linuxdeploy.sh /
ADD https://raw.githubusercontent.com/muttleyxd/docker-linuxdeploy/master/install-linuxdeploy-plugin-appimage.sh /
ADD https://raw.githubusercontent.com/muttleyxd/docker-linuxdeploy/master/install-linuxdeploy-qt.sh /
ADD https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-conda/master/linuxdeploy-plugin-conda.sh /usr/local/bin/linuxdeploy-plugin-conda.sh

RUN chmod 755 /entrypoint.sh /install-appimagekit.sh /install-linuxdeploy.sh /install-linuxdeploy-plugin-appimage.sh /install-linuxdeploy-qt.sh /usr/local/bin/linuxdeploy-plugin-conda.sh
RUN /install-appimagekit.sh
RUN /install-linuxdeploy.sh
RUN /install-linuxdeploy-plugin-appimage.sh
RUN /install-linuxdeploy-qt.sh
RUN chmod +x /usr/local/bin/linuxdeploy-plugin-conda.sh

USER builduser

ENTRYPOINT ["/entrypoint.sh"]
