FROM ubuntu:bionic

ARG PIP_INDEX_URL=https://pypi.yelpcorp.com/simple
ENV PIP_INDEX_URL=$PIP_INDEX_URL

RUN apt-get update && apt-get -y --no-install-recommends install \
    debhelper \
    dh-virtualenv \
    dpkg-dev \
    libyaml-dev \
    libcurl4-openssl-dev \
    python3.7-dev \
    python-tox \
    python3-pip \
    python-setuptools \
    libffi-dev \
    libssl-dev \
    build-essential \
    protobuf-compiler \
    gdebi-core \
    wget && rm -rf /var/lib/apt/lists/*;

# When using internal pypi on older virtualenvs they
# fail looking for pkg-resources?!
RUN pip3 install --no-cache-dir virtualenv==16.0.0

WORKDIR /work
