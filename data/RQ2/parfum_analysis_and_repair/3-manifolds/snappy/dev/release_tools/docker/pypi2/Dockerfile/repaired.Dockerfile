FROM python:2.7-stretch
MAINTAINER Nathan Dunfield <nathan@dunfield.info>

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-tk \
    libglu1-mesa-dev && rm -rf /var/lib/apt/lists/*;

RUN python2 -m pip install -U pip setuptools wheel ipython cython
RUN python2 -m pip install cypari snappy_manifolds
RUN python2 -m pip install --no-binary :all: snappy
RUN python2 -m snappy.test

WORKDIR /
CMD ["/bin/bash"]
