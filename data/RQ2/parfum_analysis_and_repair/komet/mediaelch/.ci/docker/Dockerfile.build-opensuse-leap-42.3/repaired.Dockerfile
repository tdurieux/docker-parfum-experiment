FROM opensuse/leap:42.3

# Steps:
#  - update system
#  - install development tools
#  - install compilers and required libraries
#  - install ffmpeg which is a runtime dependency

RUN zypper --non-interactive refresh && \
    zypper --non-interactive update && \
    zypper --non-interactive install --type pattern devel_basis && \
    zypper --non-interactive install gcc7 gcc7-c++ git \
        libmediainfo0 libmediainfo-devel libpulse-devel \
        ffmpeg

RUN zypper --non-interactive install \
        libqt5-qtbase \
        libqt5-qtdeclarative-devel \
        libqt5-qtdeclarative-tools \
        libqt5-qtmultimedia-devel \
        libqt5-qttools \
        libqt5-qttools-devel \
        libqt5-qtsvg-devel \
        libQt5Concurrent5 \
        libQt5Concurrent-devel \
        libQt5OpenGL5 \
        libQt5OpenGL-devel \
        libQt5Sql-devel

RUN update-alternatives --install /usr/bin/gcc  gcc  /usr/bin/gcc-7  10
RUN update-alternatives --install /usr/bin/g++  g++  /usr/bin/g++-7  10
RUN update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-7 10