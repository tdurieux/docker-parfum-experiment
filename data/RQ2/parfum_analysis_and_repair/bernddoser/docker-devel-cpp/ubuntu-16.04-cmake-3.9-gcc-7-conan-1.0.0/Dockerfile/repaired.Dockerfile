FROM bernddoser/docker-devel-cpp:ubuntu-16.04-cmake-3.9-gcc-7

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    python-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -I setuptools \
 && pip install --no-cache-dir -I conan==1.0.0
