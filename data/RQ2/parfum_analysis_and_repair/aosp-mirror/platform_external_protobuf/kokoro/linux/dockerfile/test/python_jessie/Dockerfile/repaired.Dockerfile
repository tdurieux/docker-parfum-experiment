FROM debian:jessie

# Install dependencies.  We start with the basic ones require to build protoc
# and the C++ build
RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf \
  autotools-dev \
  build-essential \
  bzip2 \
  ccache \
  curl \
  gcc \
  git \
  libc6 \
  libc6-dbg \
  libc6-dev \
  libgtest-dev \
  libtool \
  make \
  parallel \
  time \
  wget \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install python dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
  python-setuptools \
  python-all-dev \
  python3-all-dev \
  python-pip && rm -rf /var/lib/apt/lists/*;

# Install Python packages from PyPI
RUN pip install --no-cache-dir --upgrade pip==10.0.1
RUN pip install --no-cache-dir virtualenv
RUN pip install --no-cache-dir six==1.10.0 twisted==17.5.0

# Install pip and virtualenv for Python 3.4
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.4
RUN python3.4 -m pip install virtualenv
