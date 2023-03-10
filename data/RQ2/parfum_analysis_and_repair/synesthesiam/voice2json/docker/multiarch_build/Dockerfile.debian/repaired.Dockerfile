FROM ubuntu:eoan as base

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        build-essential \
        python3 python3-dev python3-pip python3-setuptools python3-venv \
        swig portaudio19-dev libatlas-base-dev \
        fakeroot && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pyinstaller

FROM base as base-amd64

FROM base as base-armv7

FROM base as base-arm64

ARG TARGETARCH
ARG TARGETVARIANT
FROM base-$TARGETARCH$TARGETVARIANT

ENV APP_DIR=/usr/lib/voice2json
ENV BUILD_DIR=/build

COPY VERSION ${BUILD_DIR}/

RUN export DEBIAN_ARCH="$(dpkg-architecture | grep DEB_BUILD_ARCH= | sed -e 's/[^=]\+=//')" && \
    export VERSION="$(cat ${BUILD_DIR}/VERSION)" && \
    export PACKAGE_NAME=voice2json_${VERSION}_${DEBIAN_ARCH} && \
    export DEBIAN_DIR=${BUILD_DIR}/${PACKAGE_NAME}

RUN mkdir -p ${DEBIAN_DIR}/DEBIAN
COPY debian/control.in /

RUN sed -e "s/@DEBIAN_ARCH@/${DEBIAN_ARCH}/" < /control.in > ${DEBIAN_DIR}/DEBIAN/control

# Directory of prebuilt tools
COPY download/ ${BUILD_DIR}/download/

# Cache pip downloads
COPY requirements.txt ${BUILD_DIR}/
RUN pip3 download --dest /pipcache pip wheel setuptools
RUN pip3 download --dest /pipcache -r ${BUILD_DIR}/requirements.txt

COPY m4/ ${BUILD_DIR}/m4/
COPY configure config.sub config.guess \
     install-sh missing aclocal.m4 \
     Makefile.in setup.py.in voice2json.sh.in ${BUILD_DIR}/

RUN cd ${BUILD_DIR} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${APP_DIR}

COPY scripts/install/ ${BUILD_DIR}/scripts/install/

COPY etc/profile.defaults.yml ${BUILD_DIR}/etc/
COPY etc/precise/ ${BUILD_DIR}/etc/precise/
COPY site/ ${BUILD_DIR}/site/

COPY README.md LICENSE ${BUILD_DIR}/
COPY voice2json/ ${BUILD_DIR}/voice2json/

RUN export VIRTUALENV_FLAGS='--copies' && \
    export PIP_INSTALL_ARGS='-f /pipcache --no-index' && \
    cd ${BUILD_DIR} && \
    make && \
    make install && \
    mkdir -p ${DEBIAN_DIR}${APP_DIR} && \
    mv ${APP_DIR}/* ${DEBIAN_DIR}${APP_DIR}/

RUN mkdir -p ${DEBIAN_DIR}/usr/bin/ && \
    cp ${DEBIAN_DIR}${APP_DIR}/bin/voice2json ${DEBIAN_DIR}/usr/bin/

# Copy libpython to virtual env
RUN cp -a /usr/local/lib/libpython3.7*.so* ${DEBIAN_DIR}${APP_DIR}/lib/

# Strip binaries and shared libraries
RUN (find ${APP_VENV} -type f \( -name '*.so*' -or -executable \) -print0 | xargs -0 strip --strip-unneeded -- 2>/dev/null) || true

RUN cd ${BUILD_DIR} && \
    fakeroot dpkg --build ${PACKAGE_NAME}