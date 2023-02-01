# An image with the necessary binaries and libraries to develop pex.
FROM ubuntu:20.04

RUN apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install --yes \

  build-essential \


  python2.7-dev \
  python3.8-dev \
  python3.8-venv \
  python3.9-dev \
  python3.9-venv \
  pypy-dev \
  pypy3-dev \
  python-pip-whl \

  python-dev-is-python3 \

  git \
  curl \
  zlib1g-dev \
  libssl-dev \
  libreadline-dev \
  libbz2-dev \
  libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

# Setup a modern tox.
RUN python -mvenv /tox && \
  /tox/bin/pip install -U pip && \
  /tox/bin/pip install tox

ENV PATH=/tox/bin:${PATH}
