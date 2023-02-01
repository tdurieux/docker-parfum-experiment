FROM python:3.7-stretch
MAINTAINER Nathan Dunfield <nathan@dunfield.info>

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-tk \
    libglu1-mesa-dev && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install -U pip setuptools wheel ipython
RUN python3 -m pip install cypari snappy_manifolds
RUN python3 -m pip install --no-binary :all: snappy
RUN python3 -m snappy.test

WORKDIR /
CMD ["/bin/bash"]
