# Based on https://github.com/eht16/python3-docker
FROM balenalib/raspberrypi3-debian:buster-build as build
RUN [ "cross-build-start" ]

ARG PYTHON_VERSION=3.8.6
ARG PYTHON_PIP_VERSION=20.2.4
ARG MAKEFLAGS="-j2"

ENV GPG_KEY E3FF2839C048B25C084DEBE9B26995E310250568
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_URL=https://bootstrap.pypa.io/get-pip.py
ENV PIP_SHA256=b3153ec0cf7b7bbf9556932aa37e4981c35dc2a2c501d70d91d2795aa532be79

RUN \
  apt-get -yqq update && apt-get install -yq --no-install-recommends \
  ca-certificates \
  dirmngr \
  dpkg-dev \
  gcc \
  gnupg \
  libbz2-dev \
  libc6-dev \
  libexpat1-dev \
  libffi-dev \
  liblzma-dev \
  libsqlite3-dev \
  libssl-dev \
  make \
  netbase \
  uuid-dev \
  wget \
  xz-utils \
  zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN \
  wget --no-verbose --output-document=python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
  && wget --no-verbose --output-document=python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
  && gpg --batch --verify python.tar.xz.asc python.tar.xz \
  && { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \
  && rm -rf "$GNUPGHOME" python.tar.xz.asc \
  && mkdir -p /usr/src/python \
  && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
  && rm python.tar.xz && rm -rf /usr/src/python

RUN \
  cd /usr/src/python \
  && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --help \
  && ./configure \
  --build="$gnuArch" \
  --prefix="/python" \
  --enable-loadable-sqlite-extensions \
  --enable-optimizations \
  --enable-ipv6 \
  --disable-shared \
  --with-system-expat \
  --without-ensurepip \
  && make \
  && make install

RUN \
  strip /python/bin/python3.8 && \
  strip --strip-unneeded /python/lib/python3.8/config-3.8-arm-linux-gnueabihf/libpython3.8.a && \
  strip --strip-unneeded /python/lib/python3.8/lib-dynload/*.so && \
  rm /python/lib/libpython3.8.a && \
  ln /python/lib/python3.8/config-3.8-arm-linux-gnueabihf/libpython3.8.a /python/lib/libpython3.8.a

# install pip
RUN \
  wget --no-verbose --output-document=get-pip.py "$PIP_URL"; \
  \
  /python/bin/python3 get-pip.py \
  --disable-pip-version-check \
  --no-cache-dir \
  "pip==$PYTHON_PIP_VERSION" "wheel"

# cleanup
RUN \
  find /python/lib -type d -a \( \
  -name test -o \
  -name tests -o \
  -name idlelib -o \
  -name turtledemo -o \
  -name pydoc_data -o \
  -name tkinter \) -exec rm -rf {} +

RUN [ "cross-build-end" ]

FROM balenalib/raspberrypi3-debian:buster-build

RUN \
  ln -s /python/bin/python3-config /usr/local/bin/python-config && \
  ln -s /python/bin/python3 /usr/local/bin/python3 && \
  ln -s /python/bin/pip3 /usr/local/bin/pip3 && \
  \
  apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  libexpat1 \
  libsqlite3-0 \
  libssl1.1 \
  # TODO ADD THESE
  # gfortran \
  # libopenblas-dev \
  # liblapack-dev \
  \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /python /python

CMD ["python3"]
