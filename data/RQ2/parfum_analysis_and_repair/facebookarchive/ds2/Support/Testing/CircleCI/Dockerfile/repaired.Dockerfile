##
## Copyright (c) 2014-present, Facebook, Inc.
## All rights reserved.
##
## This source code is licensed under the University of Illinois/NCSA Open
## Source License found in the LICENSE file in the root directory of this
## source tree. An additional grant of patent rights can be found in the
## PATENTS file in the same directory.
##

# BEFORE PUSHING A NEW DOCKER IMAGE, PLEASE READ ALL OF THESE INSTRUCTIONS!
#
# To build a docker image using this file, run the following command:
#     docker build --file Support/Testing/CircleCI/Dockerfile .
#
# After building the image, you will see a line like this at the end of the
# build process:
#     Successfully built 360abf8e6246
#
# This hash identifies the image you just built. You can then run it locally
# with the following command:
#     docker run --privileged --security-opt seccomp:unconfined --rm -it --name ds2-testing 360abf8e6246
# We run in privileged mode so that we may use ptrace to its full
# extent as needed.
#
# When building a new docker image, it's important to tag it by the date and
# time you built the image so that we can revert to an older image if something
# goes wrong when we build the new one.
# For example, if you built the image on November 1st, 2018 at 4:20:00 pm, your tag
# would be something like: 2018-11-01_16-20-00.
#
# Publishing the image for use by CircleCI is done with:
#     docker tag 360abf8e6246 sas42/ds2-build-env:<tag>
#     docker push sas42/ds2-build-env:<tag>
#
# Alternatively, you can tag immediately after the build is finished via:
#     docker build --file Support/Testing/CircleCI/Dockerfile --tag 2018-09-07_12-34-56

FROM ubuntu:16.04
MAINTAINER Stephane Sezer <sas@fb.com>

# Install apt tools
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties wget && rm -rf /var/lib/apt/lists/*;

# In case lldb needs built
RUN apt-get install --no-install-recommends -y libz-dev swig ncurses-dev && rm -rf /var/lib/apt/lists/*;

# Make the developer's life not suck
RUN apt-add-repository -y ppa:neovim-ppa/stable
RUN apt-get update -y
RUN apt-get -y --no-install-recommends install sudo zsh tmux curl vim neovim && rm -rf /var/lib/apt/lists/*;

# Debugging tools
RUN apt-get install --no-install-recommends -y strace htop psmisc && rm -rf /var/lib/apt/lists/*;

# Python 3.7 and misc
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y python3.7 && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.7
RUN python3.7 -m pip install --upgrade pip
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install --upgrade pip

# Add LLVM apt repos
RUN wget -O - "https://llvm.org/apt/llvm-snapshot.gpg.key" | apt-key add -
RUN add-apt-repository -y "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main"
RUN apt-get update

# Install build dependencies
RUN apt-get install --no-install-recommends -y ninja-build && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y flex bison && rm -rf /var/lib/apt/lists/*;

# Install x86 compilers
RUN apt-get install --no-install-recommends -y g++-multilib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang-7 && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/clang-7 /usr/local/bin/clang
RUN ln -s /usr/bin/clang++-7 /usr/local/bin/clang++

# Install arm compilers
RUN apt-get install --no-install-recommends -y g++-multilib-arm-linux-gnueabi && rm -rf /var/lib/apt/lists/*;

# Install mingw compilers
RUN apt-get install --no-install-recommends -y g++-mingw-w64-x86-64 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++-mingw-w64-i686 && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --set i686-w64-mingw32-gcc /usr/bin/i686-w64-mingw32-gcc-posix
RUN update-alternatives --set i686-w64-mingw32-g++ /usr/bin/i686-w64-mingw32-g++-posix
RUN update-alternatives --set x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix
RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix

# Install test dependencies
RUN apt-get install --no-install-recommends -y git lldb-7 python-lldb-7 gdb clang-format-7 make dejagnu && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/lldb-7 /usr/local/bin/lldb
RUN ln -s /usr/bin/clang-format-7 /usr/local/bin/clang-format

# Install documentation dependencies
RUN apt-get install --no-install-recommends -y doxygen graphviz && rm -rf /var/lib/apt/lists/*;

# Create multilib symlink for gcc 4.9
RUN ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/asm

# Install Android toolchains with our local script
COPY Support/Scripts/common.sh /tmp
COPY Support/Scripts/prepare-android-ndk.py /tmp
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN /tmp/prepare-android-ndk.py
RUN ln -s /tmp/android-sdk-linux/platform-tools/adb /usr/local/bin/adb

# Install a version of cmake that is at least the minimum version we support.
COPY Support/Testing/CircleCI/install-cmake.sh /tmp
RUN /tmp/install-cmake.sh

# Install Android emulators
RUN apt-get install --no-install-recommends -y default-jdk && rm -rf /var/lib/apt/lists/*;
COPY Support/Scripts/install-android-emulator.sh /tmp
RUN /tmp/install-android-emulator.sh arm
RUN /tmp/install-android-emulator.sh arm64
RUN /tmp/install-android-emulator.sh x86
