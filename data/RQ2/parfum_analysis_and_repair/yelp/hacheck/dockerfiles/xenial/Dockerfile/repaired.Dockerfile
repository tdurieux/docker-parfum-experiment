FROM docker-dev.yelpcorp.com/xenial_yelp

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        dh-virtualenv \
        dpkg-dev \
        python3.6-dev \
        python-pip \
        python-tox \
        python-setuptools \
        debhelper \
        python-yaml \
        libyaml-dev \
        git \
        wget && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir virtualenv==15.1.0

ENV HOME /work
ENV PWD /work
WORKDIR /work
