FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        git \
        pkg-config \
        software-properties-common \
        wget && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        python2.7 \
        python2.7-dev \
        python3.4 \
        python3.4-dev \
        python3.5 \
        python3.5-dev \
        python3.6 \
        python3.6-dev \
        python3.7 \
        python3.7-dev \
        python3.8 \
        python3.8-distutils \
        python3.8-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py && \
    python3.7 /tmp/get-pip.py && \
    python3.7 -m pip install tox

WORKDIR /test/conformity

CMD ["tox"]

ADD . /test/conformity
