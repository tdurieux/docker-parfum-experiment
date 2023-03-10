FROM ubuntu:18.04
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
       python3 \
       python3-setuptools \
       python3-pip \
       python3-pandas \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip

COPY . /synapsePythonClient
WORKDIR /synapsePythonClient
RUN python3 setup.py install

