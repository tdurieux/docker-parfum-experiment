ARG VERSION
FROM ubuntu:${VERSION}

COPY update_sources.sh /
RUN /update_sources.sh

RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture arm64
RUN apt-get update && apt-get install --no-install-recommends -y \
  python \
  python-setuptools \
  python-wheel \
  python-numpy \
  libpython-dev \
  libpython-dev:armhf \
  libpython-dev:arm64 \
  python3 \
  python3-setuptools \
  python3-wheel \
  python3-numpy \
  libpython3-dev \
  libpython3-dev:armhf \
  libpython3-dev:arm64 \
  crossbuild-essential-armhf \
  crossbuild-essential-arm64 \
  zlib1g-dev \
  zlib1g-dev:armhf \
  zlib1g-dev:arm64 \
  swig \
  curl \
  git && rm -rf /var/lib/apt/lists/*;
