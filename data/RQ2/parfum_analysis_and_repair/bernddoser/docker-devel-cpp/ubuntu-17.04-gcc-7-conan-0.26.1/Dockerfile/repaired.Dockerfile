FROM bernddoser/docker-devel-cpp:ubuntu-17.04-gcc-7

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    python-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -I conan==0.26.1

RUN mkdir -p .conan \
 && chmod 777 .conan
