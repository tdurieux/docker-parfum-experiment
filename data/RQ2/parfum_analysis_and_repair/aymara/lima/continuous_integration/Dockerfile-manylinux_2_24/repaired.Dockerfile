FROM quay.io/pypa/manylinux_2_24_x86_64 AS manylinux_2_24_with_qt_and_pyside

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/python/cp38-cp38/bin:${PATH}"

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN locale

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        wget build-essential pkg-config automake gawk gettext \
        firebird-dev \
        freetds-dev \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-x \
        libasound2-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libbz2-dev \
        libcap-dev \
        libdbus-1-dev \
        libdbus-glib-1-dev \
        libdrm-dev \
        libegl1-mesa-dev \
        libevent-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libgbm-dev \
        libgcrypt20-dev \
        libgles2-mesa-dev \
        libglib2.0-dev \
        libgst-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer1.0-dev \
        libicu-dev \
        libinput-dev \
        libiodbc2-dev \
        libjpeg62-turbo-dev \
        libjsoncpp-dev \
        libminizip-dev \
        libnss3-dev \
        libopus-dev \
        libpci-dev \
        libpng-dev \
        libpng16-16 \
        libpq-dev \
        libpulse-dev \
        librsvg2-common \
        libsnappy-dev \
        libsqlite0-dev \
        libsqlite3-dev \
        libsrtp0-dev \
        libsrtp2-dev \
        libssl-dev \
        libssl1.1 \
        libswscale-dev \
        libsystemd-dev \
        libudev-dev \
        libvpx-dev \
        libwayland-dev \
        libwebp-dev \
        libx11-dev \
        libx11-xcb-dev \
        libx11-xcb1 \
        libxcb-glx0-dev \
        libxcb-icccm4 \
        libxcb-icccm4-dev \
        libxcb-image0 \
        libxcb-image0-dev \
        libxcb-keysyms1 \
        libxcb-keysyms1-dev \
        libxcb-randr0-dev \
        libxcb-render-util0 \
        libxcb-render-util0-dev \
        libxcb-shape0-dev \
        libxcb-shm0 \
        libxcb-shm0-dev \
        libxcb-sync-dev \
        libxcb-sync1 \
        libxcb-xfixes0-dev \
        libxcb-xinerama0 \
        libxcb-xinerama0-dev \
        libxcb1 \
        libxcb1-dev \
        libxext-dev \
        libxi-dev \
        libxkbcommon-dev \
        libxrender-dev \
        libxslt1-dev \
        libxss-dev \
        libxtst-dev \
        nodejs \
        ruby \
        va-driver-all \
        lsb-release \
        libssl-dev \
        gperf \
        dos2unix && rm -rf /var/lib/apt/lists/*;
RUN apt remove -y libpython3.5-stdlib libpython3.5-minimal
RUN install -d /src
WORKDIR /src
RUN wget -q https://download.qt.io/archive/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.tar.xz
RUN tar xf qt-everywhere-src-5.15.2.tar.xz && rm qt-everywhere-src-5.15.2.tar.xz

WORKDIR /
COPY build_qt5.sh /
#RUN apt install -y lsb-release
RUN bash /build_qt5.sh


RUN echo "LC_ALL=en_US.UTF-8" > /etc/default/locale
RUN echo "LANG=en_US.UTF-8" >> /etc/default/locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN cp  /etc/default/locale /etc/environment
RUN locale-gen
RUN dpkg-reconfigure locales

RUN python3.8 -m pip install scikit-build ninja
ENV PATH="/opt/python/cp38-cp38/bin:${PATH}"
RUN cmake --version

ENV PATH=/opt/qt5/5.15.2/gcc_64/bin:$PATH

WORKDIR /
RUN wget -q https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-13.0.0.tar.gz
RUN tar xf llvmorg-13.0.0.tar.gz && rm llvmorg-13.0.0.tar.gz
WORKDIR /llvm-project-llvmorg-13.0.0
RUN cmake -S llvm -B build -G Ninja -DLLVM_PARALLEL_LINK_JOBS=1 -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_ENABLE_PROJECTS="clang"
# -DLLVM_USE_LINKER=gold -DLLVM_USE_SPLIT_DWARF=ON
RUN cmake --build build
RUN cmake --install build



# Install PySide2 and shiboken2 from source as binary installs are broken
# Done in /home/gael/Logiciels/
WORKDIR /
RUN git clone https://code.qt.io/cgit/pyside/pyside-setup.git
WORKDIR /pyside-setup
RUN git checkout 5.15.2
RUN install -d /opt/_internal/cpython-3.8.12/lib/x86_64-linux-gnu/
RUN touch /opt/_internal/cpython-3.8.12/lib/x86_64-linux-gnu/libpython3.8.a

RUN apt-get update -y -qq && apt-get install --no-install-recommends -y libpulse-mainloop-glib0 && rm -rf /var/lib/apt/lists/*;

WORKDIR /pyside-setup
RUN python3.8 -m pip install cmake

ENV QTDIR=/opt/qt5
ENV PATH=/opt/qt5/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/qt5/lib:$LD_LIBRARY_PATH

RUN python3.8 setup.py install --cmake=/opt/python/cp38-cp38/bin/cmake --build-type=all

WORKDIR /



################################################################################
################################################################################
################################################################################





FROM quay.io/pypa/manylinux_2_24_x86_64 AS manylinux_2_24_with_tensorflow_for_lima_1_9

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN echo "LC_ALL=en_US.UTF-8" > /etc/default/locale
RUN echo "LANG=en_US.UTF-8" >> /etc/default/locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN cp  /etc/default/locale /etc/environment
RUN locale-gen
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ARG BRANCH=master
ARG USE_TENSORFLOW="true"
ARG GITHUB_TOKEN
ARG LIMA_DISABLE_FSW_TESTING
ARG LIMA_DISABLE_CPACK_DEBIAN_PACKAGE_SHLIBDEPS
ARG NLTK_PTB_DP_FILE

RUN apt-get update -y -qq && apt-get install --no-install-recommends -y git build-essential pkg-config automake wget && rm -rf /var/lib/apt/lists/*;


RUN python3.8 -m pip install cmake ninja
ENV PATH="/opt/python/cp38-cp38/bin:${PATH}"

WORKDIR /
RUN wget -q https://launchpad.net/~limapublisher/+archive/ubuntu/ppa/+sourcefiles/tensorflow-for-lima/1.9-ubuntu7~20.10/tensorflow-for-lima_1.9.orig.tar.xz
RUN tar xf tensorflow-for-lima_1.9.orig.tar.xz && rm tensorflow-for-lima_1.9.orig.tar.xz
RUN git clone -b r1.9 https://github.com/aymara/tensorflow.git
RUN cp -r /tensorflow-for-lima-1.9/external /tensorflow
WORKDIR /tensorflow
#RUN bash ./download_dependencies.sh
RUN install -d /tensorflow/tensorflow-build
WORKDIR /tensorflow/tensorflow-build
RUN cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX=/tensorflow_for_lima ../tensorflow/contrib/cmake
RUN make -C /tensorflow/tensorflow-build -j 1
RUN make -C /tensorflow/tensorflow-build -j 1 install




################################################################################
################################################################################
################################################################################




FROM quay.io/pypa/manylinux_2_24_x86_64 AS manylinux_2_24_with_icu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN echo "LC_ALL=en_US.UTF-8" > /etc/default/locale
RUN echo "LANG=en_US.UTF-8" >> /etc/default/locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN cp  /etc/default/locale /etc/environment
RUN locale-gen
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        wget build-essential pkg-config automake gawk gettext && rm -rf /var/lib/apt/lists/*;

WORKDIR /
# Cloning icu ASAP to avoid
RUN git clone https://github.com/unicode-org/icu.git --depth=1 --branch=release-70-1
WORKDIR /icu/icu4c/source
RUN ./runConfigureICU Linux --prefix=/usr/local --enable-static && make -j && make test && make install

WORKDIR /
# Download boost, untar, setup install with bootstrap and only do the Program Options library,
# and then install
RUN wget -q https://downloads.sourceforge.net/project/boost/boost/1.78.0/boost_1_78_0.tar.gz
RUN tar xfz boost_1_78_0.tar.gz && rm boost_1_78_0.tar.gz
RUN rm boost_1_78_0.tar.gz
WORKDIR /boost_1_78_0
RUN ./bootstrap.sh --prefix=/usr/local --with-libraries=program_options,regex,filesystem,system,thread,test
RUN ./b2 install
RUN rm -rf boost_1_78_0




################################################################################
################################################################################
################################################################################




FROM quay.io/pypa/manylinux_2_24_x86_64 AS manylinux_2_24_with_nltk_data

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN echo "LC_ALL=en_US.UTF-8" > /etc/default/locale
RUN echo "LANG=en_US.UTF-8" >> /etc/default/locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN cp  /etc/default/locale /etc/environment
RUN locale-gen
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update -y -qq && apt-get install --no-install-recommends -y python3-nltk libtre-dev gnupg libssl-dev nodejs && rm -rf /var/lib/apt/lists/*;
# Not available in manylinux: libenchant-2-dev npm

WORKDIR /

RUN sed -ie "s|DEFAULT_URL = 'http://nltk.googlecode.com/svn/trunk/nltk_data/index.xml'|DEFAULT_URL = 'http://nltk.github.com/nltk_data/'|" /usr/lib/python*/*/nltk/downloader.py
RUN python3.5 -m nltk.downloader -d nltk_data dependency_treebank
RUN cat nltk_data/corpora/dependency_treebank/wsj_*.dp | grep -v "^$" > nltk_data/corpora/dependency_treebank/nltk-ptb.dp




################################################################################
################################################################################
################################################################################




FROM quay.io/pypa/manylinux_2_24_x86_64 AS lima-manylinux

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN echo "LC_ALL=en_US.UTF-8" > /etc/default/locale
RUN echo "LANG=en_US.UTF-8" >> /etc/default/locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN cp  /etc/default/locale /etc/environment
RUN locale-gen
RUN dpkg-reconfigure locales
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

COPY --from=manylinux_2_24_with_qt_and_pyside /opt /opt
COPY --from=manylinux_2_24_with_qt_and_pyside /usr/local /usr/local
COPY --from=manylinux_2_24_with_icu /usr/local /usr/local
COPY --from=manylinux_2_24_with_nltk_data /nltk_data /nltk_data
COPY --from=manylinux_2_24_with_tensorflow_for_lima_1_9 /tensorflow_for_lima /usr/local

ARG BRANCH=master
ARG USE_TENSORFLOW="true"
ARG GITHUB_TOKEN
ARG LIMA_DISABLE_FSW_TESTING
ARG LIMA_DISABLE_CPACK_DEBIAN_PACKAGE_SHLIBDEPS
ARG NLTK_PTB_DP_FILE

# Setup
RUN apt --fix-broken install
RUN apt-get update -y -qq && apt-get install --no-install-recommends -y \
        wget build-essential pkg-config automake \
        gawk \
        ninja-build \
        gettext \
        libpulse0 \
        libasound2 \
        libgstreamer1.0 \
        libpulse-mainloop-glib0 \
        gstreamer1.0-x && rm -rf /var/lib/apt/lists/*;

ENV QTDIR=/opt/qt5
ENV PATH=/opt/qt5/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/qt5/lib:$LD_LIBRARY_PATH

WORKDIR /
RUN wget -q https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.9.5.tar.xz
RUN tar xf git-2.9.5.tar.xz && rm git-2.9.5.tar.xz
WORKDIR /git-2.9.5
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make -j && make install

WORKDIR /git-lfs
RUN wget -q https://github.com/git-lfs/git-lfs/releases/download/v3.0.2/git-lfs-linux-amd64-v3.0.2.tar.gz
RUN tar xf git-lfs-linux-amd64-v3.0.2.tar.gz && rm git-lfs-linux-amd64-v3.0.2.tar.gz
RUN bash install.sh

RUN git lfs install --skip-repo

WORKDIR /
RUN wget --no-check-certificate https://osmot.cs.cornell.edu/svm_light/current/svm_light.tar.gz -q
WORKDIR /svm_light
RUN tar xzf ../svm_light.tar.gz && rm ../svm_light.tar.gz
RUN make
RUN cp svm_classify svm_learn /usr/bin
RUN rm -Rf /svm_light

WORKDIR /
COPY svmtool.sh  svmtool-cpp.sh qhttpserver.sh /
RUN /svmtool.sh $GITHUB_TOKEN
RUN /svmtool-cpp.sh $GITHUB_TOKEN
RUN /qhttpserver.sh $GITHUB_TOKEN

RUN apt remove -y libpython3.5-stdlib libpython3.5-minimal

RUN mkdir -p /src/
RUN git clone -v --branch=$BRANCH --recurse-submodules https://${GITHUB_TOKEN}@github.com/aymara/lima /src/lima
WORKDIR /src/lima
ARG CACHEBUST=1
RUN git pull
RUN echo "$(git show -s --format=%cI HEAD | sed -e 's/[^0-9]//g')-$(git rev-parse --short HEAD)" > release

RUN mkdir -p /src/lima/build
WORKDIR /src/lima/build

#ENV PERL5LIB /SVMTool-1.3.1/lib:$PERL5LIB
#ENV PATH /SVMTool-1.3.1/bin:/usr/share/apps/lima/scripts:/usr/bin:$PATH
ENV NLTK_PTB_DP_FILE /nltk_data/corpora/dependency_treebank/nltk-ptb.dp
ENV LIMA_DISABLE_FSW_TESTING true
ENV LIMA_DISABLE_CPACK_DEBIAN_PACKAGE_SHLIBDEPS true
ENV LIMA_DIST /usr
ENV LIMA_CONF /usr/share/config/lima
ENV LIMA_RESOURCES /usr/share/apps/lima/resources
ENV PATH="/opt/python/cp38-cp38/bin:${PATH}"

# Build
#
RUN cmake -G Ninja  -DQt5_DIR:PATH=/opt/qt5/5.15.2/gcc_64/lib/cmake/Qt5 -DLIMA_RESOURCES:STRING=build -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE:STRING=Release -DLIMA_VERSION_RELEASE:STRING="$(cat /src/lima/release)" -DSHORTEN_POR_CORPUS_FOR_SVMLEARN:BOOL=ON -DTF_SOURCES_PATH:PATH="/tensorflow-for-lima-1.9/" -DWITH_DEBUG_MESSAGES=ON -DWITH_ARCH=OFF -DWITH_ASAN=OFF -DWITH_GUI=ON  ..
RUN ninja && ninja install && ninja package
RUN install -D -t /usr/share/apps/lima/packages /src/lima/build/*.deb

WORKDIR /usr/share/apps/lima/tests
RUN /bin/bash -c "set -o pipefail && tva --language=eng test-eng.*.xml 2>&1 | tee tva-eng.log"
RUN /bin/bash -c "set -o pipefail && tva --language=fre test-fre.default.xml test-fre.disambiguated.xml test-fre.hyphen.xml test-fre.idiom.xml test-fre.sa.xml test-fre.se.xml test-fre.simpleword.xml test-fre.tokenizer.xml 2>&1 | tee tva-fre.log"
WORKDIR /usr/share/apps/lima/tests/xmlreader
RUN /bin/bash -c "set -o pipefail && tvx --language=eng --language=fre test-fre.xmlreader.xml 2>&1 | tee tvx-fre.log"

# install github-release to be able to deploy packages
RUN wget https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 -q && tar xjf linux-amd64-github-release.tar.bz2 && cp bin/linux/amd64/github-release /usr/bin && rm linux-amd64-github-release.tar.bz2

# install python packages necessary to use the language resources install script
RUN /bin/bash -c "if [ \"$USE_TENSORFLOW\" = true ] ; then pip3.8 install arpy requests tqdm ; fi"

## install English and French UD models
#RUN /bin/bash -c "if [ \"$USE_TENSORFLOW\" = true ] ; then lima_models.py -l english ; fi"
#RUN /bin/bash -c "if [ \"$USE_TENSORFLOW\" = true ] ; then lima_models.py -l french ; fi"

WORKDIR /
