FROM ubuntu:bionic-20200403


# build environment for osxcross

# download XCode (7.3.1) from https://developer.apple.com/download/more/?name=Xcode%207.3.1
# extract the sdk tarball using the following instructions:
# https://github.com/tpoechtrager/osxcross#packing-the-sdk-on-linux---method-2-works-up-to-xcode-73
ARG XCODE_SDK=

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake git patch clang \
    libbz2-dev fuse libfuse-dev libxml2-dev gcc g++ \
    zlib1g-dev libmpc-dev libmpfr-dev libgmp-dev libc++-dev \
    libssl-dev curl bc wget \
    autoconf automake libtool make yasm nasm \
    scons mingw-w64 mingw-w64-tools && rm -rf /var/lib/apt/lists/*;

# use posix variant of mingw
RUN update-alternatives --set x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix
RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix

RUN git clone --depth=1 https://github.com/tpoechtrager/osxcross.git /opt/osxcross

# TODO: ln this from a volume instead?
COPY ./darwin_sdk/* /opt/osxcross/tarballs/

RUN cmake --version
RUN [ -z "$XCODE_SDK" ] || (cd /opt/osxcross && UNATTENDED=1 ./build.sh)
RUN [ -z "$XCODE_SDK" ] || (echo "building gcc"; cd /opt/osxcross && UNATTENDED=1 ./build_gcc.sh)

WORKDIR /opt/godot-videodecoder/
