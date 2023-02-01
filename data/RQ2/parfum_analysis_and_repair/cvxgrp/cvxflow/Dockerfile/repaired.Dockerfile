FROM ubuntu:16.04

# Debian packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf \
  autotools-dev \
  build-essential \
  bzip2 \
  cmake \
  curl \
  g++ \
  gfortran \
  git \
  libc-dev \
  libopenblas-dev \
  libquadmath0 \
  libtool \
  make \
  parallel \
  pkg-config \
  unzip \
  timelimit \
  wget \
  zip && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Python 2.7
RUN apt-get install --no-install-recommends -y \
    python-dev \
    python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip2 install --no-cache-dir -U numpy scipy wheel
RUN pip2 install --no-cache-dir -U cvxpy
RUN pip2 install --no-cache-dir -U tensorflow

# Python 3.4
RUN apt-get install --no-install-recommends -y \
    python3-dev \
    python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U numpy scipy wheel
RUN pip3 install --no-cache-dir -U cvxpy
RUN pip3 install --no-cache-dir -U tensorflow

CMD ["bash"]
