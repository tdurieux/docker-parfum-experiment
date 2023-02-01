FROM ubuntu:trusty

RUN apt-get -qq update && apt-get install --no-install-recommends -y -qq autopoint automake autoconf intltool libc6-dev yasm libglib2.0-bin perl wget zip bzip2 make libtool pkg-config fakeroot clang && rm -rf /var/lib/apt/lists/*;

