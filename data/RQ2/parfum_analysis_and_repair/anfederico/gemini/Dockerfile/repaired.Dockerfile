FROM python:3.6-alpine

MAINTAINER Anthony Federico <https://github.com/anfederico>

RUN apk update
RUN apk add --no-cache musl-dev wget git build-base

# Python packages
RUN pip install --no-cache-dir cython
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN pip install --no-cache-dir numpy

# TA-Lib
RUN wget https://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
  tar -xvzf ta-lib-0.4.0-src.tar.gz && \
  cd ta-lib/ && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && \
  make && \
  make install && rm ta-lib-0.4.0-src.tar.gz
RUN git clone https://github.com/mrjbq7/ta-lib.git /ta-lib-py && cd ta-lib-py && python setup.py install

RUN apk del musl-dev wget git build-base