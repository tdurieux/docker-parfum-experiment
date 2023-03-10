FROM smizy/python:3.5-alpine

RUN set -x \
    && apk update \
    && apk --no-cache add \
        freetype \
        openblas \
        py3-zmq \
        tini \
    && pip3 install --no-cache-dir --upgrade pip \
    ## numpy
    && ln -s /usr/include/locale.h /usr/include/xlocale.h \
    && apk --no-cache add --virtual .builddeps \
        build-base \
        freetype-dev \
        gfortran \
        openblas-dev \
        python3-dev \
    && pip3 install --no-cache-dir numpy \
    ## scipy
    && pip3 install --no-cache-dir scipy \
    ## pnadas
    && apk --no-cache add  \
        py3-dateutil \
        py3-tz \
    && pip3 install --no-cache-dir pandas \
    ## scikit-learn
    && pip3 install --no-cache-dir scikit-learn \
    ## clean
    && apk del .builddeps \
    && find /usr/lib/python3.5 -name __pycache__ | xargs rm -r \
    && rm -rf \
        /root/.[acpw]* \
        ipaexg00301* \

WORKDIR /code

ADD pytrain.py /code/pytrain.py
