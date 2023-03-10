# https://hub.docker.com/r/ethcscs/mpich
# VV=ethcscs/mpich:ub1804_cuda92_mpi314
# DD=Dockerfile.ubuntu1804lts+cuda92+mpich314
# docker build -f ./$DD -t $VV .
# docker push $VV
# docker run -it $VV bash
# docker run $VV cat /etc/os-release
FROM nvidia/cuda:9.2-devel-ubuntu18.04

RUN apt-get update \
    && apt-get install -y file \
                          g++ \
                          gcc \
                          gfortran \
                          make \
                          gdb \
                          strace \
                          wget \
                          unzip \
                          --no-install-recommends && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp \
    && wget -q https://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz \
    && tar xf mpich-3.1.4.tar.gz \
    && cd mpich-3.1.4 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-fortran --enable-fast=all,O3 --prefix=/usr \
    && make -j3 \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mpich-3.1.4.tar.gz mpich-3.1.4

# ubuntu/18.04 bionic -> gcc/6.5, gcc/7.4 (=default), gcc/8.3 (+ clang-7)
# -----------------   gcc/4   gcc/5   gcc/6   gcc/7   gcc/8   gcc/9
# cuda/09.2 < gcc/8   Y       Y       Y       Y       -       -
# cuda/10.0 < gcc/8   Y       Y       Y       Y       -       -
# cuda/10.1 < gcc/9   Y       Y       Y       Y       Y       -
RUN apt install -y g++-7 g++-8 --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# ppa -> gcc/9.1
# https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/test?field.series_filter=bionic
RUN apt install --no-install-recommends -y software-properties-common \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt update \
    && apt install --no-install-recommends -y g++-9 && rm -rf /var/lib/apt/lists/*;
