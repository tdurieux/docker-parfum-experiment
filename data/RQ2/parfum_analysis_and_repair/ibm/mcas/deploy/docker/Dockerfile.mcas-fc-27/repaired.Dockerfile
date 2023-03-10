FROM fedora:32
RUN dnf -y --nodocs --setopt=install_weak_deps=False install \
wget git emacs vim automake cmake3 git make gcc-c++ make libtool \
python3 python3-devel python3-pip pkg-config bash-completion \
libudev-devel json-c-devel libuuid-devel uuid-devel kmod-libs kmod-devel rapidjson-devel \
numactl-devel elfutils-libelf-devel gperftools-devel libaio-devel libcurl-devel zlib-devel \
boost boost-devel boost-python3 boost-python3-devel \
libstdc++-devel libstdc++-static glibc-static glibc-devel diffutils valgrind valgrind-devel
RUN useradd -ms /bin/bash mcasuser
USER mcasuser
WORKDIR /home/mcasuser
RUN mkdir -p ~/mcas/src
WORKDIR /home/mcasuser/mcas/src
RUN git clone -b pymm https://github.com/IBM/mcas.git
WORKDIR /home/mcasuser/mcas/src/mcas
RUN git submodule update --init --recursive
USER root
WORKDIR /home/mcasuser/mcas/src/mcas/deps
RUN ./install-yum-fc27.sh
USER mcasuser
RUN cp /home/mcasuser/mcas/src/mcas/src/python/pymm/sample.py /home/mcasuser
USER mcasuser
WORKDIR /home/mcasuser/mcas/src/mcas
RUN src/python/install-python-deps.sh
RUN rm -rf build && mkdir -p build
WORKDIR /home/mcasuser/mcas/src/mcas/build
RUN cmake -DBUILD_KERNEL_SUPPORT=OFF \
-DBUILD_MCAS_SERVER=ON \
-DBUILD_MCAS_CLIENT=ON \
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