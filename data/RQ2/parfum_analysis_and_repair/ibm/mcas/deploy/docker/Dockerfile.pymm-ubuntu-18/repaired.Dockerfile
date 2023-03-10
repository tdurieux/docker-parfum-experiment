FROM ubuntu:18.04 AS ubuntu18
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt-get install --no-install-recommends -y wget git emacs vim autoconf automake \
cmake gcc g++ git make python3 python3-numpy libtool-bin pkg-config \
libnuma-dev libboost-system-dev libboost-iostreams-dev libboost-program-options-dev \
libboost-filesystem-dev libboost-date-time-dev \
libudev-dev libboost-python-dev libkmod-dev libjson-c-dev \
libelf-dev libgoogle-perftools-dev libcurl4-openssl-dev \
uuid-dev gnutls-dev libgnutls30 valgrind \
lcov libzmq5-dev libczmq-dev \
python3-setuptools python3-pip \
libc6-dev libstdc++-6-dev && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash mcasuser
USER mcasuser
WORKDIR /home/mcasuser
RUN mkdir -p ~/mcas/src
WORKDIR /home/mcasuser/mcas/src
RUN git clone -b pymm https://github.com/IBM/mcas.git
WORKDIR /home/mcasuser/mcas/src/mcas
RUN git submodule update --init --recursive
RUN cp /home/mcasuser/mcas/src/mcas/src/python/pymm/sample.py /home/mcasuser
RUN src/python/install-python-deps.sh
RUN rm -rf build && mkdir -p build
WORKDIR /home/mcasuser/mcas/src/mcas/build
RUN cmake -DBUILD_KERNEL_SUPPORT=OFF \
-DBUILD_MCAS_SERVER=OFF \
-DBUILD_MCAS_CLIENT=OFF \
-DBUILD_EXAMPLES_PMDK=OFF \
-DBUILD_RUST=OFF \
-DBUILD_PYTHON_SUPPORT=ON \
-DBUILD_MPI_APPS=OFF \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX:PATH=/home/mcasuser/mcas/ ..
RUN make bootstrap
RUN make
RUN make install
WORKDIR /home/mcasuser
CMD ["/bin/bash"]
