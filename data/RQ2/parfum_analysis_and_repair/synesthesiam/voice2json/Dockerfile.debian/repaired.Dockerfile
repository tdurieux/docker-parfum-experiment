FROM debian:buster as base

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,id=apt-base,target=/var/cache/apt \
    apt-get update && \
    apt-get install --no-install-recommends --yes \
        build-essential \
        python3 python3-dev python3-pip python3-setuptools python3-venv \
        swig portaudio19-dev libatlas-base-dev \
        fakeroot curl && rm -rf /var/lib/apt/lists/*;

ENV NUM_JOBS=8

ENV BUILD_DIR=/build
ENV APP_DIR=${BUILD_DIR}/voice2json/usr/lib/voice2json

# -----------------------------------------------------------------------------
# Python 3.7
# -----------------------------------------------------------------------------

FROM base as python

RUN --mount=type=cache,id=apt-python,target=/var/cache/apt \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
        git zlib1g-dev patchelf rsync \
        libncursesw5-dev libreadline-gplv2-dev libssl-dev \
        libgdbm-dev libc6-dev libsqlite3-dev libbz2-dev libffi-dev && rm -rf /var/lib/apt/lists/*;

ADD download/source/Python-3.7.10.tar.xz /build

RUN cd /build/Python-3.7.10 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j ${NUM_JOBS} && \
    make install DESTDIR=${APP_DIR}

# -----------------------------------------------------------------------------

FROM base as build

COPY --from=python ${APP_DIR}/ ${APP_DIR}/
COPY --from=python ${APP_DIR}/usr/local/include/python3.7m/ /usr/include/
ENV PYTHON=${APP_DIR}/usr/local/bin/python3

# Directory of prebuilt tools
ARG TARGETARCH
ARG TARGETVARIANT
COPY download/shared/ ${BUILD_DIR}/download/
COPY download/${TARGETARCH}${TARGETVARIANT}/ ${BUILD_DIR}/download/

COPY m4/ ${BUILD_DIR}/m4/
COPY configure config.sub config.guess \
     install-sh missing aclocal.m4 \
     VERSION Makefile.in setup.py.in voice2json.sh.in voice2json.spec.in \
     requirements.txt \
     ${BUILD_DIR}/

RUN cd ${BUILD_DIR} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${APP_DIR} --disable-virtualenv

COPY scripts/install/ ${BUILD_DIR}/scripts/install/

COPY etc/profile.defaults.yml ${BUILD_DIR}/etc/
COPY etc/profiles/ ${BUILD_DIR}/etc/profiles/
COPY etc/precise/ ${BUILD_DIR}/etc/precise/
COPY site/ ${BUILD_DIR}/site/

COPY README.md LICENSE ${BUILD_DIR}/
COPY voice2json/ ${BUILD_DIR}/voice2json/

RUN --mount=type=cache,id=pip-build,target=/root/.cache/pip \
    cd ${BUILD_DIR} && \
    make && \
    make install

COPY __main__.py ${BUILD_DIR}/

COPY debian/control.in /

# Write shared variables to /.vars
RUN export DEBIAN_ARCH="$(dpkg-architecture | grep DEB_BUILD_ARCH= | sed -e 's/[^=]\\+=//')" && \
    export VERSION="$(cat ${BUILD_DIR}/VERSION)" && \
    mkdir -p ${BUILD_DIR}/voice2json/DEBIAN && \
    sed -e s"/@VERSION@/${VERSION}/" -e "s/@DEBIAN_ARCH@/${DEBIAN_ARCH}/" < /control.in > ${BUILD_DIR}/voice2json/DEBIAN/control

COPY VERSION ${BUILD_DIR}/voice2json/usr/lib/voice2json/
COPY debian/voice2json ${BUILD_DIR}/voice2json/usr/bin/

# Fix precise-engine link
RUN cd ${APP_DIR}/bin && \
    ln -sf ../lib/precise/precise-engine

RUN cd ${BUILD_DIR} && \
    dpkg --build voice2json

RUN cd ${BUILD_DIR} && \
    dpkg-name *.deb

# -----------------------------------------------------------------------------

FROM scratch

COPY --from=build /build/*.deb /
