FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04

# Install tools and dependencies.
RUN apt-get -y update --fix-missing
RUN apt-get install --no-install-recommends -y \
  emacs \
  git \
  wget \
  libgoogle-glog-dev && rm -rf /var/lib/apt/lists/*;

# Setup to install the latest version of cmake.
RUN apt-get install --no-install-recommends -y software-properties-common && \
    apt-get update && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
    apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

# Set the working directory.
WORKDIR /mount/sputnik
