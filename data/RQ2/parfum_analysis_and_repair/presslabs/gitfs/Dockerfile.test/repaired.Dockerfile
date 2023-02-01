FROM ubuntu:18.04

ARG PYTHON=3.7

RUN apt-get update && \
    apt-get install --no-install-recommends -qy build-essential software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    add-apt-repository ppa:presslabs/gitfs && \
    apt-get update && \
    apt-get install --no-install-recommends -qy python-pip python-virtualenv python-dev libfuse-dev fuse git libffi-dev python${PYTHON}-dev libgit2-dev python3-pip && rm -rf /var/lib/apt/lists/*;

RUN if [ "$PYTHON" = "3.8" ] ; then \
 apt-get install --no-install-recommends -qy python3.8-distutils; rm -rf /var/lib/apt/lists/*; fi

COPY test_requirements.txt requirements.txt /
RUN if [ "$PYTHON" = "2.7" ] ; then \
 pip install --no-cache-dir -r /test_requirements.txt; else pip3 install --no-cache-dir -r /test_requirements.txt; fi
