FROM ubuntu:16.04
MAINTAINER Brian Anderson <banderson@mozilla.com>

RUN apt-get update

# Baseline tools
RUN apt-get install --no-install-recommends -y build-essential \
     git file python2.7 \
     perl curl git libc6-dev-i386 gcc-multilib g++-multilib llvm llvm-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get build-dep -y clang llvm

# Package compatibility

# Servo
RUN apt-get install --no-install-recommends -y libz-dev \
    freeglut3-dev \
    libfreetype6-dev libgl1-mesa-dri libglib2.0-dev xorg-dev \
    gperf g++ cmake python-virtualenv \
    libssl-dev libbz2-dev libosmesa6-dev libxmu6 libxmu-dev && rm -rf /var/lib/apt/lists/*;

# sdl2
RUN apt-get install --no-install-recommends -y libsdl2-dev && rm -rf /var/lib/apt/lists/*;

# rustqlite
RUN apt-get install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

# netlib-provider
RUN apt-get install --no-install-recommends -y gfortran && rm -rf /var/lib/apt/lists/*;

# gdk-sys
RUN apt-get install --no-install-recommends -y libgtk-3-dev && rm -rf /var/lib/apt/lists/*;
