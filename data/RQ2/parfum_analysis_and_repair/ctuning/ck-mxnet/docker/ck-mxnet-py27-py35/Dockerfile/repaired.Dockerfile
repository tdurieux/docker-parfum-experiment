FROM ubuntu:16.04
MAINTAINER Grigori Fursin <Grigori.Fursin@cTuning.org>

# Install standard packages.
RUN apt-get update && apt-get install --no-install-recommends -y \
    python \
    python-pip \
    python3 \
    python3-pip \
    git zip bzip2 sudo wget \
    libglib2.0-0 libsm6 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir ck
RUN ck  version

# Install ck-mxnet
RUN ck pull repo:ck-mxnet

# Install model
RUN ck install package --tags=mxnetmodel,resnet-152

#
CMD bash
