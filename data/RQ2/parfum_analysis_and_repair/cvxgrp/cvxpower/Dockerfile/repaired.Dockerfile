FROM debian:latest

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

# Python 2
RUN apt-get install --no-install-recommends -y \
    python-dev \
    python-pip && rm -rf /var/lib/apt/lists/*;
RUN python2 -m pip install -U pip
RUN python2 -m pip install -U numpy scipy
RUN python2 -m pip install -U cvxpy

# Python 3
RUN apt-get install --no-install-recommends -y \
    python3-dev \
    python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install -U pip
RUN python3 -m pip install -U numpy scipy
RUN python3 -m pip install -U cvxpy

CMD ["bash"]
