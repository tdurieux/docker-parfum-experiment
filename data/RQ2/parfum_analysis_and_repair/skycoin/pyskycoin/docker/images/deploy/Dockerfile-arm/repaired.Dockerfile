FROM balenalib/armv7hf-debian-golang

RUN [ "cross-build-start" ]
RUN mkdir -p /io

ADD . /io

# Install Python 2.7/3.5 runtime and development tools
RUN set -ex \
  && apt update \
  wget \
  curl \
  libpcre3-dev \
  python-pip \
  python3-pip \
  python-setuptools \
  python3-setuptools \
  python3-venv \
  python-wheel \
  python3-wheel \
  make \
  cmake \
  swig

# Install packages in PIP_PACKAGES

# Python 2.7
ENV CGO_ENABLE=1

RUN go version
RUN go env
RUN go get github.com/gz-c/gox
RUN cd /io && git submodule update --init --recursive
RUN make -C /io/gopath/src/github.com/skycoin/libskycoin dep
RUN make -C /io build-libc
RUN make -C /io build-swig
RUN sh /io/.circleci/circle_wheels_arm.sh

RUN ls /io/wheelhouse
RUN mkdir -p /io/dist
RUN cp -v /io/wheelhouse/* /io/dist
RUN pip install --no-cache-dir twine
RUN twine upload -u pyskycoin -p "prerelease_0.X" --skip-existing --repository-url https://test.pypi.org/legacy/ /io/dist/*

RUN [ "cross-build-end" ]

WORKDIR /io