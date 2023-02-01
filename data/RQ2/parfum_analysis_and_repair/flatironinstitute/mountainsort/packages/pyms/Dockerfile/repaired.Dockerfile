FROM ubuntu:16.04

MAINTAINER Jeremy Magland

# Python3
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python3 python3-pip && rm -rf /var/lib/apt/lists/*;

# Python3 packages
RUN pip3 install --no-cache-dir --upgrade numpy
RUN pip3 install --no-cache-dir --upgrade pybind11 cppimport
RUN pip3 install --no-cache-dir --upgrade scipy
RUN pip3 install --no-cache-dir --upgrade sklearn
RUN pip3 install --no-cache-dir --upgrade numpydoc

RUN apt-get update && apt-get install --no-install-recommends -y fftw3-dev && rm -rf /var/lib/apt/lists/*;

ADD . /package

# Build
WORKDIR /package
RUN basic/basic.mp spec > basic.spec
RUN drift/drift.mp spec > drift.spec
RUN synthesis/synthesis.mp spec > synthesis.spec
