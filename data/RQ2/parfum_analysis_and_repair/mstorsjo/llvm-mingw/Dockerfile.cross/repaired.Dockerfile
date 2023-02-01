# Cross compile an llvm-mingw toolchain for windows.
#
# This needs to be built with --build-arg BASE=<image>, where image is the name
# of a docker image that contains a working llvm-mingw cross compiler
# from a similar enough version.
#
# This builds LLVM and all other build tools that need to run on the target
# platform, but just copies over the runtime libraries from the existing
# toolchain in the base docker image.

ARG BASE=mstorsjo/llvm-mingw:dev
FROM $BASE

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -qqy libltdl-dev swig autoconf-archive && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

COPY build-python.sh .

ARG WITH_PYTHON

RUN if [ -n "$WITH_PYTHON" ]; then \
        ./build-python.sh /opt/python; \
    fi

ENV PATH=/opt/python/bin:$PATH

ARG CROSS_ARCH=x86_64
ENV CROSS_TOOLCHAIN_PREFIX=/opt/llvm-mingw-$CROSS_ARCH

ENV HOST=$CROSS_ARCH-w64-mingw32

RUN if [ -n "$WITH_PYTHON" ]; then \
        ./build-python.sh $CROSS_TOOLCHAIN_PREFIX/python --host=$HOST && \
        mkdir -p $CROSS_TOOLCHAIN_PREFIX/bin && \
        cp $CROSS_TOOLCHAIN_PREFIX/python/bin/*.dll $CROSS_TOOLCHAIN_PREFIX/bin; \
    fi

ARG FULL_LLVM

COPY build-llvm.sh .
RUN if [ -n "$WITH_PYTHON" ]; then ARG="--with-python"; fi && \
    ./build-llvm.sh $CROSS_TOOLCHAIN_PREFIX --host=$HOST $ARG

COPY build-lldb-mi.sh .
RUN ./build-lldb-mi.sh $CROSS_TOOLCHAIN_PREFIX --host=$HOST

COPY strip-llvm.sh .
RUN ./strip-llvm.sh $CROSS_TOOLCHAIN_PREFIX --host=$HOST

ARG TOOLCHAIN_ARCHS="i686 x86_64 armv7 aarch64"

COPY build-mingw-w64.sh build-mingw-w64-tools.sh ./
RUN ./build-mingw-w64-tools.sh $CROSS_TOOLCHAIN_PREFIX --skip-include-triplet-prefix --host=$HOST

COPY wrappers/*.sh wrappers/*.c wrappers/*.h ./wrappers/
COPY install-wrappers.sh .
RUN ./install-wrappers.sh $CROSS_TOOLCHAIN_PREFIX --host=$HOST

COPY prepare-cross-toolchain.sh .
RUN ./prepare-cross-toolchain.sh $TOOLCHAIN_PREFIX $CROSS_TOOLCHAIN_PREFIX $CROSS_ARCH

COPY build-make.sh .
RUN ./build-make.sh $CROSS_TOOLCHAIN_PREFIX --host=$HOST

ARG TAG
RUN ln -s $CROSS_TOOLCHAIN_PREFIX llvm-mingw-$TAG$CROSS_ARCH && \
    zip -9r /llvm-mingw-$TAG$CROSS_ARCH.zip llvm-mingw-$TAG$CROSS_ARCH && \
    ls -lh /llvm-mingw-$TAG$CROSS_ARCH.zip
