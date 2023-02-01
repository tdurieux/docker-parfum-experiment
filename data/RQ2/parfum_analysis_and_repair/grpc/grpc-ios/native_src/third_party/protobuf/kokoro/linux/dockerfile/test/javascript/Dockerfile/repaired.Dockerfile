FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;

# Install dependencies.  We start with the basic ones require to build protoc
# and the C++ build
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y --force-yes \
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


##################
# Javascript dependencies.
# We need to set these environment variables so that the Docker build does not
# have to ask for this information while it is installing the tzdata package.
RUN DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles" \
  apt-get --no-install-recommends \
  install -y \

  npm \
  default-jre \
  python && rm -rf /var/lib/apt/lists/*;
