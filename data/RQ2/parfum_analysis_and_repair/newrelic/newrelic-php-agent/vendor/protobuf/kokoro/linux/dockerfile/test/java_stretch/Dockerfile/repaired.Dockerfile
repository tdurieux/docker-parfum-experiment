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

# Java dependencies
RUN apt-get install --no-install-recommends -y \
  # -- For all Java builds -- \
  maven \
  # -- For java_linkage_monitor \
  openjdk-8-jdk \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;
