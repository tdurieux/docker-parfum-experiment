FROM ubuntu:16.04
MAINTAINER Grigori Fursin <Grigori.Fursin@cTuning.org>

# Install standard packages.
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-all \
    python-pip \
    git zip bzip2 sudo wget \
    libglib2.0-0 libsm6 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir ck
RUN ck  version

# Install ck-mxnet
RUN ck pull repo:ck-mxnet

#
CMD bash
