FROM python:3.9
LABEL maintainer="irebai@linagora.com, rbaraglia@linagora.com"

ARG KALDI_MKL

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        nano \
        bzip2 \
        unzip \
        xz-utils \
        sox \
        g++ \
        make \
        cmake \
        git \
        zlib1g-dev \
        automake \
        autoconf \
        libtool \
        pkg-config \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Build vosk-kaldi
RUN git clone -b vosk --single-branch https://github.com/alphacep/kaldi /opt/kaldi \
    && cd /opt/kaldi/tools \
    && sed -i 's:status=0:exit 0:g' extras/check_dependencies.sh \
    && sed -i 's:--enable-ngram-fsts:--enable-ngram-fsts --disable-bin:g' Makefile \
    && make -j $(nproc) openfst cub \
    && if [ "x$KALDI_MKL" != "x1" ] ; then \
          extras/install_openblas_clapack.sh; \
       else \
          extras/install_mkl.sh; \
       fi \
    && cd /opt/kaldi/src \
    && if [ "x$KALDI_MKL" != "x1" ] ; then \
          ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --mathlib=OPENBLAS_CLAPACK --shared; \
       else \
          ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --mathlib=MKL --shared; \
       fi \
    && sed -i 's:-msse -msse2:-msse -msse2:g' kaldi.mk \
    && sed -i 's: -O1 : -O3 :g' kaldi.mk \
    && make -j $(nproc) online2 lm rnnlm

# Install python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install Custom Vosk API
RUN git clone --depth 1 https://github.com/alphacep/vosk-api /opt/vosk-api && cd /opt/vosk-api/python && \
    cd /opt/vosk-api/src \
    && KALDI_MKL=$KALDI_MKL KALDI_ROOT=/opt/kaldi make -j $(nproc) \
    && cd /opt/vosk-api/python \
    && python3 ./setup.py install

WORKDIR /usr/src/app

COPY stt /usr/src/app/stt
COPY celery_app /usr/src/app/celery_app
COPY http_server /usr/src/app/http_server
COPY websocket /usr/src/app/websocket
COPY document /usr/src/app/document
COPY docker-entrypoint.sh wait-for-it.sh healthcheck.sh ./
COPY lin_to_vosk.py /usr/src/app/lin_to_vosk.py

RUN mkdir -p /var/log/supervisor/

ENV PYTHONPATH="${PYTHONPATH}:/usr/src/app/stt"

HEALTHCHECK CMD ./healthcheck.sh

ENTRYPOINT ["./docker-entrypoint.sh"]