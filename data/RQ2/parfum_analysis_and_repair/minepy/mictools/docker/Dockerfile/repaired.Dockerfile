FROM debian:10.2

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-pandas \
    git \
  && pip3 install --no-cache-dir setuptools \
  && git clone https://github.com/minepy/mictools.git /tmp/mictools/ \
  && pip3 install --no-cache-dir /tmp/mictools/ \
  && rm -rf /var/lib/apt/lists/* /tmp/mictools
