FROM ubuntu:18.04

RUN apt-get update -y -q && apt-get install --no-install-recommends -y \
      autoconf \
      binutils \
      binutils-doc \
      bison \
      build-essential \
      curl \
      devscripts \
      dpkg-dev \
      fakeroot \
      flex \
      gettext \
      gnupg \
      ncurses-dev \
      ncurses-dev \
      wget \
      zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://omnitruck.chef.io/install.sh | bash -s -- -P omnibus-toolchain
