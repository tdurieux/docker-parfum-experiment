FROM __BASEIMAGE_ARCH__/alpine:3.8

__CROSS_COPY qemu-__QEMU_ARCH__-static /usr/bin/

COPY . /app

WORKDIR /app

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
  g++ \
  git \
  gcc \
  libxml2-dev \
  libxslt-dev \
  openssl-dev \
  python3-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
  openssl \
  py3-lxml \
  py3-pip \
  python3 && \
  python3 -m ensurepip && \
  rm -r /usr/lib/python*/ensurepip && \
  pip3 install --no-cache-dir --upgrade pip setuptools && \
  if [ ! -e /usr/bin/pip ]; then \
   ln -s pip3 /usr/bin/pip ; \
  fi && \
  rm -r /root/.cache && \
  if [ ! -e /usr/bin/python ]; then \
   ln -s python3 /usr/bin/python ; \
  fi && \
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
  pip && \
 pip install --no-cache-dir -r requirements.txt && \
 echo "**** clean up ****" && \
 apk del --purge \
  build-dependencies && \
 rm -rf \
  /root/.cache \
  /tmp/* \
  /var/cache/apk/*

CMD ["python", "bot/main.py"]

