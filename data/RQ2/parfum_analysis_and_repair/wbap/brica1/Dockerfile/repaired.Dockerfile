FROM ubuntu

ADD . /workdir
WORKDIR /workdir

RUN apt update && apt install --no-install-recommends -y python3 wget && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && pip3 install --no-cache-dir numpy && \
    ls /workdir && cd /workdir/python && python3 setup.py install && rm -rf /var/lib/apt/lists/*;
