FROM ubuntu:18.04 AS build
WORKDIR /home

# COMMON BUILD TOOLS
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends build-essential autoconf make git wget pciutils cpio libtool lsb-release ca-certificates pkg-config bison flex libcurl4-gnutls-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN git config --global http.proxy ${http_proxy}
RUN git config --global https.proxy ${https_proxy}

# Install cmake
ARG CMAKE_VER=3.13.1
ARG CMAKE_REPO=https://cmake.org/files
RUN wget -O - ${CMAKE_REPO}/v${CMAKE_VER%.*}/cmake-${CMAKE_VER}.tar.gz | tar xz && \
    cd cmake-${CMAKE_VER} && \
    ./bootstrap --prefix="/usr" --system-curl && \
    make -j8 && \
    make install

# Install automake, use version 1.14 on CentOS
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz
    RUN apt-get install --no-install-recommends -y -q automake && rm -rf /var/lib/apt/lists/*;

# Build NASM
ARG NASM_VER=2.13.03
ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2
RUN wget ${NASM_REPO} && \
     tar -xaf nasm* && \
     cd nasm-${NASM_VER} && \
     ./autogen.sh && \
     ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu && \
     make -j8 && \
     make install

# Build YASM
ARG YASM_VER=1.3.0
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-${YASM_VER}.tar.gz
RUN wget -O - ${YASM_REPO} | tar xz && \
     cd yasm-${YASM_VER} && \
     sed -i "s/) ytasm.*/)/" Makefile.in && \
     ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu && \
     make -j8 && \
     make install

# Build ogg
ARG OGG_VER=1.3.3
ARG OGG_REPO=https://downloads.xiph.org/releases/ogg/libogg-${OGG_VER}.tar.xz

RUN wget -O - ${OGG_REPO} | tar xJ && \
    cd libogg-${OGG_VER} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build vorbis
ARG VORBIS_VER=1.3.6
ARG VORBIS_REPO=https://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VER}.tar.xz

RUN wget -O - ${VORBIS_REPO} | tar xJ && \
    cd libvorbis-${VORBIS_VER} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build mp3lame
ARG MP3LAME_VER=3.100
ARG MP3LAME_REPO=https://sourceforge.net/projects/lame/files/lame/${MP3LAME_VER}/lame-${MP3LAME_VER}.tar.gz

RUN wget -O - ${MP3LAME_REPO} | tar xz && \
    cd lame-${MP3LAME_VER} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared --enable-nasm && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build fdk-aac
ARG FDK_AAC_VER=v0.1.6
ARG FDK_AAC_REPO=https://github.com/mstorsjo/fdk-aac/archive/${FDK_AAC_VER}.tar.gz

RUN wget -O - ${FDK_AAC_REPO} | tar xz && mv fdk-aac-${FDK_AAC_VER#v} fdk-aac && \
    cd fdk-aac && \
    autoreconf -fiv && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install


# Build opus
ARG OPUS_VER=1.2.1
ARG OPUS_REPO=https://archive.mozilla.org/pub/opus/opus-${OPUS_VER}.tar.gz

RUN wget -O - ${OPUS_REPO} | tar xz && \
    cd opus-${OPUS_VER} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build vpx
ARG VPX_VER=tags/v1.7.0
ARG VPX_REPO=https://chromium.googlesource.com/webm/libvpx.git

RUN git clone ${VPX_REPO} && \
    cd libvpx && \
    git checkout ${VPX_VER} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=nasm && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install


# Build AOM
ARG AOM_VER=b6f1767eedbaddeb1ff5aa409a710ef61078640e
ARG AOM_REPO=https://aomedia.googlesource.com/aom

RUN  git clone ${AOM_REPO} && \
     mkdir aom/aom_build && \
     cd aom/aom_build && \
     git checkout ${AOM_VER} && \
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_NASM=ON -DENABLE_TESTS=OFF -DENABLE_DOCS=OFF -DCMAKE_INSTALL_PREFIX="/usr" -DLIB_INSTALL_DIR=/usr/lib/x86_64-linux-gnu .. && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install

# Build x264
ARG X264_VER=stable
ARG X264_REPO=https://github.com/mirror/x264

RUN git clone ${X264_REPO} && \
     cd x264 && \
     git checkout ${X264_VER} && \
     ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install


# Build x265
ARG X265_VER=2.9
ARG X265_REPO=https://github.com/videolan/x265/archive/${X265_VER}.tar.gz

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libnuma-dev && rm -rf /var/lib/apt/lists/*;

RUN  wget -O - ${X265_REPO} | tar xz && mv x265-${X265_VER} x265 && \
     cd x265/build/linux && \
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr -DLIB_INSTALL_DIR=/usr/lib/x86_64-linux-gnu ../../source && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install

# Fetch SVT-HEVC
ARG SVT_HEVC_VER=20a47b0d904e9d99e089d93d7c33af92788cbfdb
ARG SVT_HEVC_REPO=https://github.com/intel/SVT-HEVC

RUN git clone ${SVT_HEVC_REPO} && \
    cd SVT-HEVC/Build/linux && \
    git checkout ${SVT_HEVC_VER} && \
    mkdir -p ../../Bin/Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install


# Fetch SVT-AV1
ARG SVT_AV1_VER=90b56a80795d4d0448673c4c7276ce6d5c8ac9d4
ARG SVT_AV1_REPO=https://github.com/OpenVisualCloud/SVT-AV1

RUN git clone ${SVT_AV1_REPO} && \
    cd SVT-AV1/Build/linux && \
    git checkout ${SVT_AV1_VER} && \
    mkdir -p ../../Bin/Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

#Remove build residue from SVT-AV1 build -- temp fix for bug
RUN if [ -d "build/home/" ]; then rm -rf build/home/; fi


# Fetch SVT-VP9
ARG SVT_VP9_VER=d18b4acf9139be2e83150e318ffd3dba1c432e74
ARG SVT_VP9_REPO=https://github.com/OpenVisualCloud/SVT-VP9

RUN git clone ${SVT_VP9_REPO} && \
    cd SVT-VP9/Build/linux && \
    git checkout ${SVT_VP9_VER} && \
    mkdir -p ../../Bin/Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Fetch gmmlib
ARG GMMLIB_VER=intel-gmmlib-19.4.1
ARG GMMLIB_REPO=https://github.com/intel/gmmlib/archive/${GMMLIB_VER}.tar.gz

RUN wget -O - ${GMMLIB_REPO} | tar xz && mv gmmlib-${GMMLIB_VER} gmmlib;


# Build libdrm
ARG LIBDRM_VER=2.4.96
ARG LIBDRM_REPO=https://dri.freedesktop.org/libdrm/libdrm-${LIBDRM_VER}.tar.gz

RUN apt-get update && apt-get install -y -q --no-install-recommends libpciaccess-dev && rm -rf /var/lib/apt/lists/*;

RUN wget -O - ${LIBDRM_REPO} | tar xz && \
    cd libdrm-${LIBDRM_VER} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install;


# Build libva
ARG LIBVA_VER=2.6.1
ARG LIBVA_REPO=https://github.com/intel/libva/archive/${LIBVA_VER}.tar.gz

RUN apt-get remove libva*

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libdrm-dev libx11-dev xorg-dev libgl1-mesa-dev openbox && rm -rf /var/lib/apt/lists/*;

RUN wget -O - ${LIBVA_REPO} | tar xz && \
    cd libva-${LIBVA_VER} && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install;


# Build libva-utils
ARG LIBVA_UTILS_VER=2.4.0
ARG LIBVA_UTILS_REPO=https://github.com/intel/libva-utils/archive/${LIBVA_UTILS_VER}.tar.gz

RUN wget -O - ${LIBVA_UTILS_REPO} | tar xz; \
    cd libva-utils-${LIBVA_UTILS_VER}; \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install;


# Build media driver
ARG MEDIA_DRIVER_VER=intel-media-19.4.0r
ARG MEDIA_DRIVER_REPO=https://github.com/intel/media-driver/archive/${MEDIA_DRIVER_VER}.tar.gz

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libdrm-dev libpciaccess-dev libx11-dev xorg-dev libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

RUN wget -O - ${MEDIA_DRIVER_REPO} | tar xz && mv media-driver-${MEDIA_DRIVER_VER} media-driver && \
    mkdir -p media-driver/build && \
    cd media-driver/build && \
    cmake -DBUILD_TYPE=release -DBUILD_ALONG_WITH_CMRTLIB=1 -DMEDIA_VERSION="2.0.0" -DBS_DIR_GMMLIB=/home/gmmlib/Source/GmmLib -DBS_DIR_COMMON=/home/gmmlib/Source/Common -DBS_DIR_INC=/home/gmmlib/Source/inc -DBS_DIR_MEDIA=/home/media-driver -Wno-dev -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install



# Build Intel(R) Media SDK
ARG MSDK_VER=MSS-KBL-2019-R1
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/archive/${MSDK_VER}.tar.gz

RUN wget -O - ${MSDK_REPO} | tar xz && mv MediaSDK-${MSDK_VER} MediaSDK && \
    mkdir -p MediaSDK/build && \
    cd MediaSDK/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_INCLUDEDIR=include/mfx -DBUILD_SAMPLES=OFF -DENABLE_OPENCL=OFF -Wno-dev .. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    rm -rf /home/build/usr/samples && \
    rm -rf /home/build/usr/plugins && \
    make install;

#install OpenCL

RUN mkdir neo

RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-gmmlib_19.3.2_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-igc-core_1.0.2597_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-igc-opencl_1.0.2597_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-opencl_19.41.14441_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-ocloc_19.41.14441_amd64.deb

RUN cd neo && \
    dpkg -i *.deb && \
    dpkg-deb -x intel-gmmlib_19.3.2_amd64.deb       /home/build/ && \
    dpkg-deb -x intel-igc-core_1.0.2597_amd64.deb   /home/build/ && \
    dpkg-deb -x intel-igc-opencl_1.0.2597_amd64.deb /home/build/ && \
    dpkg-deb -x intel-opencl_19.41.14441_amd64.deb  /home/build/ && \
    dpkg-deb -x intel-ocloc_19.41.14441_amd64.deb   /home/build/

# ARGS to download specific versions of openvino, uncomment the one to download
#R3
#ARG OPENVINO_BUNDLE=l_openvino_toolkit_p_2019.3.334
#ARG OPENVINO_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/15944/l_openvino_toolkit_p_2019.3.334.tgz
# 2020.1
#ARG OPENVINO_BUNDLE=l_openvino_toolkit_p_2020.1.023
#ARG OPENVINO_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/16345/l_openvino_toolkit_p_2020.1.023.tgz
# 2020.2
ARG OPENVINO_BUNDLE=l_openvino_toolkit_p_2020.2.120
ARG OPENVINO_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/16612/l_openvino_toolkit_p_2020.2.120.tgz

#Install OpenVino dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends cpio joe nano sudo unzip wget less \
libcairo2-dev libpango1.0-dev \
libglib2.0-dev libgtk2.0-dev libswscale-dev libavcodec-dev libavformat-dev build-essential \
libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;

#Download and unpack OpenVino
RUN mkdir /tmp2
RUN wget ${OPENVINO_URL} -P /tmp2
RUN if [ -f /tmp2/${OPENVINO_BUNDLE}.tgz ]; \
    then tar xzvf /tmp2/${OPENVINO_BUNDLE}.tgz -C /tmp2 && rm /tmp2/${OPENVINO_BUNDLE}.tgz; \
    else echo "Please prepare the OpenVino installation bundle"; \
fi

# Create a silent configuration file for install
RUN echo "ACCEPT_EULA=accept" > /tmp2/silent.cfg                        && \
    echo "CONTINUE_WITH_OPTIONAL_ERROR=yes" >> /tmp2/silent.cfg         && \
    echo "PSET_INSTALL_DIR=/opt/intel" >> /tmp2/silent.cfg              && \
    echo "CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes" >> /tmp2/silent.cfg   && \
    echo "COMPONENTS=DEFAULTS" >> /tmp2/silent.cfg                      && \
    echo "COMPONENTS=ALL" >> /tmp2/silent.cfg                           && \
    echo "PSET_MODE=install" >> /tmp2/silent.cfg                        && \
    echo "INTEL_SW_IMPROVEMENT_PROGRAM_CONSENT=no" >> /tmp2/silent.cfg  && \
    echo "SIGNING_ENABLED=no" >> /tmp2/silent.cfg

#Install OpenVino
RUN /tmp2/${OPENVINO_BUNDLE}/install.sh --ignore-signature --cli-mode -s /tmp2/silent.cfg && rm -rf /tmp2

#Remove components of OpenVino that won't be used
ARG CV_BASE_DIR=/opt/intel/openvino
RUN rm -rf ${CV_BASE_DIR}/uninstall*

#Copy over directories to copy over to clean image
RUN mkdir -p /home/build/usr/local/lib && \
    mkdir -p /home/build/opt/intel && \
    mkdir -p /home/build/usr/lib && \
    cp -r /usr/local/lib/* /home/build/usr/local/lib/ && \
    cp -r /opt/intel/* /home/build/opt/intel/ && \
    cp -r /usr/lib/* /home/build/usr/lib

ENV IE_PLUGINS_PATH=/opt/intel/openvino/deployment_tools/inference_engine/lib/intel64
ENV HDDL_INSTALL_DIR=/opt/intel/openvino/deployment_tools/inference_engine/external/hddl
ENV InferenceEngine_DIR="/opt/intel/openvino/deployment_tools/inference_engine/share"
ENV OpenCV_DIR=/opt/intel/openvino/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/openvino/deployment_tools/ngraph/lib:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:$IE_PLUGINS_PATH
RUN rm -rf /var/lib/apt/lists/*;


# Build librdkafka
ARG LIBRDKAFKA_VER=1.0.0
ARG FILE_NAME=v${LIBRDKAFKA_VER}
ARG LIBRDKAFKA_REPO=https://github.com/edenhill/librdkafka/archive/${FILE_NAME}.tar.gz

RUN wget -O - ${LIBRDKAFKA_REPO} | tar xz && \
    cd librdkafka-${LIBRDKAFKA_VER} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install;

ARG OPENCV_VER=4.3.0
ARG OPENCV_REPO=https://github.com/opencv/opencv/archive/${OPENCV_VER}.tar.gz

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libjson-c-dev libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python-numpy && rm -rf /var/lib/apt/lists/*;

RUN wget ${OPENCV_REPO} && \
    tar -zxvf ${OPENCV_VER}.tar.gz && \
    cd opencv-${OPENCV_VER} && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_EXAMPLES=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_DOCS=OFF -DBUILD_TESTS=OFF .. && \
    make -j $(nproc) && \
    make install DESTDIR=/home/build && \
    make install && rm ${OPENCV_VER}.tar.gz

ENV CPATH=$CPATH:/usr/local/include/opencv4/

# Fetch FFmpeg source
ENV IE_PATH=/opt/intel/openvino/deployment_tools/inference_engine
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libass-dev libfreetype6-dev libvdpau-dev libsdl2-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev zlib1g-dev libssl-dev ssh-client python3-dev && rm -rf /var/lib/apt/lists/*;

ADD patch /root/patch
ARG FFMPEG_VER=n4.2
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_VER}.tar.gz

ARG FFMPEG_MA_RELEASE_VER=0.5
ARG FFMPEG_MA_RELEASE_URL=https://github.com/VCDP/FFmpeg-patch/archive/v${FFMPEG_MA_RELEASE_VER}.tar.gz
ARG FFMPEG_MA_PATH=/home/FFmpeg-patch-${FFMPEG_MA_RELEASE_VER}
RUN wget -O - ${FFMPEG_MA_RELEASE_URL} | tar xz

# Compile FFmpeg
RUN wget -O - ${FFMPEG_REPO} | tar xz && mv FFmpeg-${FFMPEG_VER} FFmpeg

RUN cd /home/FFmpeg && \
    find ${FFMPEG_MA_PATH}/patches -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i && \
    cp /root/patch/opencv.pc /usr/lib/pkgconfig/ && \
    cp /root/patch/cvdef.h /usr/local/include/opencv4/opencv2/core/cvdef.h && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --extra-cflags="-I$IE_PATH/include" --extra-ldflags="-L$IE_PATH/lib/intel64" --libdir=/usr/lib/x86_64-linux-gnu --extra-libs="-lpthread -lm" --enable-shared --enable-gpl --enable-libass --enable-libfreetype --enable-openssl --enable-nonfree --enable-libdrm --enable-libmfx --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libaom --enable-librdkafka --enable-libjson_c --enable-libinference_engine_c_api --enable-libopencv --enable-python3 && \
    make -j8 && \
    make install DESTDIR="/home/build" && \
    cp -rf python /home/build/python

# Clean up after build
RUN rm -rf /home/build/usr/include && \
    rm -rf /home/build/usr/share/doc && \
    rm -rf /home/build/usr/share/gtk-doc && \
    rm -rf /home/build/usr/share/man && \
    find /home/build -name "*.a" -exec rm -f {} \;

FROM ubuntu:18.04
LABEL Description="This is the base image for FFMPEG & openvino Ubuntu 18.04 LTS"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libxv1 libxcb-shm0 libxcb-shape0 libxcb-xfixes0 libsdl2-2.0-0 libasound2 libvdpau1 libnuma1 libass-dev libssl1.0.0 libdrm2 libboost-all-dev libusb-1.0-0-dev libjson-c-dev python3-dev python3-pip ; \
    rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install Pillow numpy

# Install
COPY --from=build /home/build /
ENV LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
ENV LIBVA_DRIVER_NAME=iHD
RUN apt-get update && apt-get install --no-install-recommends -y clinfo && rm -rf /var/lib/apt/lists/*;
ENV IE_PLUGINS_PATH=/opt/intel/openvino/deployment_tools/inference_engine/lib/intel64
ENV HDDL_INSTALL_DIR=/opt/intel/openvino/deployment_tools/inference_engine/external/hddl
ENV InferenceEngine_DIR="/opt/intel/openvino/deployment_tools/inference_engine/share"
ENV OpenCV_DIR=/opt/intel/openvino/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/opt/intel/openvino/deployment_tools/ngraph/lib:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:$IE_PLUGINS_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/openvino/deployment_tools/ngraph/lib:/usr/local/lib:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:$IE_PLUGINS_PATH

