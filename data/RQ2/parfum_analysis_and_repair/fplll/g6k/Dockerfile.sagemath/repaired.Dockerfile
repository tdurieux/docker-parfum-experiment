## -*- docker-image-name: "fplll/sagemath-g6k" -*-

FROM sagemath/sagemath:latest
MAINTAINER Martin Albrecht <fplll-devel@googlegroups.com>

ARG JOBS=2
ARG FPLLL_BRANCH=master
ARG FPYLLL_BRANCH=master
ARG G6K_BRANCH=master
ARG CXXFLAGS="-O2 -march=x86-64"
ARG CFLAGS="-O2 -march=x86-64"
SHELL ["/home/sage/sage/src/bin/sage", "-sh", "-c"]

RUN sudo apt update && \
    sudo apt install --no-install-recommends -y git pkg-config libtool libqd-dev build-essential autoconf && rm -rf /var/lib/apt/lists/*;
RUN git clone --branch $FPLLL_BRANCH https://github.com/fplll/fplll && \
    cd fplll && \
    autoreconf -i && \
    CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$SAGE_LOCAL --disable-static && \
    make -j $JOBS install && \
    cd ..
RUN git clone --branch $FPYLLL_BRANCH https://github.com/fplll/fpylll && \
    cd fpylll && \
    pip3 install --no-cache-dir Cython && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir -r suggestions.txt && \
    CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS python3 setup.py build -j $JOBS && \
    rm -rf $SAGE_VENV/lib/python*/site-packages/fpylll && \
    python3 setup.py -q install && \
    cd ..
RUN git clone --branch $G6K_BRANCH https://github.com/fplll/g6k && \
    cd g6k && \
    pip3 install --no-cache-dir -r requirements.txt && \
    CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS python3 setup.py build -j $JOBS && \
    python3 setup.py -q install && \
    cd ..
RUN rm -rf fplll fpylll g6k

