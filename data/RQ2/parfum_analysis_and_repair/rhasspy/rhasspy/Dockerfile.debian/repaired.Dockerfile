FROM debian:buster as base
ARG TARGETARCH
ARG TARGETVARIANT

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Dir::Cache var/cache/apt/${TARGETARCH}${TARGETVARIANT};" > /etc/apt/apt.conf.d/01cache

RUN --mount=type=cache,id=apt-base,target=/var/cache/apt \
    mkdir -p /var/cache/apt/${TARGETARCH}${TARGETVARIANT}/archives/partial && \
    apt-get update && \
    apt-get install --no-install-recommends --yes \
        build-essential swig portaudio19-dev \
        libatlas-base-dev libopenblas-dev gfortran \
        liblapack-dev cython \
        curl ca-certificates \
	libffi-dev && rm -rf /var/lib/apt/lists/*;

ENV NUM_JOBS=8

ENV BUILD_DIR=/build
ENV APP_DIR=${BUILD_DIR}/rhasspy/usr/lib/rhasspy

# -----------------------------------------------------------------------------

FROM base as base-amd64

FROM base as base-armv7

FROM base as base-arm64

FROM balenalib/raspberry-pi-debian:buster-build-20210225 as base-armv6

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Dir::Cache var/cache/apt/${TARGETARCH}${TARGETVARIANT};" > /etc/apt/apt.conf.d/01cache

RUN --mount=type=cache,id=apt-build,target=/var/cache/apt \
    mkdir -p /var/cache/apt/${TARGETARCH}${TARGETVARIANT}/archives/partial && \
    install_packages \
        swig portaudio19-dev libatlas-base-dev \
        curl ca-certificates \
        gfortran

ENV NUM_JOBS=8

ENV BUILD_DIR=/build
ENV APP_DIR=${BUILD_DIR}/rhasspy/usr/lib/rhasspy

# -----------------------------------------------------------------------------
# Python 3.7
# -----------------------------------------------------------------------------

ARG TARGETARCH
ARG TARGETVARIANT
FROM base-$TARGETARCH$TARGETVARIANT as python
ARG TARGETARCH
ARG TARGETVARIANT

RUN echo "Dir::Cache var/cache/apt/${TARGETARCH}${TARGETVARIANT};" > /etc/apt/apt.conf.d/01cache

RUN --mount=type=cache,target=/var/cache/apt \
    mkdir -p /var/cache/apt/${TARGETARCH}${TARGETVARIANT}/archives/partial && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
        build-essential \
        git zlib1g-dev patchelf rsync \
        libncursesw5-dev libreadline-gplv2-dev libssl-dev \
        libgdbm-dev libc6-dev libsqlite3-dev libbz2-dev libffi-dev && rm -rf /var/lib/apt/lists/*;

ADD download/source/Python-3.7.8.tgz /build

RUN cd /build/Python-3.7.8 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j $NUM_JOBS && \
    make install DESTDIR=$APP_DIR

# -----------------------------------------------------------------------------
# Rhasspy
# -----------------------------------------------------------------------------

ARG TARGETARCH
ARG TARGETVARIANT
FROM base-$TARGETARCH$TARGETVARIANT as rhasspy

COPY --from=python ${APP_DIR}/ ${APP_DIR}/
COPY --from=python ${APP_DIR}/usr/local/include/python3.7m/ /usr/include/
ENV PYTHON=${APP_DIR}/usr/local/bin/python3

# IFDEF PYPI_PROXY
#! ENV PIP_INDEX_URL=http://${PYPI_PROXY_HOST}:${PYPI_PROXY_PORT}/simple/
#! ENV PIP_TRUSTED_HOST=${PYPI_PROXY_HOST}
# ENDIF

RUN ${PYTHON} -m pip install --upgrade pip
RUN ${PYTHON} -m pip install --upgrade wheel setuptools

ARG TARGETARCH
ARG TARGETVARIANT

# Directory of prebuilt tools
ENV DOWNLOAD_DIR=${BUILD_DIR}/download
COPY download/shared/ ${DOWNLOAD_DIR}/shared/
COPY download/${TARGETARCH}${TARGETVARIANT}/ ${DOWNLOAD_DIR}/${TARGETARCH}${TARGETVARIANT}/

# Copy Rhasspy source
COPY rhasspy/ ${APP_DIR}/rhasspy/
COPY rhasspy-server-hermes/ ${APP_DIR}/rhasspy-server-hermes/
COPY rhasspy-wake-snowboy-hermes/ ${APP_DIR}/rhasspy-wake-snowboy-hermes/
COPY rhasspy-wake-porcupine-hermes/ ${APP_DIR}/rhasspy-wake-porcupine-hermes/
COPY rhasspy-wake-precise-hermes/ ${APP_DIR}/rhasspy-wake-precise-hermes/
COPY rhasspy-profile/ ${APP_DIR}/rhasspy-profile/
COPY rhasspy-asr/ ${APP_DIR}/rhasspy-asr/
COPY rhasspy-asr-deepspeech ${APP_DIR}/rhasspy-asr-deepspeech/
COPY rhasspy-asr-deepspeech-hermes/ ${APP_DIR}/rhasspy-asr-deepspeech-hermes/
COPY rhasspy-asr-pocketsphinx/ ${APP_DIR}/rhasspy-asr-pocketsphinx/
COPY rhasspy-asr-pocketsphinx-hermes/ ${APP_DIR}/rhasspy-asr-pocketsphinx-hermes/
COPY rhasspy-asr-kaldi/ ${APP_DIR}/rhasspy-asr-kaldi/
COPY rhasspy-asr-kaldi-hermes/ ${APP_DIR}/rhasspy-asr-kaldi-hermes/
COPY rhasspy-asr-vosk-hermes/ ${APP_DIR}/rhasspy-asr-vosk-hermes/
COPY rhasspy-dialogue-hermes/ ${APP_DIR}/rhasspy-dialogue-hermes/
COPY rhasspy-fuzzywuzzy/ ${APP_DIR}/rhasspy-fuzzywuzzy/
COPY rhasspy-fuzzywuzzy-hermes/ ${APP_DIR}/rhasspy-fuzzywuzzy-hermes/
COPY rhasspy-hermes/ ${APP_DIR}/rhasspy-hermes/
COPY rhasspy-homeassistant-hermes/ ${APP_DIR}/rhasspy-homeassistant-hermes/
COPY rhasspy-microphone-cli-hermes/ ${APP_DIR}/rhasspy-microphone-cli-hermes/
COPY rhasspy-microphone-pyaudio-hermes/ ${APP_DIR}/rhasspy-microphone-pyaudio-hermes/
COPY rhasspy-nlu/ ${APP_DIR}/rhasspy-nlu/
COPY rhasspy-nlu-hermes/ ${APP_DIR}/rhasspy-nlu-hermes/
COPY rhasspy-rasa-nlu-hermes/ ${APP_DIR}/rhasspy-rasa-nlu-hermes/
COPY rhasspy-remote-http-hermes/ ${APP_DIR}/rhasspy-remote-http-hermes/
COPY rhasspy-silence/ ${APP_DIR}/rhasspy-silence/
COPY rhasspy-speakers-cli-hermes/ ${APP_DIR}/rhasspy-speakers-cli-hermes/
COPY rhasspy-supervisor/ ${APP_DIR}/rhasspy-supervisor/
COPY rhasspy-tts-cli-hermes/ ${APP_DIR}/rhasspy-tts-cli-hermes/
COPY rhasspy-tts-wavenet-hermes/ ${APP_DIR}/rhasspy-wavenet-cli-hermes/
COPY rhasspy-wake-pocketsphinx-hermes/ ${APP_DIR}/rhasspy-wake-pocketsphinx-hermes/
COPY rhasspy-wake-raven/ ${APP_DIR}/rhasspy-wake-raven/
COPY rhasspy-wake-raven-hermes/ ${APP_DIR}/rhasspy-wake-raven-hermes/
COPY rhasspy-tts-larynx-hermes/ ${APP_DIR}/rhasspy-tts-larynx-hermes/

# Autoconf
COPY m4/ ${APP_DIR}/m4/
COPY configure config.sub config.guess \
     install-sh missing aclocal.m4 \
     RHASSPY_DIRS Makefile.in setup.py.in rhasspy.sh.in rhasspy.spec.in \
     ${APP_DIR}/

RUN cd ${APP_DIR} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-in-place --disable-virtualenv --prefix=${APP_DIR}/

COPY scripts/install/ ${APP_DIR}/scripts/install/

COPY etc/shflags ${APP_DIR}/etc/
COPY etc/wav/ ${APP_DIR}/etc/wav/
COPY README.md LICENSE RHASSPY_DIRS ${APP_DIR}/

RUN --mount=type=cache,id=pip-rhasspy,target=/root/.cache/pip \
    export PIP_INSTALL_ARGS="-f ${DOWNLOAD_DIR}/shared -f ${DOWNLOAD_DIR}/${TARGETARCH}${TARGETVARIANT}" && \
    export PIP_PRE_PREINSTALL_PACKAGES='cython' && \
    export PIP_PREINSTALL_PACKAGES='numpy==1.20.1 scipy==1.5.1' && \
    export PIP_VERSION='pip<=20.2.4' && \
    if [ "${TARGETARCH}${TARGETVARIANT}" = 'amd64' ]; then \
        export PIP_PREINSTALL_PACKAGES="${PIP_PREINSTALL_PACKAGES} detect-simd~=0.2.0"; \
    fi && \
    if [ ! "${TARGETARCH}${TARGETVARIANT}" = 'armv6' ]; then \
        export PIP_VERSION='pip'; \
        export PIP_PREINSTALL_PACKAGES="${PIP_PREINSTALL_PACKAGES} scikit-learn==0.23.2"; \
    fi && \
    export POCKETSPHINX_FROM_SRC=no && \
    cd ${APP_DIR} && \
    make && \
    make install

# Clean up
RUN cd ${APP_DIR} && \
    find . -depth -type d -name '.git' -exec rm -rf {} \; && \
    find . -depth -type d -name '__pycache__' -exec rm -rf {} \; && \
    find . -type f -name 'g2p.fst.gz' -exec gunzip -f {} \;

COPY VERSION ${BUILD_DIR}/
COPY debian/control.in /

RUN export DEBIAN_ARCH="$(dpkg-architecture | grep DEB_BUILD_ARCH= | sed -e 's/[^=]\+=//')" && \
    export VERSION="$(cat ${BUILD_DIR}/VERSION)" && \
    mkdir -p ${BUILD_DIR}/rhasspy/DEBIAN && \
    sed -e s"/@VERSION@/${VERSION}/" -e "s/@DEBIAN_ARCH@/${DEBIAN_ARCH}/" < /control.in > ${BUILD_DIR}/rhasspy/DEBIAN/control

COPY debian/rhasspy ${BUILD_DIR}/rhasspy/usr/bin/

RUN cd ${BUILD_DIR} && \
    dpkg --build rhasspy

RUN cd ${BUILD_DIR} && \
    dpkg-name *.deb

# -----------------------------------------------------------------------------

FROM scratch

COPY --from=rhasspy /build/*.deb /
