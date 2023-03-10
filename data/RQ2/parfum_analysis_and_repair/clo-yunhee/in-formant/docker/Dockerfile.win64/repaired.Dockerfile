FROM msvc:16 AS build

ENV DEBIAN_FRONTEND noninteractive

USER root
RUN apt-get update -y && \
        apt-get install --no-install-recommends -y \
            wget \
            git \
            curl zip unzip tar \
            python3 python3-pip python-is-python3 && rm -rf /var/lib/apt/lists/*;
USER wine

# cmake in wine
ARG CMAKE_SERIES_VER=3.20
ARG CMAKE_VERS=$CMAKE_SERIES_VER.5
RUN umask $WINE_UMASK && \
    wget https://cmake.org/files/v$CMAKE_SERIES_VER/cmake-$CMAKE_VERS-windows-x86_64.zip -O cmake.zip && \
    unzip cmake.zip && \
    cp -R cmake-*/* $WINEPREFIX/drive_c/tools && \
    rm -rf cmake*
RUN vcwine cmake --version

# jom in wine
RUN umask $WINE_UMASK && \
    wget https://download.qt.io/official_releases/jom/jom.zip -O jom.zip && \
    unzip -d jom jom.zip && \
    mv jom/jom.exe $WINEPREFIX/drive_c/tools/bin && \
    rm -rf jom*
RUN vcwine jom /VERSION

USER root
RUN pip install --no-cache-dir aqtinstall==1.2.2
COPY aqtinstall-patch/updater.py /usr/local/lib/python3.8/dist-packages/aqt
RUN aqt install 6.1.2 windows desktop win64_msvc2019_64 -m addons.qtcharts --outputdir /opt/Qt
USER wine

RUN umask $WINE_UMASK && \
    wget https://files.portaudio.com/archives/pa_stable_v190700_20210406.tgz && \
    tar xvf pa_stable_v190700_20210406.tgz && \
    rm pa_stable_v190700_20210406.tgz && \
    mkdir portaudio/objs && \
    cd portaudio/objs && \
    vcwine cmake .. -G "NMake Makefiles JOM" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=C:\\usr && \
    vcwine jom && \
    vcwine jom install && \
    cd && rm -r portaudio

RUN umask $WINE_UMASK && \
    wget https://www.fftw.org/fftw-3.3.9.tar.gz && \
    tar xvf fftw-3.3.9.tar.gz && \
    rm fftw-3.3.9.tar.gz && \
    mkdir fftw-3.3.9/objs && \
    cd fftw-3.3.9/objs && \
    vcwine cmake .. -G "NMake Makefiles JOM" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=C:\\usr && \
    vcwine jom && \
    vcwine jom install && \
    cd && rm -r fftw-3.3.9

RUN umask $WINE_UMASK && \
    wget https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.tar.gz && \
    tar xvf eigen-3.3.9.tar.gz && \
    rm eigen-3.3.9.tar.gz && \
    mkdir eigen-3.3.9/objs && \
    cd eigen-3.3.9/objs && \
    vcwine cmake .. -G "NMake Makefiles JOM" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=C:\\usr && \
    vcwine jom install && \
    cd && rm -r eigen-3.3.9

USER root
RUN apt-get update -y && apt-get install --no-install-recommends -y ccache && rm -rf /var/lib/apt/lists/*;
USER wine
ENV CCACHE_DIR=/ccache

ENTRYPOINT []
CMD umask $WINE_UMASK && \
    cd /build && \
    export version=`cat /src/version` && \
    vcwine cmake \
        -G "NMake Makefiles JOM" \
        -DCUR_VERSION=$version \
        -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
        -DCMAKE_PREFIX_PATH="Z:\\opt\\Qt\\6.1.2\\msvc2019_64;C:\\usr" \
        -DENABLE_TORCH=$ENABLE_TORCH \
        /src && \
    vcwine jom && \
    DIST_SUFFIX=win64-x64 \
    /src/docker/deploy-windows.sh


