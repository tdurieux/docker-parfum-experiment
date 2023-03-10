ARG BASE_IMAGE=quay.io/pypa/manylinux2014_x86_64
FROM $BASE_IMAGE

ARG REDIS5_VERSION=5.0.9
ARG REDIS6_VERSION=6.0.8
RUN cd /tmp && mkdir redis5 && curl -f -s https://download.redis.io/releases/redis-${REDIS5_VERSION}.tar.gz | tar -xvzo -C redis5 --strip-components=1 > /dev/null 2>&1 && cd redis5 && make > /dev/null 2>&1
RUN cd /tmp && mkdir redis6 && curl -f -s https://download.redis.io/releases/redis-${REDIS6_VERSION}.tar.gz | tar -xvzo -C redis6 --strip-components=1 > /dev/null 2>&1 && cd redis6 && make > /dev/null 2>&1

ARG PYPY3_VERSION=7.3.2
RUN cd /opt/python && mkdir pypy3 && curl -f -s -L https://downloads.python.org/pypy/pypy3.6-v${PYPY3_VERSION}-linux64.tar.bz2 | tar -xvjo -C pypy3 --strip-components=1 > /dev/null 2>&1

#WORKDIR /opt
#ADD https://api.github.com/repos/tzickel/justredis/git/refs/heads/master version.json
#RUN git clone https://github.com/tzickel/justredis

WORKDIR /opt/justredis

ADD . .

RUN /opt/python/cp38-cp38/bin/pip install -U tox pip setuptools wheel > /dev/null 2>&1
RUN REDIS_6_PATH=/tmp/redis6/src REDIS_5_PATH=/tmp/redis5/src PATH=$PATH:/opt/python/cp39-cp39/bin:/opt/python/cp38-cp38/bin:/opt/python/cp37-cp37m/bin:/opt/python/cp36-cp36m/bin:/opt/python/cp35-cp35m/bin:/opt/python/pypy3/bin /opt/python/cp38-cp38/bin/tox
RUN /opt/python/cp38-cp38/bin/python setup.py bdist_wheel