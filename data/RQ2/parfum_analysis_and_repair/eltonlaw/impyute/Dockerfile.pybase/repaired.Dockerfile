FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y --no-install-recommends install software-properties-common \
                       python-software-properties && \
    add-apt-repository -y ppa:deadsnakes/ppa && apt-get update && \
    apt-get autoclean && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install \
    python2.7 python2.7-dev \
    python3.5 python3.5-dev \
    python3.6 python3.6-dev \
    python3.7 python3.7-dev && \
    apt-get autoclean && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends wget && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python2.7 get-pip.py && \
    python3.5 get-pip.py && \
    python3.6 get-pip.py && \
    python3.7 get-pip.py && \
    rm get-pip.py && \
    apt-get autoclean && rm -rf /var/lib/apt/lists/*;

RUN python2.7 -m pip install --upgrade pip && \
    python3.5 -m pip install --upgrade pip && \
    python3.6 -m pip install --upgrade pip && \
    python3.7 -m pip install --upgrade pip
