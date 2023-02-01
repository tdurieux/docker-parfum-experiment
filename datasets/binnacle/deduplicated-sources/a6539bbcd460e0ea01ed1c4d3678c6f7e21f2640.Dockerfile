FROM debian

ENV BR_VERSION 2015.02

RUN echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" \
    | debconf-set-selections \
  && echo "locales locales/default_environment_locale select en_US.UTF-8" \
    | debconf-set-selections \
  && apt-get -q update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
    wget \
    build-essential \
    libncurses-dev \
    rsync \
    unzip \
    bc \
    gnupg \
    python \
    libc6-i386 \
    cpio \
    locales \
    git-core

RUN wget -qO- http://buildroot.uclibc.org/downloads/buildroot-$BR_VERSION.tar.gz \
  | tar xz && mv buildroot-$BR_VERSION /tmp/buildroot

WORKDIR /tmp/buildroot
