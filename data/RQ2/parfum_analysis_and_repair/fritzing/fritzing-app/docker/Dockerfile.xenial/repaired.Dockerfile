FROM conanio/gcc5
# Dockerfile for ^ https://github.com/conan-io/conan-docker-tools/blob/master/gcc_5/Dockerfile

ENV BOOST_ROOT /usr/local

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    libjpeg-dev \
    libncurses5-dev \
    libpng-dev \
    libqt5serialport5-dev \
    libqt5svg5-dev \
    libssl-dev \
    libudev-dev \
    libz-dev \
    python-dev \
    qt5-default \
    qttools5-dev-tools \
    xvfb && rm -rf /var/lib/apt/lists/*;

# No SHA verification for now. Will be automated by Conan in the future.
RUN set -xe \
    && wget -q -O - https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.bz2 | tar xj

RUN set -xe \
    && wget -q -O - https://github.com/libgit2/libgit2/archive/v0.28.1.tar.gz | tar xz \
    && mv libgit2-0.28.1 libgit2 \
    && mkdir libgit2/build \
    && cd libgit2/build \
    && cmake -D BUILD_SHARED_LIBS=OFF .. \
    && cmake --build . -- -j4 \
    && cd ../../


USER conan
