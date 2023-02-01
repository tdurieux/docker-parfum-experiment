from ubuntu:trusty

RUN apt-get update && apt-get install --no-install-recommends -y vim python-dev python3-dev python-pip python3-pip gcc clang && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install --no-cache-dir cython && pip3 install --no-cache-dir cython
VOLUME /src
