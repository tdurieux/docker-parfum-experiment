FROM ubuntu:20.04

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    build-essential \
    ca-certificates \
    locales \
    software-properties-common \
    wget \
 && apt-get clean \
 && locale-gen en_US.UTF-8 \
 && update-locale LANG=en_US.UTF-8

# Install CMake from a distribution
RUN mkdir -p /opt/cmake-inst \
 && cd /opt/cmake-inst \
 && wget -O dist.tar.gz https://cmake.org/files/v3.21/cmake-3.21.2-linux-x86_64.tar.gz \
 && tar xzf dist.tar.gz \
 && mv cmake-* /opt/cmake \
 && rm -rf /opt/cmake-inst
ENV PATH="/opt/cmake/bin:${PATH}"

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
 && add-apt-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-12 main" \
 && apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    lld \
    clang-12 \
    gcc-9 g++-9 \
    gcc-10 g++-10 \
    fish \
    git \
    libssl-dev \
    ninja-build \
    graphviz \
    gdb \
    valgrind \
 && apt-get clean \
 && update-alternatives --install /usr/bin/cc cc $(which clang-12) 100 \
 && update-alternatives --install /usr/bin/c++ c++ $(which clang++-12) 100

ENV IDLE_VM=1
ENV IDLE_INTERNAL_LOGLEVEL=2

ENV LSAN_OPTIONS=verbosity=1:log_threads=1:abort_on_error=1
ENV ASAN_OPTIONS=verbosity=1:log_threads=1:abort_on_error=1:use_odr_indicator=1
ENV MSAN_OPTIONS=verbosity=1:log_threads=1:abort_on_error=1
ENV UBSAN_OPTIONS=print_stacktrace=1:symbolize=1:halt_on_error=1:print_summary=1

CMD mkdir -p /home/persistent/build \
 && cd /home/persistent/build \
 && echo "- Building target: '${BUILD_TARGET}'" \
 && echo "- Building type: '${BUILD_TYPE}'" \
 && cmake -GNinja -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
          -DIDLE_WITH_INTERNAL_LOG=ON \
          -DIDLE_WITH_ASAN=${IDLE_WITH_ASAN} \
          -DIDLE_WITH_TSAN=${IDLE_WITH_TSAN} \
          -DIDLE_WITH_MSAN=${IDLE_WITH_MSAN} \
          -DIDLE_WITH_UBSAN=${IDLE_WITH_UBSAN} \
          -DCMAKE_CXX_FLAGS="-ftemplate-backtrace-limit=0" /home/src \
 && ninja ${BUILD_TARGET}
