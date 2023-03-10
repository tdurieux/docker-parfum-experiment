FROM ubuntu:16.04
RUN apt-get -y update && apt-get install --no-install-recommends -y \
        bison \
        build-essential \
        curl \
        flex \
        git \
        gperf \
        libasound2-dev \
        libassimp-dev \
        libatspi2.0-dev \
        libavcodec-dev \
        libavdevice-dev \
        libavfilter-dev \
        libavformat-dev \
        libavresample-dev \
        libavutil-dev \
        libbluetooth-dev \
        libdbus-1-dev \
        libdouble-conversion-dev \
        libegl1-mesa-dev \
        libevent-dev \
        libgl1-mesa-dev \
        libgles2-mesa-dev \
        libglu1-mesa-dev \
        libgps-dev \
        libgstreamer0.10-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base0.10-dev \

        libgypsy-dev \
        libharfbuzz-dev \
        libfreetype6-dev \
        libicu-dev \
        libjsoncpp-dev \
        libminizip-dev \
        libnss3-dev \
        libopenal-dev \

        libopus-dev \
        libpcre2-dev \
        libpcre3-dev \
        libpng-dev \
        libpostproc-dev \
        libproxy-dev \
        libre2-dev \
        libsctp-dev \
        libsdl2-dev \
        libsensors4-dev \
        libsnappy-dev \
        libsqlite3-dev \
        libsrtp-dev \
        libswresample-dev \
        libswscale-dev \
        libsyslog-ng-dev \

        libvpx-dev \
        libvulkan-dev \
        libx11-xcb-dev \
        '^libxcb.*-dev' \
        libxcb-xinerama0-dev \
        libxi-dev \
        libxrender-dev \
        libxslt-dev \
        mesa-common-dev \
        mesa-utils \
        ninja-build \
        perl \
        python \
        ruby \
        nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade
RUN echo 'APT::Install-Recommends "0" ; APT::Install-Suggests "0" ;' >> /etc/apt/apt.conf
RUN apt-get build-dep qt5-default -y || true








































































RUN apt-get autoremove -y && apt-get clean -y
RUN rm -rf /var/lib/apt/lists/* /usr/share/man

ARG QT_VERSION_MAJOR=5.10
ARG QT_VERSION=5.10.0
ENV QT_URL http://download.qt.io/official_releases/qt/"$QT_VERSION_MAJOR"/"$QT_VERSION"/single/qt-everywhere-src-"$QT_VERSION".tar.xz
ENV QT_DIST /usr/local/Qt-$QT_VERSION
ENV QT_DIR /root/qt5

RUN echo "URL  IS $QT_URL"
RUN echo "DIST IS $QT_DIST"

WORKDIR $QT_DIR
RUN curl -f -s -S -L "$QT_URL" | tar xJ \
	&& mv qt-everywhere* src \
	&& mkdir build

WORKDIR build
RUN bash ../src/configure --help
RUN bash ../src/configure -list-libraries || true
RUN bash ../src/configure -list-features || true
RUN bash ../src/configure \
	-release \
	-static \
	-continue \
	-no-warnings-are-errors \
	-opensource \
	-confirm-license \
	-recheck-all \
	-force-debug-info \
#	-separate-debug-info \
#	-optimized-tools \
	-qtlibinfix octomy \
	-c++std c++14 \
	-ltcg \
	-use-gold-linker \
	-silent \
	-optimize-size \
	-alsa \
	-opengl es2 \
	-opengles3 \
	-gui \
	-gstreamer \
	-nomake tests \
	-nomake examples \
	-no-gtkstyle \
	-no-compile-examples \
	-assimp \
	-skip qtwebengine \
	-skip qtscript \
	-skip enginio \
	-skip qtcanvas3d \
	-skip qtscxml \
	-skip qtwebchannel \
	-skip qtwebsockets \
	-skip qtwebview \
	-system-zlib \
	-system-libjpeg \
	-system-libpng \
	-system-xcb \
	-system-xkbcommon \
	-system-freetype \
	-system-pcre \
	-system-harfbuzz \
	-prefix $QT_DIST

RUN make -j $(nproc)
RUN make -j $(nproc) install
ENV PATH=$QT_DIST/bin:$PATH
# Save space by deleting the source and build files
RUN rm -rf $QT_DIR

