FROM ubuntu:xenial
MAINTAINER jaiverma <jai2.verma@outlook.com>

# add afl user
RUN useradd afl \
    && echo "afl:afl" | chpasswd

# install aflsmart dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install --no-install-recommends build-essential -y \
    && apt-get install --no-install-recommends automake -y \
    && apt-get install --no-install-recommends libtool -y \
    && apt-get install --no-install-recommends libc6-dev-i386 -y \
    && apt-get install --no-install-recommends python-pip -y \
    && apt-get install --no-install-recommends g++-multilib -y \
    && apt-get install --no-install-recommends mono-complete -y \
    && apt-get install --no-install-recommends gnupg-curl -y \
    && apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;

# install gcc-4.4 required by Peach
RUN add-apt-repository --keyserver hkps://keyserver.ubuntu.com:443 ppa:ubuntu-toolchain-r/test -y \
    && apt-get update -y \
    && apt-get install --no-install-recommends gcc-4.4 -y \
    && apt-get install --no-install-recommends g++-4.4 -y \
    && apt-get install --no-install-recommends git -y \
    && apt-get install --no-install-recommends wget -y \
    && apt-get install --no-install-recommends unzip -y \
    && apt-get install --no-install-recommends tzdata -y && rm -rf /var/lib/apt/lists/*;

# setup work directory
RUN mkdir -p /home/wd \
    && chown afl:afl /home/wd

WORKDIR /home/wd
USER afl

# setup aflsmart
RUN git clone https://github.com/aflsmart/aflsmart \
    && cd aflsmart \
    && make clean all

WORKDIR /home/wd/aflsmart

# setup peach
RUN wget https://sourceforge.net/projects/peachfuzz/files/Peach/3.0/peach-3.0.202-source.zip \
    && unzip peach-3.0.202-source.zip \
    && patch -p1 < peach-3.0.202.patch \
    && cd peach-3.0.202-source \
    && CC=gcc-4.4 CXX=g++-4.4 ./waf configure \
    && CC=gcc-4.4 CXX=g++4.4 ./waf install
