FROM debian:stretch

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

# Install Python 2.7
RUN apt-get update && apt-get install --no-install-recommends -y python2.7 python-all-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python2.7

# Install python dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
  python-setuptools \
  python-pip && rm -rf /var/lib/apt/lists/*;

# Add Debian 'testing' repository
RUN echo 'deb http://ftp.de.debian.org/debian testing main' >> /etc/apt/sources.list
RUN echo 'APT::Default-Release "stable";' | tee -a /etc/apt/apt.conf.d/00local

# Install Python3
RUN apt-get update && apt-get -t testing --no-install-recommends install -y \
  python3.5 \
  python3.6 \
  python3.7 \
  python3-all-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.5
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.6
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.7
