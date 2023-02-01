FROM ioft/i386-ubuntu:xenial
RUN apt-get update && \
    apt-get -y --no-install-recommends install python python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pyyaml PyCrypto
RUN apt-get -y --no-install-recommends install python-matplotlib && rm -rf /var/lib/apt/lists/*;
