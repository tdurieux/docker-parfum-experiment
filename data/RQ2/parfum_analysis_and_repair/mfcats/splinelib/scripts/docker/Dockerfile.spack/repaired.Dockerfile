# Build on top of ubuntu
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    SPACK_ROOT=/usr/local \
    FORCE_UNSAFE_CONFIGURE=1 \
    OCLINT_HOME=/spack/oclint-0.13.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    autoconf \
    ca-certificates \
    curl \
    environment-modules \
    git \
    build-essential \
    python \
    nano \
    sudo \
    unzip \
    python-pip \
    lcov \
    gfortran-8 \
    gcc-8 \
    gfortran-7 \
    gcc-7 \
    llvm-5.0 \
    llvm-6.0 \
    clang-5.0 \
    clang-6.0 \
    libstdc++-6-dev \
    libstdc++-7-dev \
    libstdc++-8-dev \
    clang-tidy \
    cppcheck \
    wget \
    gfortran \
    g++-8 \
    valgrind \
    && rm -rf /var/lib/apt/lists/*

RUN curl -f -s -L https://api.github.com/repos/llnl/spack/tarball | tar xzC $SPACK_ROOT --strip 1
RUN echo ". $SPACK_ROOT/share/spack/setup-env.sh" > /etc/profile.d/spack.sh
RUN spack bootstrap
RUN spack compiler find
RUN sed -i -e 's/null/\/usr\/bin\/gfortran/g' ~/.spack/linux/compilers.yaml
RUN spack compiler list
RUN spack clean -a

# startup
CMD /bin/bash -l
