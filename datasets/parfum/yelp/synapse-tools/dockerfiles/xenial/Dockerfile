FROM docker-dev.yelpcorp.com/xenial_pkgbuild

ARG PIP_INDEX_URL=https://pypi.yelpcorp.com/simple
ENV PIP_INDEX_URL=$PIP_INDEX_URL

# Need Python 3.7
RUN apt-get update > /dev/null && \
    apt-get install -y --no-install-recommends software-properties-common 

RUN apt-get update && apt-get -y install \
    debhelper \
    dpkg-dev \
    libyaml-dev \
    libcurl4-openssl-dev \
    python3.7-dev \
    python-setuptools \
    libffi-dev \
    libssl-dev \
    build-essential \
    protobuf-compiler \
    gdebi-core \
    wget

RUN cd /tmp && \
    wget http://mirrors.kernel.org/ubuntu/pool/universe/d/dh-virtualenv/dh-virtualenv_1.0-1_all.deb && \
    gdebi -n dh-virtualenv*.deb && \
    rm dh-virtualenv_*.deb

WORKDIR /work
