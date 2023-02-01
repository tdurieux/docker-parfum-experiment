FROM ubuntu:xenial

RUN apt-get update -qq && apt-get install -y --no-install-recommends -qq \
        build-essential \
        libncurses-dev \
        python-crypto \
        python-dev \
        python-pip \
        python-setuptools \
	curl \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/featherduster
WORKDIR /opt/featherduster
RUN curl -f -O https://bootstrap.pypa.io/pip/2.7/get-pip.py
RUN python get-pip.py
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir .

ENTRYPOINT ["python", "/opt/featherduster/featherduster/featherduster.py"]
