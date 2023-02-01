FROM ubuntu_i386:xenial_base

LABEL maintainer="grr-dev@googlegroups.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# Install python
RUN apt-get install --no-install-recommends -y python3 && apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

# Install other required packages
RUN apt-get install --no-install-recommends -y zip \
  wget \
  openjdk-8-jdk \
  python-pip \
  git \
  debhelper \
  libffi-dev \
  libssl-dev \
  python-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip virtualenv

CMD ["/bin/bash"]
