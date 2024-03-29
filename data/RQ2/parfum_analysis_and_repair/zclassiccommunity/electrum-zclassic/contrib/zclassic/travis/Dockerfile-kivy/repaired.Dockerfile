FROM ubuntu:16.04
LABEL maintainer "Andriy Khavryuchenko <akhavr@khavr.com>"

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        language-pack-en build-essential ccache git \
        libncurses5:i386 libstdc++6:i386 libgtk2.0-0:i386 \
        libpangox-1.0-0:i386 libpangoxft-1.0-0:i386 libidn11:i386 \
        openjdk-8-jdk unzip zlib1g-dev zlib1g:i386 \
        python3-dev python3-kivy \
        wget vim less autoconf automake libtool \
        ffmpeg \
        libsdl2-dev \
        libsdl2-image-dev \
        libsdl2-mixer-dev \
        libsdl2-ttf-dev \
        libportmidi-dev \
        libswscale-dev \
        libavformat-dev \
        libavcodec-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py \
    && pip3 install --no-cache-dir --upgrade setuptools cython==0.21.2 Pillow

RUN git config --global user.email "buildozer@example.com" \
    && git config --global user.name "Buildozer"

RUN adduser --disabled-password --gecos '' buildozer && mkdir /home/buildozer/build

RUN cd /opt \
    && git clone https://github.com/kivy/python-for-android \
    && cd python-for-android \
    && git remote add agilewalker https://github.com/agilewalker/python-for-android \
    && git fetch --all \
    && git checkout 93759f36ba45c7bbe0456a4b3e6788622924cbac \
    && git merge -m 'merge1' a2fb5ecbc09c4847adbcfd03c6b1ca62b3d09b8d \
    && cd /opt \
    && git clone https://github.com/kivy/buildozer \
    && cd buildozer \
    && python3 setup.py install \
    && chown -R buildozer.buildozer /opt

RUN cd /opt \
    && wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.11-bin.tar.gz \
    && tar xzf apache-ant-1.9.11-bin.tar.gz \
    && rm apache-ant-1.9.11-bin.tar.gz \
    && chown -R buildozer.buildozer /opt

RUN cd /opt \
    && wget https://www.crystax.net/download/crystax-ndk-10.3.2-linux-x86_64.tar.xz \
    && tar xJf crystax-ndk-10.3.2-linux-x86_64.tar.xz \
    && rm crystax-ndk-10.3.2-linux-x86_64.tar.xz \
    && rm -rf \
        crystax-ndk-10.3.2/platforms/android-*/arch-mips* \
        crystax-ndk-10.3.2/platforms/android-*/arch-x86* \
        crystax-ndk-10.3.2/sources/boost/1.59.0/libs/mips* \
        crystax-ndk-10.3.2/sources/crystax/src/math/mips* \
        crystax-ndk-10.3.2/sources/crystax/src/include/crystax/mips* \
        crystax-ndk-10.3.2/sources/crystax/libs/mips* \
        crystax-ndk-10.3.2/sources/crystax/include/crystax/mips* \
        crystax-ndk-10.3.2/sources/libjpeg-turbo/1.4.2/libs/mips* \
        crystax-ndk-10.3.2/sources/python/2.7/libs/mips* \
        crystax-ndk-10.3.2/sources/python/3.5/libs/mips* \
        crystax-ndk-10.3.2/sources/icu/56.1/libs/mips* \
        crystax-ndk-10.3.2/sources/libjpeg/9a/libs/mips* \
        crystax-ndk-10.3.2/sources/objc/gnustep-libobjc2/libs/mips* \
        crystax-ndk-10.3.2/sources/objc/cocotron/0.1.0/frameworks/mips* \
        crystax-ndk-10.3.2/sources/sqlite/3/libs/mips* \
        crystax-ndk-10.3.2/sources/android/compiler-rt/libs/mips* \
        crystax-ndk-10.3.2/sources/android/gccunwind/libs/mips* \
        crystax-ndk-10.3.2/sources/libtiff/4.0.6/libs/mips* \
        crystax-ndk-10.3.2/sources/libpng/1.6.19/libs/mips* \
        crystax-ndk-10.3.2/sources/boost/1.59.0/libs/x86* \
        crystax-ndk-10.3.2/sources/crystax/src/math/x86* \
        crystax-ndk-10.3.2/sources/crystax/src/include/crystax/x86* \
        crystax-ndk-10.3.2/sources/crystax/libs/x86* \
        crystax-ndk-10.3.2/sources/crystax/include/crystax/x86* \
        crystax-ndk-10.3.2/sources/libjpeg-turbo/1.4.2/libs/x86* \
        crystax-ndk-10.3.2/sources/python/2.7/libs/x86* \
        crystax-ndk-10.3.2/sources/python/3.5/libs/x86* \
        crystax-ndk-10.3.2/sources/icu/56.1/libs/x86* \
        crystax-ndk-10.3.2/sources/libjpeg/9a/libs/x86* \
        crystax-ndk-10.3.2/sources/objc/gnustep-libobjc2/libs/x86* \
        crystax-ndk-10.3.2/sources/objc/cocotron/0.1.0/frameworks/x86* \
        crystax-ndk-10.3.2/sources/sqlite/3/libs/x86* \
        crystax-ndk-10.3.2/sources/android/compiler-rt/libs/x86* \
        crystax-ndk-10.3.2/sources/android/gccunwind/libs/x86* \
        crystax-ndk-10.3.2/sources/libtiff/4.0.6/libs/x86* \
        crystax-ndk-10.3.2/sources/libpng/1.6.19/libs/x86* \
        crystax-ndk-10.3.2/sources/cxx-stl/llvm-libc++/3.6/libs/x86* \
        crystax-ndk-10.3.2/sources/cxx-stl/llvm-libc++/3.6/libs/mips* \
        crystax-ndk-10.3.2/sources/cxx-stl/llvm-libc++/3.7/libs/x86* \
        crystax-ndk-10.3.2/sources/cxx-stl/llvm-libc++/3.7/libs/mips* \
        crystax-ndk-10.3.2/sources/cxx-stl/gnu-libstdc++/4.9/libs/x86* \
        crystax-ndk-10.3.2/sources/cxx-stl/gnu-libstdc++/4.9/libs/mips* \
        crystax-ndk-10.3.2/sources/cxx-stl/gnu-libstdc++/5/libs/x86* \
        crystax-ndk-10.3.2/sources/cxx-stl/gnu-libstdc++/5/libs/mips* \
    && chown -R buildozer.buildozer /opt/crystax-ndk-10.3.2

RUN cd /opt \
    && wget https://dl.google.com/android/android-sdk_r24-linux.tgz \
    && tar xzf android-sdk_r24-linux.tgz \
    && rm android-sdk_r24-linux.tgz \
    && (while sleep 3; do echo "y"; done) \
        | android-sdk-linux/tools/android update sdk -u -a -t \
            'tools, platform-tools-preview, build-tools-23.0.1' \
    && (while sleep 3; do echo "y"; done) \
        | android-sdk-linux/tools/android update sdk -u -a -t \
            'tools, platform-tools, build-tools-27.0.3' \
    && (while sleep 3; do echo "y"; done) \
        | android-sdk-linux/tools/android update sdk -u -a -t \
            'android-19,extra-android-m2repository' \
    && chown -R buildozer.buildozer /opt/android-sdk-linux

USER buildozer

WORKDIR /home/buildozer/build
