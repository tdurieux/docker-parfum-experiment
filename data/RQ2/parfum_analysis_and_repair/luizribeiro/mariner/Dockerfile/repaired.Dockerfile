FROM balenalib/raspberry-pi-debian:latest

RUN apt-get update && apt-get -y upgrade && apt-get update
RUN apt-get -y --no-install-recommends install sudo dpkg-dev debhelper dh-virtualenv \
  python3 python3-venv && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install libxslt-dev libxml2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential libssl-dev libffi-dev python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN bash -c "curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -"

ENV PATH=$PATH:/root/.poetry/bin \
  DEB_BUILD_ARCH=armhf \
  DEB_BUILD_ARCH_BITS=32 \
  PIP_DEFAULT_TIMEOUT=600 \
  PIP_TIMEOUT=600 \
  PIP_RETRIES=100

RUN mkdir /build
COPY . /build/

WORKDIR /build
RUN python3 /root/.poetry/bin/poetry build

WORKDIR /build/dist
RUN dpkg-buildpackage -us -uc
