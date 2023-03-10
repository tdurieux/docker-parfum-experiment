FROM ubuntu:latest
MAINTAINER Patwie <mail@patwie.com>
RUN \
 apt -y update && \
apt -y upgrade && \
 apt -y --no-install-recommends install build-essential cmake gdb git iputils-ping nano perl python valgrind wget && \
 apt -y --no-install-recommends install mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev && \
 apt -y --no-install-recommends install zlib1g-dev libssl-dev libnss3-dev libmysqlclient-dev libsqlite3-dev libxslt-dev libxml2-dev libjpeg-dev libpng-dev libopus-dev && \
 apt -y --no-install-recommends install libxcursor-dev libxcb1-dev libxcb-xkb-dev libx11-xcb-dev libxrender-dev libxi-dev libxcb-xinerama0-dev && \
apt -y autoremove && \
apt -y autoclean && \
cd /opt && \
 wget -q https://download.qt.io/official_releases/qt/5.9/5.9.2/single/qt-everywhere-opensource-src-5.9.2.tar.xz && \
tar xf qt-everywhere-opensource-src-5.9.2.tar.xz && \
rm qt-everywhere-opensource-src-5.9.2.tar.xz && \
cd qt-everywhere-opensource-src-5.9.2 && \
 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -opensource -confirm-license -release -static -nomake tests -nomake examples -no-compile-examples && \
make -j $(($(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)+2)) && \
make install && \
cd /opt && \
rm -rf qt-everywhere-opensource-src-5.9.2 && \
exit 0 && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install libfreeimage3 \
    libfreeimage-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    freeglut3-dev && rm -rf /var/lib/apt/lists/*;
ENV PATH="${PATH}:/usr/local/Qt-5.9.2/bin"
WORKDIR /data
VOLUME ["/data"]

# run me by sudo docker run --user="$(id -u):$(id -g)" --net=none -v /tmp/saccade:/data -i -t qt59static cmake .
# run me by sudo docker run --user="$(id -u):$(id -g)" --net=none -v /tmp/saccade:/data -i -t qt59static qmake .
# run me by sudo docker run --user="$(id -u):$(id -g)" --net=none -v /tmp/saccade:/data -i -t qt59static make
